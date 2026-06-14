import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(AppSpacing.s6),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.person, size: 36, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Guest User',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text('Login to save your orders and addresses',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: AppSpacing.s3),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(100, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Login / Sign Up', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s6),
          
          Text('Account & Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  )),
          const SizedBox(height: AppSpacing.s3),
          
          _MenuTile(
            icon: Icons.receipt_long_outlined,
            title: 'My Orders',
            subtitle: 'View your past orders',
            onTap: () => context.push('/track'),
          ),
          _MenuTile(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            subtitle: 'Manage delivery addresses',
            onTap: () {},
          ),
          _MenuTile(
            icon: Icons.local_offer_outlined,
            title: 'Offers & Coupons',
            subtitle: 'Available discounts',
            onTap: () => context.push('/offers'),
          ),
          
          const SizedBox(height: AppSpacing.s6),
          Text('Support & About',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  )),
          const SizedBox(height: AppSpacing.s3),
          
          _MenuTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Contact us for any issues',
            onTap: () => context.push('/contact'),
          ),
          _MenuTile(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Restaurant Admin',
            subtitle: 'Manage orders (Staff only)',
            onTap: () => context.push('/admin'),
          ),
          _MenuTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => context.push('/privacy-policy'),
          ),
          
          const SizedBox(height: AppSpacing.s8),
          Center(
            child: Text(
              'App Version 1.0.0\nMade with ❤️ by Rita Foodland',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s2),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))
            : null,
        trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      ),
    );
  }
}
