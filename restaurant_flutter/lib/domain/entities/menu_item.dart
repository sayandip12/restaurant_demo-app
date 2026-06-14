import 'package:flutter/foundation.dart';

@immutable
class MenuItem {
  final String id;
  final String name;
  final int price;
  final int? priceL;
  final bool isVeg;
  final double rating;
  final String image; // asset path or URL
  final bool isAsset; // true = local asset
  final String description;
  final bool available;
  final String? badge; // 'bestseller', 'chef', 'most-ordered'

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.priceL,
    required this.isVeg,
    required this.rating,
    required this.image,
    required this.isAsset,
    required this.description,
    required this.available,
    this.badge,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MenuItem && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class MenuCategory {
  final String id;
  final String name;
  final String icon;
  final List<MenuItem> items;

  const MenuCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });
}
