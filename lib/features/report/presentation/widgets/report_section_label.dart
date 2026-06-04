import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Надстрочная метка секции отчёта (uppercase, разрядка) — дизайн-язык v4
/// (`SectionLabel`). Цвет/размер из токенов, без хардкода.
class ReportSectionLabel extends StatelessWidget {
  const ReportSectionLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: c.inkSoft,
      ),
    );
  }
}
