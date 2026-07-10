import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  static const _steps = [
    _StepData(
        Icons.check_circle, 'Pending', 'Your order has been received', true),
    _StepData(
        Icons.thumb_up, 'Accepted', 'Restaurant accepted your order', true),
    _StepData(
        Icons.restaurant, 'Preparing', 'Kitchen is preparing your food', true),
    _StepData(Icons.delivery_dining, 'Out for Delivery', 'Rider is on the way',
        false),
    _StepData(Icons.home, 'Delivered', 'Enjoy your meal!', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Track Order')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter Order ID',
              hintText: 'ORD-YYYYMMDD-XXXX',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(60, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Track', style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s6),

          // Demo order card
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text('Sample Order Tracking',
                        style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.orange100,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text('Preparing',
                          style: TextStyle(
                              color: AppColors.orange600,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s4),
                // Timeline
                ...List.generate(_steps.length, (i) {
                  final step = _steps[i];
                  final isLast = i == _steps.length - 1;
                  return IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: step.done
                                    ? AppColors.primary
                                    : AppColors.border,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(step.icon,
                                  size: 16,
                                  color: step.done
                                      ? AppColors.white
                                      : AppColors.textMuted),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: step.done
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: AppSpacing.s3),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(step.title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: step.done
                                            ? AppColors.primary
                                            : AppColors.textSecondary)),
                                Text(step.subtitle,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate(delay: Duration(milliseconds: i * 150))
                      .fadeIn()
                      .slideX(begin: 0.1);
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.green100),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Our delivery team will call you at your registered number before arriving.',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.primaryDark),
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

class _StepData {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool done;
  const _StepData(this.icon, this.title, this.subtitle, this.done);
}
