import 'package:flutter/material.dart';
import 'app_theme.dart';

class DoctorColors extends ThemeExtension<DoctorColors> {
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color error;
  final Color background;
  final Color border;

  const DoctorColors({
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.error,
    required this.background,
    required this.border,
  });

  @override
  ThemeExtension<DoctorColors> copyWith({
    Color? primary,
    Color? secondary,
    Color? surface,
    Color? error,
    Color? background,
    Color? border,
  }) {
    return DoctorColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      background: background ?? this.background,
      border: border ?? this.border,
    );
  }

  @override
  ThemeExtension<DoctorColors> lerp(ThemeExtension<DoctorColors>? other, double t) {
    if (other is! DoctorColors) return this;
    return DoctorColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

// Doctor Theme Data
final doctorTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF319795), // Teal
    primary: const Color(0xFF319795),
    secondary: const Color(0xFF2D3748),
  ),
  textTheme: appTextTheme,
  scaffoldBackgroundColor: const Color(0xFFF7FAFC),
  cardTheme: const CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(radiusLg),
      side: BorderSide(color: Color(0xFFE2E8F0)),
    ),
    color: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(spaceXs),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(spaceXs),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(spaceXs),
      borderSide: const BorderSide(color: Color(0xFF319795), width: 2),
    ),
  ),
  extensions: [
    const DoctorColors(
      primary: Color(0xFF319795),
      secondary: Color(0xFF2D3748),
      surface: Colors.white,
      error: Color(0xFFE53E3E),
      background: Color(0xFFF7FAFC),
      border: Color(0xFFE2E8F0),
    ),
  ],
);
