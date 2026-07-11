import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../providers/menu_provider.dart';

class FooterInfo extends ConsumerWidget {
  const FooterInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(restaurantSettingsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(
            0xFFFAF3E6), // Soft warm tone matching the bottom of screenshot
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.location_on_outlined, color: Colors.black87, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text('J.N. Ghosh, Kalyani, Nadia',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule_outlined, color: Colors.black87, size: 16),
              const SizedBox(width: 8),
              Text('Monday - Sunday | ',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600)),
              Text('${settings.openingTime} - ${settings.closingTime}',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('tel:+91${AppStrings.phone1}');
                    if (await canLaunchUrl(uri)) launchUrl(uri);
                  },
                  icon: const Icon(Icons.call,
                      size: 16, color: AppColors.primary),
                  label: const Text('Call Us',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => GoRouter.of(context).push('/menu'),
                  icon: const Icon(Icons.restaurant_menu,
                      size: 16, color: Colors.white),
                  label: const Text('View Menu',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
