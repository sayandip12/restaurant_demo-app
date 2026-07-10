import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../providers/cart_provider.dart';

class PriceSummaryCard extends StatelessWidget {
  final CartState cartState;
  const PriceSummaryCard({super.key, required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Details', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s3),
          _Row('Item Total', '₹${cartState.subtotal}'),
          const SizedBox(height: AppSpacing.s2),
          _Row('Delivery Charge', 'FREE', valueColor: AppColors.veg),
          const SizedBox(height: AppSpacing.s2),
          _Row('GST', 'Incl. in price',
              valueColor: AppColors.textMuted, valueSize: 12),
          const Divider(height: AppSpacing.s6),
          _Row('Grand Total', '₹${cartState.grandTotal}',
              bold: true, valueColor: AppColors.primary),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  final double? valueSize;

  const _Row(this.label, this.value,
      {this.bold = false, this.valueColor, this.valueSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: bold ? 16 : 14,
              color: bold ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            )),
        Text(value,
            style: TextStyle(
              fontSize: valueSize ?? (bold ? 16 : 14),
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            )),
      ],
    );
  }
}
