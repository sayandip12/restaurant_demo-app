import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

          final receiptText = ReceiptGenerator.generate(order);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s4),
            children: [
              Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  child: Text(
                    receiptText,
                    style: const TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 11,
                      height: 1.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final doc = pw.Document();
                        doc.addPage(pw.Page(
                          pageFormat: PdfPageFormat.roll80,
                          build: (_) => pw.Text(
                            receiptText,
                            style: pw.TextStyle(
                              font: pw.Font.courier(),
                              fontSize: 10,
                            ),
                          ),
                        ));
                        await Printing.sharePdf(
                          bytes: await doc.save(),
                          filename: 'receipt-$orderId.pdf',
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
                        await Share.share(receiptText, subject: 'Order Receipt - $orderId');
                      },
                      icon: const Icon(Icons.share_outlined, size: 16),
                      label: const Text('Share Text'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
