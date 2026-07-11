import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/shared/shared_widgets.dart';

class MenuItemCard extends ConsumerWidget {
  final MenuItem item;
  final VoidCallback? onTap;

  const MenuItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty =
        ref.watch(cartProvider.select((s) => s.getItemQuantity(item.id)));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg)),
              child: Stack(
                children: [
                  MenuItemImage(
                    image: item.image,
                    isAsset: item.isAsset,
                    width: double.infinity,
                    height: 120,
                  ),
                  // Veg indicator top-left
                  Positioned(
                    top: 8,
                    left: 8,
                    child: VegIndicator(isVeg: item.isVeg),
                  ),
                  // Badge top-right
                  if (item.badge != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ItemBadge(badge: item.badge),
                    ),
                  // Rating bottom-right
                  if (item.rating > 0)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: RatingChip(rating: item.rating),
                    ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${item.price}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            if (item.priceL != null)
                              Text(
                                'L: ₹${item.priceL}',
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                        if (!item.available)
                          const Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else if (qty == 0)
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(cartProvider.notifier).addItem(item);
                              showAppToast(
                                  context, '${item.name} added to cart');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusFull),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        else
                          QuantityStepper(
                            quantity: qty,
                            size: 24,
                            onIncrease: () {
                              HapticFeedback.lightImpact();
                              ref.read(cartProvider.notifier).addItem(item);
                            },
                            onDecrease: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(item.id, qty - 1);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
