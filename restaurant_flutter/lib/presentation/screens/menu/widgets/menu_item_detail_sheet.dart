import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/shared/shared_widgets.dart';

/// Item detail bottom sheet — matches MenuItemModal.jsx
class MenuItemDetailSheet extends ConsumerStatefulWidget {
  final MenuItem item;
  const MenuItemDetailSheet({super.key, required this.item});

  @override
  ConsumerState<MenuItemDetailSheet> createState() =>
      _MenuItemDetailSheetState();
}

class _MenuItemDetailSheetState extends ConsumerState<MenuItemDetailSheet> {
  bool _isLarge = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final currentPrice =
        _isLarge && item.priceL != null ? item.priceL! : item.price;
    final cartId = _isLarge && item.priceL != null ? '${item.id}-L' : item.id;
    final cartName =
        _isLarge && item.priceL != null ? '${item.name} (Full)' : item.name;

    final qty =
        ref.watch(cartProvider.select((s) => s.getItemQuantity(cartId)));

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
                  if (item.priceL != null) ...[
                    const Text('Select Portion Size',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.s2),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLarge = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isLarge
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                border: Border.all(
                                    color: !_isLarge
                                        ? AppColors.primary
                                        : AppColors.border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text('Half',
                                      style: TextStyle(
                                          fontWeight: !_isLarge
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: !_isLarge
                                              ? AppColors.primary
                                              : AppColors.textSecondary)),
                                  Text('₹${item.price}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: !_isLarge
                                              ? AppColors.primary
                                              : AppColors.textPrimary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s3),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isLarge = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isLarge
                                    ? AppColors.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                border: Border.all(
                                    color: _isLarge
                                        ? AppColors.primary
                                        : AppColors.border),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text('Full',
                                      style: TextStyle(
                                          fontWeight: _isLarge
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: _isLarge
                                              ? AppColors.primary
                                              : AppColors.textSecondary)),
                                  Text('₹${item.priceL}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _isLarge
                                              ? AppColors.primary
                                              : AppColors.textPrimary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s4),
                  ] else ...[
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Price',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                            Text(
                              '₹${item.price}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s6),
                  ],
                  if (qty == 0)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          ref.read(cartProvider.notifier).addItem(
                                item,
                                customId: cartId,
                                customName: cartName,
                                customPrice: currentPrice,
                              );
                          showAppToast(context, '$cartName added to cart!');
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.s4),
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
                              ref.read(cartProvider.notifier).addItem(
                                    item,
                                    customId: cartId,
                                    customName: cartName,
                                    customPrice: currentPrice,
                                  );
                            },
                            onDecrease: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(cartId, qty - 1);
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
                                horizontal: AppSpacing.s6,
                                vertical: AppSpacing.s4),
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
