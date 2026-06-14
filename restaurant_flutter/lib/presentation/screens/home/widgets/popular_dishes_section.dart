import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/shared/shared_widgets.dart';

class PopularDishesSection extends ConsumerWidget {
  const PopularDishesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(popularItemsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeader(
              title: 'Popular Dishes',
              subtitle: 'Our bestsellers and top picks',
            ),
            TextButton(
              onPressed: () => context.go('/menu'),
              child: const Text('See All →'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s4),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, i) => _PopularCard(item: items[i], index: i),
          ),
        ),
      ],
    );
  }
}

class _PopularCard extends ConsumerWidget {
  final dynamic item;
  final int index;
  const _PopularCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(cartProvider.select((s) => s.getItemQuantity(item.id)));

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
            child: Stack(
              children: [
                MenuItemImage(
                  image: item.image,
                  isAsset: item.isAsset,
                  width: 150,
                  height: 105,
                ),
                if (item.badge != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: ItemBadge(badge: item.badge),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    VegIndicator(isVeg: item.isVeg, size: 12),
                    const SizedBox(width: 4),
                    RatingChip(rating: item.rating),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${item.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                    if (qty == 0)
                      GestureDetector(
                        onTap: () {
                          ref.read(cartProvider.notifier).addItem(item);
                          showAppToast(context, '${item.name} added to cart');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('ADD',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      )
                    else
                      QuantityStepper(
                        quantity: qty,
                        size: 22,
                        onIncrease: () => ref.read(cartProvider.notifier).addItem(item),
                        onDecrease: () {
                          final n = qty - 1;
                          ref.read(cartProvider.notifier).updateQuantity(item.id, n);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 80)).fadeIn().slideX(begin: 0.1);
  }
}
