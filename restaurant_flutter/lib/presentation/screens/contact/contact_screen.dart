import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contact Us'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s6),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', height: 80),
                const SizedBox(height: AppSpacing.s4),
                Text(AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium),
                Text(AppStrings.tagline,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 1.5,
                        )),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s6),
          
          _ContactCard(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '${AppStrings.phone1}\n${AppStrings.phone2}',
            action: 'Call Now',
            onTap: () async {
              final uri = Uri.parse('tel:+91${AppStrings.phone1}');
              if (await canLaunchUrl(uri)) launchUrl(uri);
            },
          ),
          const SizedBox(height: AppSpacing.s3),
          _ContactCard(
            icon: Icons.chat_outlined,
            title: 'WhatsApp',
            subtitle: AppStrings.whatsappNumber,
            action: 'Chat Now',
            onTap: () async {
              final uri = Uri.parse(AppStrings.whatsappUrl);
              if (await canLaunchUrl(uri)) {
                launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: AppSpacing.s3),
          _ContactCard(
            icon: Icons.location_on_outlined,
            title: 'Visit Us',
            subtitle: AppStrings.address,
            action: 'Get Directions',
            onTap: () async {
              final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent("Rita Foodland, J.N. Colony, Kalyani")}');
              if (await canLaunchUrl(uri)) {
                launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          const SizedBox(height: AppSpacing.s3),
          _ContactCard(
            icon: Icons.schedule_outlined,
            title: 'Opening Hours',
            subtitle: '${AppStrings.openingDays}\n${AppStrings.openingHours}',
            action: '',
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback? onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.s3),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: const TextStyle(height: 1.4)),
        ),
        trailing: onTap != null
            ? TextButton(
                onPressed: onTap,
                child: Text(action),
              )
            : null,
      ),
    );
  }
}
