import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/cart_item.dart';
import '../../core/utils/order_id_generator.dart';
import '../../core/utils/receipt_generator.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_strings.dart';

enum OrderStatus { idle, loading, success, error }

class OrderState {
  final OrderStatus status;
  final Order? order;
  final String? error;

  const OrderState({
    this.status = OrderStatus.idle,
    this.order,
    this.error,
  });

  OrderState copyWith({OrderStatus? status, Order? order, String? error}) =>
      OrderState(
        status: status ?? this.status,
        order: order ?? this.order,
        error: error ?? this.error,
      );
}

class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier() : super(const OrderState());

  final _supabase = Supabase.instance.client;

  Future<bool> placeOrder({
    required List<CartItem> items,
    required String customerName,
    required String phone,
    required String address,
    required String pincode,
    required String landmark,
    required String notes,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);

    final orderId = await OrderIdGenerator.generate();
    final now = DateTime.now().toUtc();
    final subtotal = items.fold(0, (sum, i) => sum + i.total);

    debugPrint('[OrderNotifier] ==========================================');
    debugPrint('[OrderNotifier] Starting order: $orderId');
    debugPrint('[OrderNotifier] Customer: $customerName | Phone: $phone');
    debugPrint('[OrderNotifier] Items: ${items.length} | Total: ₹$subtotal');

    var order = Order(
      id: orderId,
      customerName: customerName,
      phone: phone,
      address: address,
      pincode: pincode,
      landmark: landmark,
      notes: notes,
      items: items,
      subtotal: subtotal,
      total: subtotal,
      status: 'pending',
      createdAt: now,
    );

    // ── STEP 1: Generate PDF ──────────────────────────────────────────────
    String? localPdfPath;
    String? pdfUrl;
    try {
      debugPrint('[OrderNotifier] STEP 1: Generating PDF...');
      final pdfBytes = await ReceiptGenerator.generatePdf(order);
      debugPrint(
          '[OrderNotifier] PDF Generated: TRUE. Size: ${pdfBytes.length} bytes');

      // ── STEP 2: Save PDF locally & Upload to Supabase ──────────────────────
      debugPrint('[OrderNotifier] STEP 2: Saving PDF locally and uploading...');
      final tempDir = await getTemporaryDirectory();
      localPdfPath = '${tempDir.path}/$orderId.pdf';
      final file = File(localPdfPath);
      await file.writeAsBytes(pdfBytes);

      debugPrint('PDF Path: $localPdfPath');
      debugPrint('PDF Size: ${pdfBytes.length} bytes');
      debugPrint('Bucket: receipts');

      try {
        final uploadResp = await _supabase.storage.from('receipts').upload(
              'orders/$orderId.pdf',
              file,
              fileOptions: const FileOptions(
                upsert: true,
                contentType: 'application/pdf',
              ),
            );
        debugPrint('Upload Response: $uploadResp');
      } catch (uploadErr) {
        debugPrint('Upload Error: $uploadErr');
      }

      pdfUrl = _supabase.storage
          .from('receipts')
          .getPublicUrl('orders/$orderId.pdf');
      debugPrint('Public URL: $pdfUrl');
    } catch (pdfErr) {
      debugPrint('[OrderNotifier] !! PDF GENERATION/UPLOAD FAILED !!');
      debugPrint('[OrderNotifier] Error: $pdfErr');
    }

    // ── STEP 3: Insert into DB ────────────────────────────────────────────
    try {
      debugPrint('[OrderNotifier] STEP 3: Inserting into Supabase DB...');
      final userId = _supabase.auth.currentUser?.id;
      final Map<String, dynamic> payload = {
        'order_number': order.id,
        'customer_name': order.customerName,
        'phone': order.phone,
        'address':
            '${order.address}${order.pincode.isNotEmpty ? ', PIN: ${order.pincode}' : ''}',
        'landmark': order.landmark,
        'notes': order.notes,
        'items': order.items.map((e) => e.toJson()).toList(),
        'subtotal': order.subtotal,
        'total': order.total,
        'status': order.status,
        'created_at': order.createdAt.toIso8601String(),
      };
      if (userId != null) {
        payload['user_id'] = userId;
      }

      await _supabase.from('orders').insert(payload);
      debugPrint('[OrderNotifier] DB Insert: SUCCESS | Order: $orderId');
    } catch (dbErr) {
      debugPrint('[OrderNotifier] !! DB INSERT FAILED !!');
      debugPrint('[OrderNotifier] Error: $dbErr');
    }

    // ── STEP 4: Share PDF URL to WhatsApp ─────────────────────────────────────
    try {
      debugPrint('[OrderNotifier] STEP 4: Opening Share flow...');
      var msg = '🛒 *NEW ORDER*\n\n'
          'Order: ${order.id}\n'
          'Customer: ${order.customerName}\n'
          'Phone: ${order.phone}\n'
          'Amount: ₹${order.total}\n';

      if (pdfUrl != null) {
        msg += '\n🧾 Receipt PDF:\n$pdfUrl';
      }

      final encodedMsg = Uri.encodeComponent(msg);
      final phone = AppStrings.whatsappNumber;
      final uri = Uri.parse('whatsapp://send?phone=$phone&text=$encodedMsg');

      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e1) {
        // Fallback to wa.me link
        try {
          final webUri = Uri.parse('https://wa.me/$phone?text=$encodedMsg');
          await launchUrl(webUri, mode: LaunchMode.externalApplication);
        } catch (e2) {
          // Ultimate fallback to generic share
          await Share.share(msg);
        }
      }
      debugPrint('[OrderNotifier] Share flow opened successfully.');
    } catch (waErr) {
      debugPrint('[OrderNotifier] Share launch failed: $waErr');
    }

    // ── STEP 5: Save locally for Order History ────────────────────────────
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyStr = prefs.getString('local_order_history');
      List<dynamic> history = historyStr != null ? jsonDecode(historyStr) : [];

      final orderJson = order.toJson();
      if (localPdfPath != null) {
        orderJson['local_pdf_path'] = localPdfPath;
      }

      history.insert(0, orderJson);
      if (history.length > 7) {
        history = history.sublist(0, 7);
      }
      await prefs.setString('local_order_history', jsonEncode(history));
    } catch (e) {
      debugPrint('[OrderNotifier] Failed to save local order history: $e');
    }

    debugPrint('[OrderNotifier] ==========================================');
    state = state.copyWith(status: OrderStatus.success, order: order);
    return true;
  }

  void reset() {
    state = const OrderState();
  }
}

