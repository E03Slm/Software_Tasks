import 'package:flutter/material.dart';

// Typography
const String kFontFamily = 'Inter';

const h1Style = TextStyle(fontSize: 28, height: 1.2, fontWeight: FontWeight.bold, letterSpacing: -0.5);
const dataDisplay = TextStyle(fontSize: 32, height: 1.25, fontWeight: FontWeight.bold);
const titleStyle = TextStyle(fontSize: 20, height: 1.4, fontWeight: FontWeight.w600, letterSpacing: -0.2);
const bodyStyle = TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w400);
const captionStyle = TextStyle(fontSize: 13, height: 1.38, fontWeight: FontWeight.w500, letterSpacing: 0.26);
const labelCaps = TextStyle(fontSize: 11, height: 1.27, fontWeight: FontWeight.bold, letterSpacing: 0.55);

// Spacing
const spaceXs = 4.0;
const spaceSm = 8.0;
const spaceMd = 16.0;
const spaceLg = 24.0;
const spaceXl = 32.0;

// Doctor Theme
const doctorColorScheme = ColorScheme.light(
  primary: Color(0xFF00685D),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF41655F),
  surface: Color(0xFFF6FAF8),
  onSurface: Color(0xFF171D1B),
  error: Color(0xFFBA1A1A),
);

// Nurse Theme
const nurseColorScheme = ColorScheme.light(
  primary: Color(0xFF005EA4),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF4A6080),
  surface: Color(0xFFF8F9FF),
  onSurface: Color(0xFF191C21),
  error: Color(0xFFBA1A1A),
);

// Admin Theme
const adminColorScheme = ColorScheme.light(
  primary: Color(0xFF6200EA),
  onPrimary: Color(0xFFFFFFFF),
  surface: Color(0xFFF5F5F5),
  onSurface: Color(0xFF1C1B1F),
  error: Color(0xFFBA1A1A),
);

// Theme Factory
ThemeData getThemeForRole(ColorScheme scheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: kFontFamily,
    textTheme: const TextTheme(
      displayLarge: dataDisplay,
      titleLarge: titleStyle,
      bodyMedium: bodyStyle,
      labelSmall: labelCaps,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      titleTextStyle: titleStyle.copyWith(color: scheme.onSurface),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return captionStyle.copyWith(color: scheme.primary, fontWeight: FontWeight.bold);
        }
        return captionStyle;
      }),
    ),
  );
}
