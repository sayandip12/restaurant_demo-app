import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../providers/auth_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/receipt_generator.dart';
import '../../../domain/entities/order.dart';

// ── Provider ─────────────────────────────────────────────────────────────────

final _myOrdersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  try {
    final thirtyDaysAgo = DateTime.now()
        .subtract(const Duration(days: 30))
        .toUtc()
        .toIso8601String();
    final data = await Supabase.instance.client
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .gte('created_at', thirtyDaysAgo)
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(data as List);
  } catch (e) {
    print('Error loading orders: $e');
    return [];
  }
});

// ── Screen ────────────────────────────────────────────────────────────────────

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final ordersAsync = ref.watch(_myOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: !auth.isAuthenticated
          ? _LoginPrompt()
          : ordersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  _ErrorView(onRetry: () => ref.invalidate(_myOrdersProvider)),
              data: (orders) => orders.isEmpty
                  ? _EmptyOrders()
                  : RefreshIndicator(
                      onRefresh: () async => ref.invalidate(_myOrdersProvider),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.s4),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.s3),
                        itemBuilder: (_, i) => _OrderCard(order: orders[i]),
                      ),
                    ),
            ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _LoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined,
                size: 64, color: AppColors.border),
            const SizedBox(height: AppSpacing.s4),
            Text('Login to see your orders',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.s3),
            const Text(
              'Your order history will appear here once you log in.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s6),
            ElevatedButton.icon(
              onPressed: () => context.push('/login'),
              icon: const Icon(Icons.login),
              label: const Text('Login / Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined,
                size: 64, color: AppColors.border),
            const SizedBox(height: AppSpacing.s4),
            Text('No orders yet',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.s3),
            const Text(
              'Your order history will appear here after you place your first order.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.s6),
            ElevatedButton.icon(
              onPressed: () => context.go('/menu'),
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Browse Menu'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_outlined,
              size: 48, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.s4),
          const Text('Could not load orders',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.s3),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const _OrderCard({required this.order});

  String _formatDateTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year} • $h:$m $ampm';
    } catch (_) {
      return '';
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppColors.statusDelivered;
      case 'preparing':
        return AppColors.statusPreparing;
      case 'out_for_delivery':
        return AppColors.statusOutForDelivery;
      case 'cancelled':
        return AppColors.statusCancelled;
      default:
        return AppColors.statusPending;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'preparing':
        return 'Preparing';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderId = order['order_number'] ?? order['id'] ?? '';
    final status = order['status'] ?? 'pending';
    final total = order['total'] ?? order['subtotal'] ?? 0;
    final dateTime = _formatDateTime(order['created_at'] as String?);

    return InkWell(
      onTap: () async {
        try {
          // Reconstruct order to generate PDF
          final orderObj = Order.fromSupabase(order);
          final pdfBytes = await ReceiptGenerator.generatePdf(orderObj);

          final tempDir = await getTemporaryDirectory();
          final path = '${tempDir.path}/${orderObj.id}.pdf';
          final file = File(path);
          await file.writeAsBytes(pdfBytes);

          final xfile = XFile(path, mimeType: 'application/pdf');
          await Share.shareXFiles([xfile], text: 'Receipt for ${orderObj.id}');
        } catch (e) {
          print('Error generating receipt on tap: $e');
        }
      },
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    orderId,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.primary),
                  ),
                ),
                const Row(
                  children: [
                    Text('View Receipt ',
                        style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold)),
                    Icon(Icons.remove_red_eye_outlined,
                        size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(dateTime,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹$total',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.textPrimary),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _statusColor(status)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
