import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class RitaFoodlandApp extends ConsumerWidget {
  const RitaFoodlandApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router so it rebuilds when auth state changes
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Rita Foodland',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
