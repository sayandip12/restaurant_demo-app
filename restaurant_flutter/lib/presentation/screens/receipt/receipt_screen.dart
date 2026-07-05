import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/receipt_generator.dart';
import '../../providers/order_provider.dart';

class ReceiptScreen extends ConsumerWidget {
  final String orderId;
  const ReceiptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Receipt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load order: $e')),
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Order not found'));
          }

          return Column(
            children: [
              // 1. Receipt Preview
              Expanded(
                child: PdfPreview(
                  build: (format) => ReceiptGenerator.generatePdf(order),
                  allowPrinting: false,
                  allowSharing: false,
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  initialPageFormat: PdfPageFormat.roll80,
                ),
              ),
              
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(AppSpacing.s4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(color: AppColors.gray200, blurRadius: 4, offset: const Offset(0, -2))
                  ]
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (order.receiptUrl != null && order.receiptUrl!.isNotEmpty) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // Open PDF directly
                              final url = order.receiptUrl!;
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              }
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('View PDF in Browser'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s3),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final bytes = await ReceiptGenerator.generatePdf(order);
                                await Printing.sharePdf(
                                  bytes: bytes,
                                  filename: 'Receipt_${order.id}.pdf',
                                );
                              },
                              icon: const Icon(Icons.download, size: 18),
                              label: const Text('Download PDF'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s3),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                if (order.receiptUrl != null && order.receiptUrl!.isNotEmpty) {
                                  // Share the public URL
                                  await Share.share('Here is my order receipt: ${order.receiptUrl}');
                                } else {
                                  // Fallback to sharing the PDF file itself
                                  final bytes = await ReceiptGenerator.generatePdf(order);
                                  await Printing.sharePdf(
                                    bytes: bytes,
                                    filename: 'Receipt_${order.id}.pdf',
                                  );
                                }
                              },
                              icon: const Icon(Icons.share, size: 18),
                              label: const Text('Share PDF'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
