import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../widgets/shared/shared_widgets.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Coupons'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: const [
          _OfferCard(
            title: 'Welcome Discount',
            description:
                'Get 10% off on your first order. Use code at checkout or mention on WhatsApp.',
            code: 'WELCOME10',
            icon: Icons.celebration,
            color: AppColors.accent,
          ),
          SizedBox(height: AppSpacing.s4),
          _OfferCard(
            title: 'Free Delivery',
            description:
                'Free delivery on all orders above ₹500. Valid for Kalyani region only.',
            code: 'FREEDEL',
            icon: Icons.delivery_dining,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.s4),
          _OfferCard(
            title: 'Weekend Special',
            description:
                'Flat ₹50 off on Biryani Combos every Saturday and Sunday.',
            code: 'WKND50',
            icon: Icons.restaurant,
            color: Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String code;
  final IconData icon;
  final Color color;

  const _OfferCard({
    required this.title,
    required this.description,
    required this.code,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusLg)),
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: AppSpacing.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                  )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        )),
                const SizedBox(height: AppSpacing.s4),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s3),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                        color: AppColors.border, style: BorderStyle.solid),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(code,
                          style: const TextStyle(
                            fontFamily: 'Courier New',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 2,
                            color: AppColors.textPrimary,
                          )),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: code));
                          showAppToast(context, 'Coupon code copied!');
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.copy,
                                size: 16, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text('COPY',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
