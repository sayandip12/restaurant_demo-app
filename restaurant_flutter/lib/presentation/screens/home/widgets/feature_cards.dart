import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';

class FeatureCards extends StatelessWidget {
  const FeatureCards({super.key});

  static const _features = [
    _FeatureData(
        Icons.schedule, 'Fast\nDelivery', '30-40 mins', Colors.blueAccent),
    _FeatureData(Icons.star, 'Top Rated', '4.8+ Stars', Colors.amber),
    _FeatureData(Icons.eco, 'Fresh Ingredients', 'Daily Fresh', Colors.green),
    _FeatureData(
        Icons.monetization_on, 'Best Price', 'Fair Value', Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Row(
        children: _features
            .map((f) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(f.icon, color: f.color, size: 28),
                        const SizedBox(height: 12),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            f.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            f.subtitle,
                            style: const TextStyle(
                                fontSize: 9,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
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
