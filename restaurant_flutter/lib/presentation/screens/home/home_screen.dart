import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import 'widgets/circular_popular_carousel.dart';
import 'widgets/home_header.dart';
import 'widgets/status_bar_widget.dart';
import 'widgets/hero_section.dart';
import 'widgets/feature_cards.dart';
import 'widgets/free_delivery_banner.dart';
import 'widgets/footer_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFDFBF7), // Cream background as per reference
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                const HomeHeader(),
                SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      StatusBarWidget(),
                      SizedBox(height: AppSpacing.s4),
                      HeroSection(),
                      SizedBox(height: AppSpacing.s4),
                      FeatureCards(),
                      SizedBox(height: AppSpacing.s8),
                      CircularPopularCarousel(),
                      SizedBox(height: AppSpacing.s8),
                      FreeDeliveryBanner(),
                      SizedBox(height: AppSpacing.s8),
                      FooterInfo(),
                      SizedBox(height: AppSpacing.s8),
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
