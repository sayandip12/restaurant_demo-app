import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/cart_item.dart';
import '../../core/utils/order_id_generator.dart';

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
    required String landmark,
    required String notes,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);

    final orderId = await OrderIdGenerator.generate();
    final now = DateTime.now();
    final subtotal = items.fold(0, (sum, i) => sum + i.total);

    final order = Order(
      id: orderId,
      customerName: customerName,
      phone: phone,
      address: address,
      landmark: landmark,
      notes: notes,
      items: items,
      subtotal: subtotal,
      total: subtotal,
      status: 'pending',
      createdAt: now,
    );

    // Save to Supabase (non-blocking on failure — same as web)
    try {
      await _supabase.from('orders').insert(order.toJson());
    } catch (e) {
      // Non-fatal — order is still "placed" locally
    }

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
    return Order.fromSupabase(data);
  } catch (e) {
    return null;
  }
});

/// Admin: fetch all orders, ordered by latest first
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
    return [];
  }
});
