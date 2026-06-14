import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s4),
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text('Last updated: June 14, 2026', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          
          _Section(
            title: '1. Information We Collect',
            content: 'When you use Rita Foodland app to place orders, we collect the following information:\n• Full Name\n• Phone Number\n• Delivery Address\n• Order History\n\nThis information is stored securely and is only used to fulfill your orders and improve our service.',
          ),
          
          _Section(
            title: '2. How We Use Your Information',
            content: 'We use your information to:\n• Process and deliver your food orders\n• Contact you regarding your order status via Phone or WhatsApp\n• Send order receipts and invoices\n• Address customer support inquiries',
          ),
          
          _Section(
            title: '3. Data Sharing',
            content: 'We do not sell, trade, or rent your personal identification information to others. Your delivery details are only shared with our delivery personnel strictly for fulfilling your order.',
          ),
          
          _Section(
            title: '4. Third-Party Services',
            content: 'We use Supabase as our secure database provider. Your data is stored securely in their encrypted cloud infrastructure. We use WhatsApp for order communication, subject to WhatsApp\'s privacy policies.',
          ),
          
          _Section(
            title: '5. Contact Us',
            content: 'If you have any questions about this Privacy Policy, please contact us at:\nPhone: 7003764902\nAddress: J.N. Colony, Kalyani, Nadia',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.gray900)),
          const SizedBox(height: AppSpacing.s2),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.gray700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
