import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../domain/entities/cart_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/shared/shared_widgets.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s3),
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: MenuItemImage(
              image: item.image,
              isAsset: item.isAsset,
              width: 64,
              height: 64,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('₹${item.price} each',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${item.total}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 15)),
              const SizedBox(height: 8),
              Row(
                children: [
                  QuantityStepper(
                    quantity: item.quantity,
                    size: 26,
                    onIncrease: () {
                      ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item.id, item.quantity + 1);
                    },
                    onDecrease: () {
                      ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item.id, item.quantity - 1);
                    },
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  GestureDetector(
                    onTap: () =>
                        ref.read(cartProvider.notifier).removeItem(item.id),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.dangerLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: AppColors.danger, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
