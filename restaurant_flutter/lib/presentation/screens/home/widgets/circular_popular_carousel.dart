import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/menu_provider.dart';
import '../../menu/widgets/menu_item_detail_sheet.dart';

import '../../../../data/static/menu_data.dart';

class CircularPopularCarousel extends ConsumerStatefulWidget {
  const CircularPopularCarousel({super.key});

  @override
  ConsumerState<CircularPopularCarousel> createState() => _CircularPopularCarouselState();
}

class _CircularPopularCarouselState extends ConsumerState<CircularPopularCarousel> {
  final Map<String, String> _popularImages = {
    'Chicken Kasha': 'assets/images/popular/Chicken_Kasha.jpg',
    'Egg Chicken Biryani': 'assets/images/popular/Egg.Chicken_Biryani.jpg',
    'Paneer Butter Masala': 'assets/images/popular/Paneer_Butter_Masala.jpg',
    'Egg Chicken Noodle': 'assets/images/popular/Egg.chicken_Noodles.jpg', // Name in menu_data is 'Egg Chicken Noodle'
    'Chicken Steam Momo (6 pcs)': 'assets/images/popular/Chicken_Steam_Momo_(6pcs).jpg',
    'Chilli Chicken (6 pcs)': 'assets/images/popular/Chilli_Chicken_(6pcs).jpg',
    'Chicken Satay (2 pcs)': 'assets/images/popular/ChickenSatay(2pcs).jpg',
    'Lachha Paratha': 'assets/images/popular/Laccha_Paratha.jpg',
    'Jeera Rice': 'assets/images/popular/Jeera_Rice.jpg',
  };

  List<MenuItem> _items = [];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_items.isEmpty) {
      final allItems = getAllItems();
      _items = _popularImages.keys.map<MenuItem>((name) {
        return allItems.firstWhere(
          (item) => item.name == name || item.name.contains(name.replaceAll(' (6 pcs)', '').replaceAll(' (2 pcs)', '')),
          orElse: () => allItems.first,
        );
      }).toList();
      // De-duplicate just in case
      _items = _items.toSet().toList();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _items.length;
      });
    });
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) {
      context.push('/menu');
    } else {
      setState(() {
        _currentIndex = index;
      });
      _timer?.cancel();
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Dishes',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/menu'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                children: [
                  Text('See All', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Carousel Area
        SizedBox(
          height: 310,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Dashed circle placeholder
              CustomPaint(
                size: const Size(300, 300),
                painter: _DashedCirclePainter(color: AppColors.primary.withOpacity(0.5)),
              ),
              // Items
              ...List.generate(_items.length, (index) {
                // Calculate position on the circle
                int diff = index - _currentIndex;
                if (diff < -_items.length / 2) diff += _items.length;
                if (diff > _items.length / 2) diff -= _items.length;

                final double angle = (pi / 2) + (diff * (2 * pi / _items.length));
                final bool isCenter = diff == 0;

                const double radius = 120.0;
                final double x = cos(angle) * radius;
                final double y = sin(angle) * radius - 50; 

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  left: 150 + x - (isCenter ? 90 : 35),
                  top: 150 + y - (isCenter ? 90 : 35),
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    child: GestureDetector(
                      onTap: () => _onItemTapped(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        width: isCenter ? 180 : 70,
                        height: isCenter ? 180 : 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: isCenter
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 10),
                                  )
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                        ),
                        child: ClipOval(
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(isCenter ? 6 : 3),
                            child: ClipOval(
                              child: Image.asset(
                                _popularImages[_items[index].name] ?? _items[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        // Info Card for Center Item
        const SizedBox(height: 10),
        _buildInfoCard(_items[_currentIndex]),
      ],
    );
  }

  Widget _buildInfoCard(MenuItem item) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(item.id),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                _popularImages[item.name] ?? item.image,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item.priceL != null)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Half ₹${item.price}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Full ₹${item.priceL}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Price & Add to Cart
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${item.priceL ?? item.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    if (item.priceL != null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => MenuItemDetailSheet(item: item),
                      );
                    } else {
                      ref.read(cartProvider.notifier).addItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.name} added to cart')),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double radius = 120.0;
    final Offset center = Offset(size.width / 2, size.height / 2 - 50);

    const int dashCount = 30;
    const double dashLength = (pi) / (dashCount * 2);
    
    for (int i = 0; i < dashCount; i++) {
      final double startAngle = pi + (i * 2 * dashLength);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
