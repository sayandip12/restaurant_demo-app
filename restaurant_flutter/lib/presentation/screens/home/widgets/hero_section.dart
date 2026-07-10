import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background layer
        Positioned.fill(
          child: Opacity(
            opacity: 0.35,
            child: Image.asset(
              'assets/images/hero/kolkata_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        // Bottom gradient fade for blending
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFDFBF7).withOpacity(0.0),
                  const Color(0xFFFDFBF7),
                ],
              ),
            ),
          ),
        ),
        // Content layer
        Padding(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Image.asset(
                            'assets/images/hero/title.png',
                            height: 105,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Image.asset(
                          'assets/images/hero/onion.png',
                          height: 35,
                          fit: BoxFit.contain,
                        )
                            .animate(
                                onPlay: (ctrl) => ctrl.repeat(reverse: true))
                            .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1),
                                duration: 2.seconds),
                      ],
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Order Now',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios,
                              size: 12, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                      // Chicken rice top plate (BEHIND CHEF)
                      Positioned(
                        top: 0,
                        right: 25,
                        child: Image.asset(
                          'assets/images/hero/chicken_rice.png',
                          height: 145,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Chef image (IN FRONT)
                      Positioned(
                        bottom: -10,
                        right: -30,
                        child: Image.asset(
                          'assets/images/hero/chef.png',
                          height: 275, // Increased height
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
