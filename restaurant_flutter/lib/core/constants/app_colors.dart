import 'package:flutter/material.dart';

/// Rita Foodland Design System — Color Tokens
/// Exact match to CSS custom properties in index.css
class AppColors {
  AppColors._();

  // Brand background (warm parchment)
  static const Color background = Color(0xFFEFE5D5);
  static const Color backgroundSecondary = Color(0xFFE6D7C2);
  static const Color backgroundTertiary = Color(0xFFDBC7AD);

  // Primary (green)
  static const Color primary = Color(0xFF15803D);
  static const Color primaryDark = Color(0xFF166534);
  static const Color primaryLight = Color(0xFFDCFCE7);

  // Accent (orange)
  static const Color accent = Color(0xFFF97316);
  static const Color accentHover = Color(0xFFEA580C);
  static const Color accentLight = Color(0xFFFFEDD5);

  // Danger (red)
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEE2E2);

  // Border
  static const Color border = Color(0xFFD4B895);
  static const Color borderLight = Color(0xFFE6D5BE);

  // Text
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Veg / Non-Veg
  static const Color veg = Color(0xFF22C55E);
  static const Color nonVeg = Color(0xFFDC2626);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // Green scale
  static const Color green50 = Color(0xFFF0FDF4);
  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green600 = Color(0xFF16A34A);
  static const Color green700 = Color(0xFF15803D);
  static const Color green800 = Color(0xFF166534);
  static const Color green900 = Color(0xFF14532D);

  // Orange scale
  static const Color orange50 = Color(0xFFFFF7ED);
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);

  // Status colors for admin
  static const Color statusDelivered = Color(0xFF15803D);
  static const Color statusPreparing = Color(0xFFF97316);
  static const Color statusPending = Color(0xFF6366F1);
  static const Color statusCancelled = Color(0xFFEF4444);
  static const Color statusOutForDelivery = Color(0xFF0EA5E9);
}
