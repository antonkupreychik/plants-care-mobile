import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

/// Сборка [ThemeData] light/dark из дизайн-токенов (MADR-001, Material 3).
///
/// Типографика: Plus Jakarta Sans — UI-текст; Instrument Serif —
/// заголовки-акценты (применяется точечно в виджетах через
/// [AppTheme.serif]).
class AppTheme {
  const AppTheme._();

  static ThemeData light() => _build(PcColors.light, Brightness.light);
  static ThemeData dark() => _build(PcColors.dark, Brightness.dark);

  /// Серифный стиль-акцент (Instrument Serif) для hero-заголовков и voice line.
  static TextStyle serif({
    double fontSize = 38,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    Color? color,
  }) {
    return GoogleFonts.instrumentSerif(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      height: 1.05,
    );
  }

  static ThemeData _build(PcColors c, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(seedColor: c.primary, brightness: brightness)
            .copyWith(
      primary: c.primary,
      surface: c.surface,
      onSurface: c.ink,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bg,
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: c.ink, displayColor: c.ink);

    return base.copyWith(
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[c],
    );
  }
}
