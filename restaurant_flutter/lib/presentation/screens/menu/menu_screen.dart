import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/menu_item_card.dart';
import 'widgets/menu_item_detail_sheet.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../data/static/menu_data.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: kMenuCategories.length + 1, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    final i = _tabController.index;
    if (i == 0) {
      ref.read(menuNotifierProvider.notifier).setCategory(null);
    } else {
      ref.read(menuNotifierProvider.notifier).setCategory(kMenuCategories[i - 1].id);
    }
  }

  void _onSearch(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(menuNotifierProvider.notifier).setSearch(q);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final items = ref.watch(filteredItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search menu...',
                      border: InputBorder.none,
                      filled: false,
                    ),
                    onChanged: _onSearch,
                  )
                : const Text('Menu'),
            actions: [
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search_outlined),
                onPressed: () {
                  setState(() => _isSearching = !_isSearching);
                  if (!_isSearching) {
                    _searchController.clear();
                    ref.read(menuNotifierProvider.notifier).setSearch('');
                  }
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: [
                const Tab(text: '🍽️ All'),
                ...kMenuCategories.map((c) => Tab(text: '${c.icon} ${c.name}')),
              ],
            ),
          ),
        ],
        body: items.isEmpty
            ? _EmptyState(onClear: () {
                _searchController.clear();
                ref.read(menuNotifierProvider.notifier).clear();
                setState(() => _isSearching = false);
                _tabController.animateTo(0);
              })
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s4, AppSpacing.s4, AppSpacing.s4, 120),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: AppSpacing.s3,
                  mainAxisSpacing: AppSpacing.s3,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => MenuItemCard(
                  item: items[i],
                  onTap: () => _showDetail(items[i]),
                ),
              ),
      ),
      // Floating cart bar — shows when cart has items
      floatingActionButton: cartState.totalItems > 0
          ? _FloatingCartBar(cartState: cartState)
          : FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xFF25D366),
              onPressed: () async {
                final uri = Uri.parse(AppStrings.whatsappUrl);
                if (await canLaunchUrl(uri)) {
                  launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Icon(Icons.chat, color: AppColors.white),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showDetail(MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MenuItemDetailSheet(item: item),
    );
  }
}

class _FloatingCartBar extends StatelessWidget {
  final CartState cartState;
  const _FloatingCartBar({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/cart'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${cartState.totalItems}',
                style: const TextStyle(
                    color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Text('View Cart',
                style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            const SizedBox(width: AppSpacing.s3),
            Text('₹${cartState.grandTotal}',
                style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClear;
  const _EmptyState({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.border),
          const SizedBox(height: AppSpacing.s4),
          Text('No items found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                  )),
          const SizedBox(height: AppSpacing.s3),
          TextButton(onPressed: onClear, child: const Text('Clear search')),
        ],
      ),
    );
  }
}
