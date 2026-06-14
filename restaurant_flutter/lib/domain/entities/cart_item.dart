import 'package:flutter/foundation.dart';

@immutable
class CartItem {
  final String id;
  final String name;
  final int price;
  final String image;
  final bool isAsset;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.isAsset,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) {
    return CartItem(
      id: id,
      name: name,
      price: price,
      image: image,
      isAsset: isAsset,
      quantity: quantity ?? this.quantity,
    );
  }

  int get total => price * quantity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image': image,
        'isAsset': isAsset,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String,
        name: json['name'] as String,
        price: json['price'] as int,
        image: json['image'] as String,
        isAsset: (json['isAsset'] as bool?) ?? false,
        quantity: json['quantity'] as int,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CartItem && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
