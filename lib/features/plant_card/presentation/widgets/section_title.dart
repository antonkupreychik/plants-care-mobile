import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';

/// Серифный заголовок секции на карточке растения (например «Дневник ухода»).
///
/// Опциональный [trailing] рисуется справа (например ссылка «Всё» → полная
/// история). Без него — поведение прежнее (просто текст).
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.trailing});

  final String title;

  /// Виджет в конце строки заголовка (action/ссылка). `null` — нет действия.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final text = Text(title, style: AppTheme.serif(fontSize: 22, color: c.ink));
    if (trailing == null) return text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: text),
        const SizedBox(width: 8),
        trailing!,
      ],
    );
  }
}
