import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/shared/shared_widgets.dart';

class SpecialitiesSection extends ConsumerWidget {
  const SpecialitiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(specialsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Chef's Specials",
          subtitle: 'Handpicked by our head chef',
        ),
        const SizedBox(height: AppSpacing.s4),
        ...items.asMap().entries.map((e) => _SpecialItem(item: e.value, index: e.key)),
      ],
    );
  }
}

class _SpecialItem extends ConsumerWidget {
  final dynamic item;
  final int index;
  const _SpecialItem({required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(cartProvider.select((s) => s.getItemQuantity(item.id)));

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s3),
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: MenuItemImage(
              image: item.image,
              isAsset: item.isAsset,
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [VegIndicator(isVeg: item.isVeg, size: 12)]),
                const SizedBox(height: 4),
                Text(item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(item.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${item.price}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontSize: 15)),
                    if (qty == 0)
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).addItem(item);
                          showAppToast(context, '${item.name} added!');
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(60, 28),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Add', style: TextStyle(fontSize: 12)),
                      )
                    else
                      QuantityStepper(
                        quantity: qty,
                        size: 26,
                        onIncrease: () => ref.read(cartProvider.notifier).addItem(item),
                        onDecrease: () =>
                            ref.read(cartProvider.notifier).updateQuantity(item.id, qty - 1),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: index * 100)).fadeIn().slideY(begin: 0.1);
  }
}
