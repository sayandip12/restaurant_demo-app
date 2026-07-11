import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/menu_item.dart';
import '../../data/static/menu_data.dart';

/// Menu state with search filtering
class MenuState {
  final String searchQuery;
  final String? selectedCategoryId;

  const MenuState({
    this.searchQuery = '',
    this.selectedCategoryId,
  });

  MenuState copyWith({String? searchQuery, Object? selectedCategoryId = _sentinel}) {
    return MenuState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId == _sentinel
          ? this.selectedCategoryId
          : selectedCategoryId as String?,
    );
  }
}

const _sentinel = Object();

class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier() : super(const MenuState());

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  void clear() {
    state = const MenuState();
  }
}

final menuNotifierProvider =
    StateNotifierProvider<MenuNotifier, MenuState>((ref) => MenuNotifier());

// ----------------------------------------------------
// SUPABASE REALTIME SYNC
// ----------------------------------------------------

class CategoriesNotifier extends StateNotifier<List<MenuCategory>> {
  CategoriesNotifier() : super(kMenuCategories) {
    _initSupabaseSync();
  }
  
  StreamSubscription? _catsSub;
  StreamSubscription? _itemsSub;

  Future<void> _initSupabaseSync() async {
    final supabase = Supabase.instance.client;

    // Optional: Seed Routine if menu_items is empty
    // Only runs once, silently fails if already seeded or RLS blocks
    try {
      final count = await supabase.from('menu_items').select('id').limit(1);
      if (count.isEmpty) {
        if (kDebugMode) {
          print('Seeding Supabase with kMenuCategories...');
        }
        for (var cat in kMenuCategories) {
          await supabase.from('menu_categories').upsert({
            'id': cat.id,
            'name': cat.name,
            'icon': cat.icon,
          });
          for (var item in cat.items) {
            await supabase.from('menu_items').upsert({
              'id': item.id,
              'category_id': cat.id,
              'name': item.name,
              'half_price': item.price,
              'full_price': item.priceL,
              'is_veg': item.isVeg,
              'rating': item.rating,
              'image': item.image,
              'is_asset': item.isAsset,
              'description': item.description,
              'is_available': item.available,
              'is_deleted': false,
              'badge': item.badge,
              'sort_order': 0,
            });
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Seed routine skipped or failed: $e');
      }
    }

    // Subscribe to both tables and combine them
    _catsSub = supabase.from('menu_categories').stream(primaryKey: ['id']).order('sort_order', ascending: true).listen((catData) async {
      try {
        final items = await supabase.from('menu_items').select().eq('is_deleted', false).order('sort_order', ascending: true).timeout(const Duration(seconds: 10));
        _updateState(catData, items);
      } catch (e) {
        if (kDebugMode) print('Error fetching items on cat stream update: $e');
      }
    }, onError: (err) {
      if (kDebugMode) print('Categories stream error: $err');
    });

    _itemsSub = supabase.from('menu_items').stream(primaryKey: ['id']).eq('is_deleted', false).order('sort_order', ascending: true).listen((itemData) async {
      try {
        final cats = await supabase.from('menu_categories').select().order('sort_order', ascending: true).timeout(const Duration(seconds: 10));
        _updateState(cats, itemData);
      } catch (e) {
        if (kDebugMode) print('Error fetching cats on item stream update: $e');
      }
    }, onError: (err) {
      if (kDebugMode) print('Items stream error: $err');
    });
  }
  
  @override
  void dispose() {
    _catsSub?.cancel();
    _itemsSub?.cancel();
    super.dispose();
  }

  void _updateState(List<Map<String, dynamic>> catData, List<Map<String, dynamic>> itemData) {
    if (catData.isEmpty) return;

    final List<MenuCategory> newCategories = [];
    for (var catRow in catData) {
      final items = itemData.where((i) => i['category_id'] == catRow['id'] && (i['is_deleted'] == false || i['is_deleted'] == null)).map((itemRow) {
        return MenuItem(
          id: itemRow['id'],
          name: itemRow['name'],
          price: (itemRow['half_price'] as num).toInt(),
          priceL: itemRow['full_price'] != null ? (itemRow['full_price'] as num).toInt() : null,
          isVeg: itemRow['is_veg'] ?? true,
          rating: (itemRow['rating'] as num).toDouble(),
          image: itemRow['image'],
          isAsset: itemRow['is_asset'] ?? true,
          description: itemRow['description'] ?? '',
          available: itemRow['is_available'] ?? true,
          badge: itemRow['badge'],
        );
      }).toList();

      newCategories.add(MenuCategory(
        id: catRow['id'],
        name: catRow['name'],
        icon: catRow['icon'],
        items: items,
      ));
    }

    if (newCategories.isNotEmpty) {
      state = newCategories;
    }
  }
}

/// All categories (Syncs from Supabase)
final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<MenuCategory>>((ref) {
  return CategoriesNotifier();
});

/// Filtered items based on search + category
final filteredItemsProvider = Provider<List<MenuItem>>((ref) {
  final menuState = ref.watch(menuNotifierProvider);
  final categories = ref.watch(categoriesProvider);

  final List<MenuItem> allItems = categories.expand((cat) => cat.items).toList();

  List<MenuItem> items;
  if (menuState.selectedCategoryId != null) {
    final cat = categories.firstWhere(
      (c) => c.id == menuState.selectedCategoryId,
      orElse: () => categories.first,
    );
    items = cat.items;
  } else {
    items = allItems;
  }

  final q = menuState.searchQuery.trim().toLowerCase();
  if (q.isNotEmpty) {
    items = items.where((i) => i.name.toLowerCase().contains(q)).toList();
  }

  return items;
});

/// Popular items for home page
final popularItemsProvider = Provider<List<MenuItem>>((ref) {
  final categories = ref.watch(categoriesProvider);
  final allItems = categories.expand((cat) => cat.items).toList();
  return allItems.where((i) => i.badge == 'most-ordered' || i.badge == 'bestseller').take(5).toList();
});

/// Chef specials for home page
final specialsProvider = Provider<List<MenuItem>>((ref) {
  final categories = ref.watch(categoriesProvider);
  final allItems = categories.expand((cat) => cat.items).toList();
  return allItems.where((i) => i.badge == 'chef').take(5).toList();
});

// ----------------------------------------------------
// RESTAURANT SETTINGS SYNC
// ----------------------------------------------------

class RestaurantSettings {
  final bool isOpen;
  final String openingTime;
  final String closingTime;

  const RestaurantSettings({
    this.isOpen = true,
    this.openingTime = '12:00 PM',
    this.closingTime = '12:00 AM',
  });
}

class RestaurantSettingsNotifier extends StateNotifier<RestaurantSettings> {
  RestaurantSettingsNotifier() : super(const RestaurantSettings()) {
    _initSupabaseSync();
  }
  
  StreamSubscription? _settingsSub;

  Future<void> _initSupabaseSync() async {
    final supabase = Supabase.instance.client;

    try {
      final data = await supabase.from('restaurant_settings').select().maybeSingle();
      if (data == null) {
        await supabase.from('restaurant_settings').upsert({
          'id': 1,
          'is_open': true,
          'opening_time': '12:00 PM',
          'closing_time': '12:00 AM',
        });
      }
    } catch (e) {
      if (kDebugMode) print('Settings seed error: $e');
    }

    _settingsSub = supabase.from('restaurant_settings').stream(primaryKey: ['id']).listen((data) {
      if (data.isNotEmpty) {
        final row = data.first;
        state = RestaurantSettings(
          isOpen: row['is_open'] ?? true,
          openingTime: row['opening_time'] ?? '12:00 PM',
          closingTime: row['closing_time'] ?? '12:00 AM',
        );
      }
    }, onError: (err) {
      if (kDebugMode) print('Settings stream error: $err');
    });
  }
  
  @override
  void dispose() {
    _settingsSub?.cancel();
    super.dispose();
  }
}

final restaurantSettingsProvider = StateNotifierProvider<RestaurantSettingsNotifier, RestaurantSettings>((ref) {
  return RestaurantSettingsNotifier();
});
