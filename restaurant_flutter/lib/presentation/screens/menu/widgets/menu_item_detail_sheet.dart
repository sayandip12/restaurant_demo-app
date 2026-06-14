import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/shared/shared_widgets.dart';

/// Item detail bottom sheet — matches MenuItemModal.jsx
class MenuItemDetailSheet extends ConsumerWidget {
  final MenuItem item;
  const MenuItemDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(cartProvider.select((s) => s.getItemQuantity(item.id)));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s8),
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    child: MenuItemImage(
                      image: item.image,
                      isAsset: item.isAsset,
                      width: double.infinity,
                      height: 220,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  // Header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VegIndicator(isVeg: item.isVeg, size: 18),
                      const SizedBox(width: AppSpacing.s2),
                      Expanded(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  // Rating + badge row
                  Row(
                    children: [
                      RatingChip(rating: item.rating),
                      const SizedBox(width: AppSpacing.s2),
                      ItemBadge(badge: item.badge),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  // Price
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Price',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary)),
                          Text(
                            '₹${item.price}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          if (item.priceL != null)
                            Text('Large: ₹${item.priceL}',
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s6),
                  // Add / stepper
                  if (qty == 0)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ref.read(cartProvider.notifier).addItem(item);
                          showAppToast(context, '${item.name} added to cart!');
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: QuantityStepper(
                            quantity: qty,
                            size: 40,
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
                        ),
                        const SizedBox(width: AppSpacing.s4),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.check),
                          label: const Text('Done'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s6, vertical: AppSpacing.s4),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
