import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../widgets/shared/shared_widgets.dart';

const _kReviews = [
  _ReviewData(
      'Priya Sharma',
      '⭐⭐⭐⭐⭐',
      'The chicken biryani here is absolutely divine! Rich flavors, tender meat, and perfectly cooked rice. Will definitely order again!',
      'Kalyani'),
  _ReviewData(
      'Rahul Das',
      '⭐⭐⭐⭐⭐',
      'Best tandoori chicken in Kalyani! The marinade is perfect and the chicken is so juicy. Great value for money.',
      'Nadia'),
  _ReviewData(
      'Anjali Roy',
      '⭐⭐⭐⭐⭐',
      'The momos are incredible! Perfectly steamed with delicious filling. The spicy dipping sauce is addictive.',
      'Kalyani'),
  _ReviewData(
      'Arijit Banerjee',
      '⭐⭐⭐⭐',
      'Fast delivery and hot food! The chicken roll is my weekly go-to. Egg coating is perfect every time.',
      'Kalyanivasi'),
  _ReviewData(
      'Shubha Ghosh',
      '⭐⭐⭐⭐⭐',
      'Paneer butter masala is restaurant-quality at home prices! Family loved the entire thali. Highly recommend!',
      'Kalyani'),
];

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'What Our Customers Say',
          subtitle: '500+ happy customers and counting',
        ),
        const SizedBox(height: AppSpacing.s4),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _kReviews.length,
            itemBuilder: (_, i) => _ReviewCard(review: _kReviews[i], index: i),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final _ReviewData review;
  final int index;
  const _ReviewCard({required this.review, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: AppSpacing.s3),
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Text(review.name[0],
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.name,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontSize: 13)),
                    Text(review.location,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(review.stars, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: AppSpacing.s2),
          Text(
            review.text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  height: 1.4,
                ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: index * 80))
        .fadeIn()
        .slideX(begin: 0.1);
  }
}

class _ReviewData {
  final String name;
  final String stars;
  final String text;
  final String location;
  const _ReviewData(this.name, this.stars, this.text, this.location);
}
