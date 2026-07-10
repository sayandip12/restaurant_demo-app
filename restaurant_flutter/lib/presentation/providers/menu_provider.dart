import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  MenuState copyWith(
      {String? searchQuery, Object? selectedCategoryId = _sentinel}) {
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

/// All categories (static, keep-alive forever)
final categoriesProvider = Provider<List<MenuCategory>>((ref) {
  return kMenuCategories;
});

/// Filtered items based on search + category
final filteredItemsProvider = Provider<List<MenuItem>>((ref) {
  final menuState = ref.watch(menuNotifierProvider);
  final allItems = getAllItems();

  List<MenuItem> items;
  if (menuState.selectedCategoryId != null) {
    final cat = kMenuCategories.firstWhere(
      (c) => c.id == menuState.selectedCategoryId,
      orElse: () => kMenuCategories.first,
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
  return getPopularItems();
});

/// Chef specials for home page
final specialsProvider = Provider<List<MenuItem>>((ref) {
  return getSpecials();
});
