import 'package:flutter/material.dart';
import 'app_theme.dart';

// Border Radius (Nurse — Clinical Precision System)
const nurseRadiusSm      = Radius.circular(4);
const nurseRadiusDefault = Radius.circular(8);
const nurseRadiusMd      = Radius.circular(12);
const nurseRadiusLg      = Radius.circular(16);
const nurseRadiusXl      = Radius.circular(24);
const nurseRadiusFull    = Radius.circular(9999);

const nurseColorScheme = ColorScheme.light(
  primary:            Color(0xFF005EA4),
  onPrimary:          Color(0xFFFFFFFF),
  primaryContainer:   Color(0xFF0077CE),
  onPrimaryContainer: Color(0xFFFDFCFF),
  secondary:          Color(0xFF5E5E5E),
  onSecondary:        Color(0xFFFFFFFF),
  surface:            Color(0xFFF8F9FF),
  onSurface:          Color(0xFF181C22),
  surfaceContainer:   Color(0xFFEBEEF6),
  surfaceContainerHighest: Color(0xFFE0E2EA),
  onSurfaceVariant:   Color(0xFF404752),
  outline:            Color(0xFF707783),
  outlineVariant:     Color(0xFFC0C7D4),
  error:              Color(0xFFBA1A1A),
  onError:            Color(0xFFFFFFFF),
  errorContainer:     Color(0xFFFFDAD6),
  onErrorContainer:   Color(0xFF93000A),
);

class NurseColors extends ThemeExtension<NurseColors> {
  final Color emergencyRed;
  final Color stopGrey;
  final Color successGreen;
  final Color pauseAmber;
  final Color severityCritical;
  final Color severityWarning;
  final Color severityInfo;

  const NurseColors({
    this.emergencyRed = const Color(0xFFE53935),
    this.stopGrey = const Color(0xFF757575),
    this.successGreen = const Color(0xFF43A047),
    this.pauseAmber = const Color(0xFFFFA000),
    this.severityCritical = const Color(0xFFBA1A1A),
    this.severityWarning = const Color(0xFFFFA000),
    this.severityInfo = const Color(0xFF005EA4),
  });

  @override
  ThemeExtension<NurseColors> copyWith({
    Color? emergencyRed,
    Color? stopGrey,
    Color? successGreen,
    Color? pauseAmber,
    Color? severityCritical,
    Color? severityWarning,
    Color? severityInfo,
  }) {
    return NurseColors(
      emergencyRed: emergencyRed ?? this.emergencyRed,
      stopGrey: stopGrey ?? this.stopGrey,
      successGreen: successGreen ?? this.successGreen,
      pauseAmber: pauseAmber ?? this.pauseAmber,
      severityCritical: severityCritical ?? this.severityCritical,
      severityWarning: severityWarning ?? this.severityWarning,
      severityInfo: severityInfo ?? this.severityInfo,
    );
  }

  @override
  ThemeExtension<NurseColors> lerp(ThemeExtension<NurseColors>? other, double t) {
    if (other is! NurseColors) {
      return this;
    }
    return NurseColors(
      emergencyRed: Color.lerp(emergencyRed, other.emergencyRed, t)!,
      stopGrey: Color.lerp(stopGrey, other.stopGrey, t)!,
      successGreen: Color.lerp(successGreen, other.successGreen, t)!,
      pauseAmber: Color.lerp(pauseAmber, other.pauseAmber, t)!,
      severityCritical: Color.lerp(severityCritical, other.severityCritical, t)!,
      severityWarning: Color.lerp(severityWarning, other.severityWarning, t)!,
      severityInfo: Color.lerp(severityInfo, other.severityInfo, t)!,
    );
  }
}

final nurseTheme = ThemeData(
  colorScheme: nurseColorScheme,
  textTheme: appTextTheme,
  scaffoldBackgroundColor: nurseColorScheme.surface,
  extensions: const [NurseColors()],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: nurseColorScheme.onSurface,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: appTextTheme.titleLarge?.copyWith(
      color: const Color(0xFF2563EB), // blue-600 from HTML
      fontWeight: FontWeight.w900,
      letterSpacing: -0.5,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(nurseRadiusMd),
      side: BorderSide(color: nurseColorScheme.outlineVariant.withValues(alpha: 0.3)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: nurseColorScheme.primary,
      foregroundColor: nurseColorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(nurseRadiusDefault),
      ),
      padding: const EdgeInsets.symmetric(horizontal: spaceLg, vertical: spaceMd),
      textStyle: appTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
  ),
);
