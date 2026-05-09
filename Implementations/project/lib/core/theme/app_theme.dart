import 'package:flutter/material.dart';

// Typography
const String kFontFamily = 'Inter';

const dataDisplay = TextStyle(fontSize: 32, height: 1.25, fontWeight: FontWeight.w700);
const titleStyle  = TextStyle(fontSize: 20, height: 1.4,  fontWeight: FontWeight.w600, letterSpacing: -0.2);
const bodyStyle   = TextStyle(fontSize: 16, height: 1.5,  fontWeight: FontWeight.w400);
const captionStyle= TextStyle(fontSize: 13, height: 1.38, fontWeight: FontWeight.w500, letterSpacing: 0.26);
const labelCaps   = TextStyle(fontSize: 11, height: 1.27, fontWeight: FontWeight.w700, letterSpacing: 0.55);

// Spacing Tokens
const spaceXs = 4.0;
const spaceSm = 8.0;
const spaceMd = 16.0;   // card_padding
const spaceLg = 24.0;
const spaceXl = 32.0;

// Border Radius (Doctor / Admin)
const radiusDefault = Radius.circular(2);   // 0.125rem
const radiusLg      = Radius.circular(4);   // 0.25rem
const radiusXl      = Radius.circular(8);   // 0.5rem
const radiusFull    = Radius.circular(12);  // 0.75rem — chips, badges

// TextTheme
final appTextTheme = const TextTheme(
  displayMedium: dataDisplay,
  titleLarge: titleStyle,
  bodyLarge: bodyStyle,
  bodyMedium: captionStyle,
  labelSmall: labelCaps,
).apply(fontFamily: kFontFamily);
