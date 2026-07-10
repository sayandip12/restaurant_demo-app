import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// Admin Dashboard — Coming Soon placeholder.
/// The real admin system has not been built yet.
/// Customers cannot access real order data or internal tools from here.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<void> _callOwner() async {
    final uri = Uri.parse('tel:+917003764902');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Admin',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s8),

              // ── Lock icon ──
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 42,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.s6),

              // ── Brand badge ──
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'RF',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Rita Foodland',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s6),

              // ── Title ──
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 6),

              // ── Coming Soon badge ──
              Text(
                'Coming Soon',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),

              // ── Description ──
              Text(
                'The restaurant management dashboard is currently under development. Please contact the restaurant owner for order assistance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: AppSpacing.s8),
              const Divider(),
              const SizedBox(height: AppSpacing.s6),

              // ── Planned features label ──
              Text(
                'PLANNED FEATURES',
                style: TextStyle(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),

              // ── Feature list ──
              ...[
                'Order Management & Status Tracking',
                'Real-Time Order Dashboard',
                'Customer Management',
                'Sales Analytics',
                'Menu Management',
              ].map(
                (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        feature,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s8),

              // ── Contact CTA ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _callOwner,
                  icon: const Icon(Icons.phone_outlined, size: 18),
                  label: const Text('Contact Restaurant Owner'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.s6),
            ],
          ),
        ),
      ),
    );
  }
}
