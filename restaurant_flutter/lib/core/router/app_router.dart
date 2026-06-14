import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/menu/menu_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/track/track_order_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/offers/offers_screen.dart';
import '../../presentation/screens/admin/admin_dashboard_screen.dart';
import '../../presentation/screens/receipt/receipt_screen.dart';
import '../../presentation/screens/contact/contact_screen.dart';
import '../../presentation/screens/privacy/privacy_policy_screen.dart';
import '../../presentation/widgets/shared/app_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    // Shell route for screens with bottom navigation
    ShellRoute(
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/menu',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MenuScreen(),
          ),
        ),
        GoRoute(
          path: '/track',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TrackOrderScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    // Full-screen routes (no bottom nav)
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/offers',
      builder: (context, state) => const OffersScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/receipt/:orderId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'] ?? '';
        return ReceiptScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
