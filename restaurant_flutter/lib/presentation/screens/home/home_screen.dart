import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import 'widgets/popular_dishes_section.dart';
import 'widgets/specialities_section.dart';
import 'widgets/reviews_section.dart';
import '../../widgets/shared/shared_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  int _currentHero = 0;
  Timer? _heroTimer;

  static const _heroImages = [
    'assets/images/hero_restaurant_new.jpg',
    'assets/images/food/biryani.png',
    'assets/images/food/tandoori_chicken.png',
  ];

  static const _heroTitles = [
    'Enjoy Your\nFoodie Mood',
    'Authentic\nBiryani',
    'Tandoori\nDelights',
  ];

  @override
  void initState() {
    super.initState();
    _heroTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (_currentHero + 1) % _heroImages.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: WhatsAppFab(onTap: () async {
        final uri = Uri.parse(AppStrings.whatsappUrl);
        if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
      }),
      body: CustomScrollView(
        slivers: [
          // Collapsible app bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 2,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rita Foodland',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        )),
                Text('AUTHENTIC CUISINE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.accent,
                          letterSpacing: 1.5,
                          fontSize: 9,
                        )),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.local_offer_outlined, color: AppColors.textPrimary),
                tooltip: 'Offers',
                onPressed: () => context.push('/offers'),
              ),
              IconButton(
                icon: const Icon(Icons.headset_mic_outlined, color: AppColors.textPrimary),
                tooltip: 'Contact',
                onPressed: () => context.push('/contact'),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hero Slider
                _HeroSlider(
                  pageController: _pageController,
                  currentIndex: _currentHero,
                  images: _heroImages,
                  titles: _heroTitles,
                  onPageChanged: (i) => setState(() => _currentHero = i),
                ),
                // Feature cards strip
                _FeatureCardsStrip(),
                const SizedBox(height: AppSpacing.s8),
                // Popular Dishes
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                  child: PopularDishesSection(),
                ),
                const SizedBox(height: AppSpacing.s8),
                // Our Specialities
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                  child: SpecialitiesSection(),
                ),
                const SizedBox(height: AppSpacing.s8),
                // Reviews
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                  child: ReviewsSection(),
                ),
                const SizedBox(height: AppSpacing.s16),
                // Footer info strip
                _FooterInfoStrip(),
                const SizedBox(height: AppSpacing.s8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlider extends StatelessWidget {
  final PageController pageController;
  final int currentIndex;
  final List<String> images;
  final List<String> titles;
  final ValueChanged<int> onPageChanged;

  const _HeroSlider({
    required this.pageController,
    required this.currentIndex,
    required this.images,
    required this.titles,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: images.length,
            itemBuilder: (_, i) => Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  images[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.backgroundTertiary,
                    child: const Icon(Icons.restaurant, size: 60, color: AppColors.border),
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xCC000000),
                        Color(0x44000000),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Text overlay
                Positioned(
                  left: AppSpacing.s6,
                  bottom: AppSpacing.s8,
                  right: AppSpacing.s6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[i],
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ).animate(key: ValueKey(i)).fadeIn(duration: 400.ms).slideX(begin: -0.1),
                      const SizedBox(height: AppSpacing.s3),
                      ElevatedButton(
                        onPressed: () => GoRouter.of(context).go('/menu'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.s5, vertical: AppSpacing.s2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Order Now', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Dot indicators
          Positioned(
            bottom: AppSpacing.s3,
            right: AppSpacing.s4,
            child: Row(
              children: List.generate(
                images.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(left: 4),
                  width: currentIndex == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentIndex == i ? AppColors.accent : Colors.white54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCardsStrip extends StatelessWidget {
  static const _features = [
    _FeatureData('🕐', 'Fast Delivery', '30-45 min'),
    _FeatureData('⭐', 'Top Rated', '4.5+ Stars'),
    _FeatureData('🌿', 'Fresh Made', 'Daily Fresh'),
    _FeatureData('💰', 'Best Price', 'Fair Value'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.s4, horizontal: AppSpacing.s4),
      child: Row(
        children: _features
            .map((f) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: AppSpacing.s2),
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s3, horizontal: AppSpacing.s2),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        Text(f.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text(f.title,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                            textAlign: TextAlign.center),
                        Text(f.subtitle,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _FeatureData {
  final String emoji;
  final String title;
  final String subtitle;
  const _FeatureData(this.emoji, this.title, this.subtitle);
}

class _FooterInfoStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(AppStrings.address,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: const [
              Icon(Icons.schedule_outlined, color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Text('${AppStrings.openingDays} | ${AppStrings.openingHours}',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('tel:+91${AppStrings.phone1}');
                    if (await canLaunchUrl(uri)) launchUrl(uri);
                  },
                  icon: const Icon(Icons.call_outlined, size: 14),
                  label: const Text('Call Us', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => GoRouter.of(context).go('/menu'),
                  icon: const Icon(Icons.restaurant_menu, size: 14),
                  label: const Text('View Menu', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
