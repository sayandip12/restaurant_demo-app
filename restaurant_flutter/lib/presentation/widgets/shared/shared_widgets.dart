import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Veg/Non-Veg indicator dot — matches CSS .veg-indicator
class VegIndicator extends StatelessWidget {
  final bool isVeg;
  final double size;

  const VegIndicator({super.key, required this.isVeg, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? AppColors.veg : AppColors.nonVeg;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Container(
          width: size * 0.5,
          height: size * 0.5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

/// Rating chip — green badge with star
class RatingChip extends StatelessWidget {
  final double rating;
  const RatingChip({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    if (rating == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.green600,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 10, color: AppColors.white),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Item badge (bestseller / chef / most-ordered)
class ItemBadge extends StatelessWidget {
  final String? badge;
  const ItemBadge({super.key, this.badge});

  @override
  Widget build(BuildContext context) {
    if (badge == null) return const SizedBox.shrink();
    final (Color bg, Color fg, String label) = switch (badge!) {
      'bestseller' => (AppColors.orange100, AppColors.orange600, '🔥 Bestseller'),
      'chef' => (const Color(0xFFFEF3C7), const Color(0xFF92400E), '👨‍🍳 Chef\'s Pick'),
      'most-ordered' => (AppColors.primaryLight, AppColors.primaryDark, '⭐ Most Ordered'),
      _ => (AppColors.gray100, AppColors.gray600, badge!),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// WhatsApp floating action button
class WhatsAppFab extends StatelessWidget {
  final VoidCallback onTap;
  const WhatsAppFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: const Color(0xFF25D366),
      foregroundColor: Colors.white,
      elevation: 4,
      tooltip: 'Chat on WhatsApp',
      child: const Icon(Icons.chat, size: 26),
    );
  }
}

/// Section header matching web .section-title style
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ],
    );
  }
}

/// Reusable loading spinner
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2,
      ),
    );
  }
}

/// Quantity stepper widget
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final double size;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onDecrease,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(6),
              color: AppColors.backgroundSecondary,
            ),
            child: const Icon(Icons.remove, size: 14, color: AppColors.primary),
          ),
        ),
        SizedBox(
          width: 32,
          child: Center(
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onIncrease,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.add, size: 14, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

/// Menu item image widget (handles both asset and network)
class MenuItemImage extends StatelessWidget {
  final String image;
  final bool isAsset;
  final double? width;
  final double? height;
  final BoxFit fit;

  const MenuItemImage({
    super.key,
    required this.image,
    required this.isAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (isAsset) {
      return Image.asset(
        image,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return Image.network(
      image,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _placeholder(),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.backgroundTertiary,
      child: const Icon(Icons.restaurant, color: AppColors.border, size: 32),
    );
  }
}

/// Show a snackbar toast
void showAppToast(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.danger : AppColors.gray800,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2500),
    ),
  );
}
