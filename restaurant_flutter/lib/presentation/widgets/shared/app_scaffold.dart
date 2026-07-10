import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../presentation/providers/cart_provider.dart';

/// Bottom navigation shell — Home | Menu | Cart | Profile
class AppScaffold extends ConsumerWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  static const _tabs = [
    _NavTab(
        path: '/',
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home),
    _NavTab(
        path: '/menu',
        label: 'Menu',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view),
    _NavTab(
        path: '/cart',
        label: 'Cart',
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag),
    _NavTab(
        path: '/profile',
        label: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location.startsWith('/menu')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider.select((s) => s.totalItems));
    final cartTotal = ref.watch(cartProvider.select((s) => s.grandTotal));
    final current = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: current,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: [
          // Home
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // Menu
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Menu',
          ),
          // Cart — with badge
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(
                '$cartCount',
                style: const TextStyle(fontSize: 10, color: AppColors.white),
              ),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text(
                '$cartCount',
                style: const TextStyle(fontSize: 10, color: AppColors.white),
              ),
              backgroundColor: AppColors.accent,
              child: const Icon(Icons.shopping_bag),
            ),
            label: cartCount > 0 ? '₹$cartTotal' : 'Cart',
          ),
          // Profile
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _NavTab {
  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _NavTab(
      {required this.path,
      required this.label,
      required this.icon,
      required this.activeIcon});
}
