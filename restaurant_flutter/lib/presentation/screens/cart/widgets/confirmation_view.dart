import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/receipt_generator.dart';
import '../../../../domain/entities/order.dart';

/// Confirmation screen — step 3 of cart wizard
/// Shows success, order ID, receipt, and actions
class ConfirmationView extends StatelessWidget {
  final Order order;
  final VoidCallback onNewOrder;

  const ConfirmationView(
      {super.key, required this.order, required this.onNewOrder});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s4),
      children: [
        // Success animation
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 48),
            ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: AppSpacing.s4),
            Text('Order Placed!',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primary,
                    )),
            const SizedBox(height: AppSpacing.s2),
            Text('Your order has been received',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    )),
          ],
        ),
        const SizedBox(height: AppSpacing.s4),

        // Order ID card
        Container(
          padding: const EdgeInsets.all(AppSpacing.s4),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.receipt_outlined, color: AppColors.primary),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order ID',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    Text(order.id,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.primary)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy,
                    size: 18, color: AppColors.textMuted),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: order.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order ID copied!')),
                  );
                },
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

        const SizedBox(height: AppSpacing.s4),

        // Thermal receipt
        Container(
          height: 400,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: PdfPreview(
              build: (format) => ReceiptGenerator.generatePdf(order),
              allowPrinting: false,
              allowSharing: false,
              canChangeOrientation: false,
              canChangePageFormat: false,
              initialPageFormat: PdfPageFormat.roll80,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: AppSpacing.s4),

        // Action buttons
        _ActionButtons(order: order),
        const SizedBox(height: AppSpacing.s4),

        // New order button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onNewOrder,
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Order More Food'),
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Order order;

  const _ActionButtons({required this.order});

  Future<void> _sendWhatsApp(BuildContext context) async {
    final msg = '🛒 *NEW ORDER*\n\n'
        'Order: ${order.id}\n'
        'Customer: ${order.customerName}\n'
        'Phone: ${order.phone}\n'
        'Amount: ₹${order.total}\n\n'
        'Receipt PDF:\n${order.receiptUrl ?? ''}\n\n'
        'Open PDF and print.';
    final encoded = Uri.encodeComponent(msg);
    final url = 'https://wa.me/917003764902?text=$encoded';
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open WhatsApp: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _sendWhatsApp(context),
            icon: const Icon(Icons.send),
            label: const Text('Send Order via WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s3),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final bytes = await ReceiptGenerator.generatePdf(order);
                  await Printing.sharePdf(
                    bytes: bytes,
                    filename: 'receipt-${order.id}.pdf',
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                label: const Text('Save PDF'),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  if (order.receiptUrl != null &&
                      order.receiptUrl!.isNotEmpty) {
                    await Share.share(
                        'Here is my order receipt: ${order.receiptUrl}');
                  } else {
                    final bytes = await ReceiptGenerator.generatePdf(order);
                    await Printing.sharePdf(
                      bytes: bytes,
                      filename: 'receipt-${order.id}.pdf',
                    );
                  }
                },
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text('Share PDF'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
