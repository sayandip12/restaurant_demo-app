import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import 'widgets/circular_popular_carousel.dart';
import '../../widgets/shared/shared_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Cream background as per reference
      body: Stack(
        children: [
          // Background Kolkata image
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/hero/kolkata_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildStatusBar(),
                      const SizedBox(height: AppSpacing.s4),
                      _buildHeroSection(context),
                      const SizedBox(height: AppSpacing.s4),
                      _FeatureCardsStrip(),
                      const SizedBox(height: AppSpacing.s8),
                      const CircularPopularCarousel(),
                      const SizedBox(height: AppSpacing.s8),
                      _buildFreeDeliveryBanner(),
                      const SizedBox(height: AppSpacing.s8),
                      _FooterInfoStrip(),
                      const SizedBox(height: AppSpacing.s8),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black, size: 28),
        onPressed: () {},
      ),
      title: Row(
        children: [
          Image.asset('assets/images/logo.png', height: 32, fit: BoxFit.contain),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rita Foodland',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              Text(
                'AUTHENTIC CUISINE',
                style: TextStyle(
                  color: AppColors.accent.withOpacity(0.9),
                  letterSpacing: 1.5,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.security_outlined, color: Colors.black87),
          onPressed: () {},
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              const Text('Open Now', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.schedule, size: 14, color: Colors.black54),
              SizedBox(width: 4),
              Text('09:00 AM - 11:00 PM', style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.moped_outlined, size: 16, color: Colors.black87),
              const SizedBox(width: 4),
              const Text('30-40 mins', style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Text Area
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/images/logo.png', // Using the uploaded typography/logo as an image to ensure exact match
                  height: 90,
                  alignment: Alignment.centerLeft,
                ),
                const SizedBox(height: 12),
                const Text(
                  'AUTHENTIC CUISINE',
                  style: TextStyle(
                    color: AppColors.accent,
                    letterSpacing: 2,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enjoy the best flavours\ncrafted with love and\nauthentic ingredients.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('/menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Order Now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Right Imagery Area
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 280,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Chef image (center-right)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/hero/chef.png',
                      height: 230,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Chicken rice top plate
                  Positioned(
                    top: -10,
                    right: 10,
                    child: Image.asset(
                      'assets/images/hero/chicken_rice.png',
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Onion decoration
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Image.asset(
                      'assets/images/hero/onion.png',
                      height: 45,
                      fit: BoxFit.contain,
                    ).animate(onPlay: (ctrl) => ctrl.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
                  ),
                  // Badge (bottom right)
                  Positioned(
                    bottom: 20,
                    right: -10,
                    child: Container(
                      width: 75,
                      height: 75,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E7D3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "KOLKATA'S\nFAVOURITE",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Color(0xFF4A3424), height: 1.1),
                          ),
                          const Text(
                            "FOOD DESTINATION",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 5, color: Color(0xFF4A3424)),
                          ),
                          const SizedBox(height: 2),
                          const Icon(Icons.favorite, size: 10, color: Color(0xFF4A3424)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeDeliveryBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3EA), // Soft green background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Scooter left
          const Icon(Icons.moped, color: AppColors.primary, size: 40),
          // Text center
          Column(
            children: const [
              Text('FREE DELIVERY', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
              SizedBox(height: 2),
              Text('On orders above ₹199', style: TextStyle(color: Colors.black87, fontSize: 12)),
            ],
          ),
          // Scooter right (flipped)
          Transform.flip(
            flipX: true,
            child: const Icon(Icons.moped, color: AppColors.primary, size: 40),
          ),
        ],
      ),
    );
  }
}

class _FeatureCardsStrip extends StatelessWidget {
  static const _features = [
    _FeatureData(Icons.schedule, 'Fast\nDelivery', '30-40 mins', Colors.blueAccent),
    _FeatureData(Icons.star, 'Top Rated', '4.8+ Stars', Colors.amber),
    _FeatureData(Icons.eco, 'Fresh Ingredients', 'Daily Fresh', Colors.green),
    _FeatureData(Icons.monetization_on, 'Best Price', 'Fair Value', Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Row(
        children: _features
            .map((f) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(f.icon, color: f.color, size: 24),
                        const SizedBox(height: 8),
                        Text(
                          f.title,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 9, color: Colors.black87),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          f.subtitle,
                          style: const TextStyle(fontSize: 8, color: Colors.black54),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _FeatureData(this.icon, this.title, this.subtitle, this.color);
}

class _FooterInfoStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3E6), // Soft warm tone matching the bottom of screenshot
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
                    style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.schedule_outlined, color: Colors.black87, size: 16),
              SizedBox(width: 8),
              Text('Monday - Sunday | ', style: TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w600)),
              Text('09:00 AM - 11:00 PM', style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
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
                  icon: const Icon(Icons.call, size: 16, color: AppColors.primary),
                  label: const Text('Call Us', style: TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => GoRouter.of(context).push('/menu'),
                  icon: const Icon(Icons.restaurant_menu, size: 16, color: Colors.white),
                  label: const Text('View Menu', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
