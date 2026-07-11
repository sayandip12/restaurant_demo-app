import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final isLoggedIn = auth.isAuthenticated;

    final displayName = user?.userMetadata?['full_name'] as String? ??
        user?.email?.split('@').first ??
        'Guest';
    final displayEmail = user?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          // ── Profile header ─────────────────────────────────────────────
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
                  child: isLoggedIn
                      ? Text(
                          displayName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        )
                      : const Icon(Icons.person,
                          size: 36, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.s4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoggedIn ? displayName : 'Guest User',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLoggedIn ? displayEmail : 'Login to save your orders',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isLoggedIn) ...[
                        const SizedBox(height: AppSpacing.s3),
                        OutlinedButton(
                          onPressed: () => context.push('/login'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(100, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                          child: const Text(
                            'Login / Sign Up',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s6),

          // ── Account section ────────────────────────────────────────────
          Text(
            'Account & Settings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.s3),

          _MenuTile(
            icon: Icons.receipt_long_outlined,
            title: 'My Orders',
            subtitle: 'View your past orders',
            onTap: () => context.push('/my-orders'),
          ),
          _MenuTile(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            subtitle: 'Manage delivery addresses',
            onTap: () => context.push('/saved-addresses'),
          ),
          _MenuTile(
            icon: Icons.local_offer_outlined,
            title: 'Offers & Coupons',
            subtitle: 'Available discounts',
            onTap: () => context.push('/offers'),
          ),

          const SizedBox(height: AppSpacing.s6),
          Text(
            'Support & About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.s3),

          _MenuTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Contact us for any issues',
            onTap: () => context.push('/contact'),
          ),

          _MenuTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => context.push('/privacy-policy'),
          ),

          // ── Logout ─────────────────────────────────────────────────────
          if (isLoggedIn) ...[
            const SizedBox(height: AppSpacing.s6),
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.s2),
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border:
                    Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.logout,
                      color: AppColors.danger, size: 20),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger,
                  ),
                ),
                subtitle: Text(
                  'Signed in as $displayEmail',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.danger,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref.read(authProvider.notifier).signOut();
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ],

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
            ? Text(subtitle!,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary))
            : null,
        trailing: const Icon(Icons.chevron_right,
            size: 20, color: AppColors.textMuted),
        onTap: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      ),
    );
  }
}
