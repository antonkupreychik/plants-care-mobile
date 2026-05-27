import 'package:flutter/material.dart';

/// Дизайн-токены PlantCate — перенос 1:1 из `PC_THEMES`
/// (`design_handoff_plantcate/design/screens.jsx`, строки 7–48).
///
/// Источник правды по цветам. Доступ из виджетов:
/// `Theme.of(context).extension<PcColors>()!`.
@immutable
class PcColors extends ThemeExtension<PcColors> {
  const PcColors({
    required this.bg,
    required this.surface,
    required this.surfaceWarm,
    required this.ink,
    required this.inkSoft,
    required this.inkMute,
    required this.line,
    required this.primary,
    required this.primarySoft,
    required this.leaf,
    required this.leafDark,
    required this.leafLight,
    required this.terracotta,
    required this.pot,
    required this.potShadow,
    required this.chipBg,
    required this.fab,
    required this.fabInk,
  });

  final Color bg;
  final Color surface;
  final Color surfaceWarm;
  final Color ink;
  final Color inkSoft;
  final Color inkMute;
  final Color line;
  final Color primary;
  final Color primarySoft;
  final Color leaf;
  final Color leafDark;
  final Color leafLight;
  final Color terracotta;
  final Color pot;
  final Color potShadow;
  final Color chipBg;
  final Color fab;
  final Color fabInk;

  static const light = PcColors(
    bg: Color(0xFFF1ECE0),
    surface: Color(0xFFFBF7EC),
    surfaceWarm: Color(0xFFEDE5D2),
    ink: Color(0xFF1F2A1E),
    inkSoft: Color(0xFF5C6650),
    inkMute: Color(0xFF8C9180),
    line: Color(0x1A1F2A1E), // rgba(31,42,30,0.10)
    primary: Color(0xFF3F6B3A),
    primarySoft: Color(0xFFDCE7C9),
    leaf: Color(0xFF6F8A4F),
    leafDark: Color(0xFF3F5A2E),
    leafLight: Color(0xFFA8C081),
    terracotta: Color(0xFFC77B5C),
    pot: Color(0xFFB9876B),
    potShadow: Color(0xFF8A5E48),
    chipBg: Color(0xFFE7E0CE),
    fab: Color(0xFF1F2A1E),
    fabInk: Color(0xFFFBF7EC),
  );

  static const dark = PcColors(
    bg: Color(0xFF141A14),
    surface: Color(0xFF1E251D),
    surfaceWarm: Color(0xFF252D24),
    ink: Color(0xFFEFE7D4),
    inkSoft: Color(0xFFA8AE96),
    inkMute: Color(0xFF6E7466),
    line: Color(0x1AEFE7D4), // rgba(239,231,212,0.10)
    primary: Color(0xFFB7D08C),
    primarySoft: Color(0xFF2C3826),
    leaf: Color(0xFF8FAE65),
    leafDark: Color(0xFF5E7A3F),
    leafLight: Color(0xFFC2D89A),
    terracotta: Color(0xFFD89172),
    pot: Color(0xFF8A5E48),
    potShadow: Color(0xFF5F3F30),
    chipBg: Color(0xFF2A3128),
    fab: Color(0xFFEFE7D4),
    fabInk: Color(0xFF141A14),
  );

  @override
  PcColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceWarm,
    Color? ink,
    Color? inkSoft,
    Color? inkMute,
    Color? line,
    Color? primary,
    Color? primarySoft,
    Color? leaf,
    Color? leafDark,
    Color? leafLight,
    Color? terracotta,
    Color? pot,
    Color? potShadow,
    Color? chipBg,
    Color? fab,
    Color? fabInk,
  }) {
    return PcColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceWarm: surfaceWarm ?? this.surfaceWarm,
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      inkMute: inkMute ?? this.inkMute,
      line: line ?? this.line,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      leaf: leaf ?? this.leaf,
      leafDark: leafDark ?? this.leafDark,
      leafLight: leafLight ?? this.leafLight,
      terracotta: terracotta ?? this.terracotta,
      pot: pot ?? this.pot,
      potShadow: potShadow ?? this.potShadow,
      chipBg: chipBg ?? this.chipBg,
      fab: fab ?? this.fab,
      fabInk: fabInk ?? this.fabInk,
    );
  }

  @override
  PcColors lerp(ThemeExtension<PcColors>? other, double t) {
    if (other is! PcColors) return this;
    return PcColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceWarm: Color.lerp(surfaceWarm, other.surfaceWarm, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t)!,
      inkMute: Color.lerp(inkMute, other.inkMute, t)!,
      line: Color.lerp(line, other.line, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      leaf: Color.lerp(leaf, other.leaf, t)!,
      leafDark: Color.lerp(leafDark, other.leafDark, t)!,
      leafLight: Color.lerp(leafLight, other.leafLight, t)!,
      terracotta: Color.lerp(terracotta, other.terracotta, t)!,
      pot: Color.lerp(pot, other.pot, t)!,
      potShadow: Color.lerp(potShadow, other.potShadow, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      fab: Color.lerp(fab, other.fab, t)!,
      fabInk: Color.lerp(fabInk, other.fabInk, t)!,
    );
  }
}
