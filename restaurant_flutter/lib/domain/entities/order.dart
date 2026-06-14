import 'package:flutter/foundation.dart';
import 'cart_item.dart';

@immutable
class Order {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final String landmark;
  final String notes;
  final List<CartItem> items;
  final int subtotal;
  final int total;
  final String status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.landmark,
    required this.notes,
    required this.items,
    required this.subtotal,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'order_number': id,
        'customer_name': customerName,
        'phone': phone,
        'address': address,
        'landmark': landmark,
        'notes': notes,
        'items': items.map((e) => e.toJson()).toList(),
        'subtotal': subtotal,
        'total': total,
        'status': status,
        'created_at': createdAt.toIso8601String(),
      };

  factory Order.fromSupabase(Map<String, dynamic> row) => Order(
        id: row['order_number'] as String,
        customerName: row['customer_name'] as String,
        phone: row['phone'] as String,
        address: row['address'] as String,
        landmark: (row['landmark'] as String?) ?? '',
        notes: (row['notes'] as String?) ?? '',
        items: ((row['items'] as List?) ?? [])
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: _parseInt(row['subtotal']),
        total: _parseInt(row['total']),
        status: row['status'] as String,
        createdAt: DateTime.parse(row['created_at'] as String),
      );

  static int _parseInt(dynamic val) {
    if (val is int) return val;
    if (val is double) return val.round();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }
}
