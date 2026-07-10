import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/menu_item.dart';

const _kCartKey = 'rita-cart';

/// Cart state
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get subtotal => items.fold(0, (sum, i) => sum + i.total);
  int get grandTotal => subtotal; // GST & delivery = 0 in Phase 1
  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  CartState copyWith({List<CartItem>? items}) =>
      CartState(items: items ?? this.items);

  int getItemQuantity(String id) {
    final item = items.where((i) => i.id == id).firstOrNull;
    return item?.quantity ?? 0;
  }
}

/// Cart Notifier — matches web CartContext useReducer logic
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kCartKey);
      if (raw != null) {
        final list = (jsonDecode(raw) as List)
            .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
            .toList();
        state = CartState(items: list);
      }
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(state.items.map((e) => e.toJson()).toList());
      await prefs.setString(_kCartKey, encoded);
    } catch (_) {}
  }

  void addItem(MenuItem item, {int quantity = 1, String? customId, String? customName, int? customPrice}) {
    final targetId = customId ?? item.id;
    final targetName = customName ?? item.name;
    final targetPrice = customPrice ?? item.price;

    final existing = state.items.indexWhere((i) => i.id == targetId);
    List<CartItem> updated;
    if (existing >= 0) {
      updated = [...state.items];
      updated[existing] = updated[existing]
          .copyWith(quantity: updated[existing].quantity + quantity);
    } else {
      updated = [
        ...state.items,
        CartItem(
          id: targetId,
          name: targetName,
          price: targetPrice,
          image: item.image,
          isAsset: item.isAsset,
          quantity: quantity,
        ),
      ];
    }
    state = CartState(items: updated);
    _save();
  }

  void removeItem(String id) {
    state = CartState(items: state.items.where((i) => i.id != id).toList());
    _save();
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    state = CartState(
      items: state.items
          .map((i) => i.id == id ? i.copyWith(quantity: quantity) : i)
          .toList(),
    );
    _save();
  }

  void clear() {
    state = const CartState(items: []);
    _save();
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