final orderProvider =
    StateNotifierProvider<OrderNotifier, OrderState>((ref) => OrderNotifier());

/// Fetch a single order by ID (for receipt page)
final orderByIdProvider =
    FutureProvider.family<Order?, String>((ref, orderId) async {
  try {
    final data = await Supabase.instance.client
        .from('orders')
        .select()
        .eq('order_number', orderId)
        .single();
    debugPrint(
        '[orderByIdProvider] Loaded: $orderId | receipt_url: ${data['receipt_url']}');
    return Order.fromSupabase(data);
  } catch (e) {
    debugPrint('[orderByIdProvider] Failed to load $orderId: $e');
    return null;
  }
});

/// Fetch current user's orders from last 30 days
final myOrdersProvider = FutureProvider<List<Order>>((ref) async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('[myOrdersProvider] No authenticated user.');
      return [];
    }
    final thirtyDaysAgo =
        DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
    final data = await Supabase.instance.client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .gte('created_at', thirtyDaysAgo)
        .order('created_at', ascending: false)
        .limit(7);
    debugPrint(
        '[myOrdersProvider] Found ${(data as List).length} orders for user $userId');
    return (data).map((row) => Order.fromSupabase(row)).toList();
  } catch (e) {
    debugPrint('[myOrdersProvider] Error: $e');
    return [];
  }
});

/// Admin: fetch all orders
final allOrdersProvider = FutureProvider<List<Order>>((ref) async {
  try {
    final data = await Supabase.instance.client
        .from('orders')
        .select()
        .order('created_at', ascending: false)
        .limit(100);
    return (data as List)
        .map((row) => Order.fromSupabase(row as Map<String, dynamic>))
        .toList();
  } catch (e) {
    debugPrint('[allOrdersProvider] Error: $e');
    return [];
  }
});
