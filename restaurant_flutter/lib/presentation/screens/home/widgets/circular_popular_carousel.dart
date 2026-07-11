import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../providers/cart_provider.dart';
import '../../menu/widgets/menu_item_detail_sheet.dart';

import '../../../../data/static/menu_data.dart';

class CircularPopularCarousel extends ConsumerStatefulWidget {
  const CircularPopularCarousel({super.key});

  @override
  ConsumerState<CircularPopularCarousel> createState() =>
      _CircularPopularCarouselState();
}

class _CircularPopularCarouselState
    extends ConsumerState<CircularPopularCarousel> {
  final Map<String, String> _popularImages = {
    'Chicken Kasha': 'assets/images/popular/Chicken_Kasha.jpg',
    'Egg Chicken Biryani': 'assets/images/popular/Egg.Chicken_Biryani.jpg',
    'Paneer Butter Masala': 'assets/images/popular/Paneer_Butter_Masala.jpg',
    'Egg Chicken Noodle': 'assets/images/popular/Egg.chicken_Noodles.jpg',
    'Chicken Steam Momo (6 pcs)':
        'assets/images/popular/Chicken_Steam_Momo_(6pcs).jpg',
    'Chilli Chicken (6 pcs)': 'assets/images/popular/Chilli_Chicken_(6pcs).jpg',
    'Chicken Satay (2 pcs)': 'assets/images/popular/ChickenSatay(2pcs).jpg',
    'Lachha Paratha': 'assets/images/popular/Laccha_Paratha.jpg',
    'Jeera Rice': 'assets/images/popular/Jeera_Rice.jpg',
  };

  List<MenuItem> _items = [];
  int _currentIndex = 0;
  Timer? _timer;
  Timer? _pauseTimer;

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
          (item) =>
              item.name == name ||
              item.name.contains(
                  name.replaceAll(' (6 pcs)', '').replaceAll(' (2 pcs)', '')),
          orElse: () => allItems.first,
        );
      }).toList();
      _items = _items.toSet().toList();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pauseTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _items.length;
      });
    });
  }

  void _handleSwipe(bool isLeft) {
    _timer?.cancel();
    _pauseTimer?.cancel();
    setState(() {
      if (isLeft) {
        _currentIndex = (_currentIndex + 1) % _items.length;
      } else {
        _currentIndex = (_currentIndex - 1 + _items.length) % _items.length;
      }
    });
    _pauseTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) _startTimer();
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

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
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
                    Text('See All',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Carousel + Info Card stacked inside a clipped container
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _handleSwipe(true); // Swipe left -> Next
            } else if (details.primaryVelocity! > 0) {
              _handleSwipe(false); // Swipe right -> Previous
            }
          },
          child: Container(
            height: 300,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                // Render dishes
                ..._buildDishes(screenWidth),
                // Bottom Info Card (placed on top of the dishes)
                Positioned(
                  bottom: 0,
                  left: 16,
                  right: 16,
                  child: _buildInfoCard(_items[_currentIndex]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDishes(double screenWidth) {
    final List<Widget> list = [];

    for (int index = 0; index < _items.length; index++) {
      // Wrap diff
      int diff = index - _currentIndex;
      int halfLen = _items.length ~/ 2;
      if (diff < -halfLen) diff += _items.length;
      if (diff > _items.length - halfLen - 1) diff -= _items.length;

      // Only show visible slots (from -3 to +3)
      if (diff.abs() > 3) continue;

      double angle = (pi / 2) - (diff * (pi / 5.0));
      const double radius = 200.0;
      final double centerY = 80.0 + radius;

      final double x = cos(angle) * radius;
      final double y = -sin(angle) * radius;

      double scale = 0.0;
      double opacity = 0.0;
      bool isVisible = false;

      if (diff == 0) {
        scale = 1.0;
        opacity = 1.0;
        isVisible = true;
      } else if (diff.abs() == 1) {
        scale = 0.65;
        opacity = 0.9;
        isVisible = true;
      } else if (diff.abs() == 2) {
        scale = 0.45;
        opacity = 0.6;
        isVisible = true;
      } else if (diff.abs() == 3) {
        scale = 0.25;
        opacity = 0.0;
        isVisible = true;
      }

      const double baseSize = 160.0;

      list.add(
        AnimatedPositioned(
          key: ValueKey(_items[index].id),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          left: screenWidth / 2 - (baseSize / 2) + x,
          top: centerY + y - (baseSize / 2),
          child: IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              opacity: opacity,
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: Container(
                    width: baseSize,
                    height: baseSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: diff == 0
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              )
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                    ),
                    child: ClipOval(
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(diff == 0 ? 6 : 4),
                        child: ClipOval(
                          child: Image.asset(
                            _popularImages[_items[index].name] ??
                                _items[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Sort to ensure the center item is drawn last (on top of others)
    list.sort((a, b) {
      int getDiff(Key? key) {
        if (key == null) return 100;
        final id = (key as ValueKey).value as String;
        int idx = _items.indexWhere((item) => item.id == id);
        int diff = idx - _currentIndex;
        int halfLen = _items.length ~/ 2;
        if (diff < -halfLen) diff += _items.length;
        if (diff > _items.length - halfLen - 1) diff -= _items.length;
        return diff.abs();
      }

      return getDiff(b.key).compareTo(getDiff(a.key));
    });

    return list;
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
              color: Colors.black.withValues(alpha: 0.05),
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
                mainAxisSize: MainAxisSize.min,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Half ₹${item.price}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Full ₹${item.priceL}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
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
              mainAxisSize: MainAxisSize.min,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 14, color: Colors.white),
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
