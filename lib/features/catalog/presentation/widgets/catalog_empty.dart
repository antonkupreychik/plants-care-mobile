import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';

/// Пустое состояние списка каталога: иконка + заголовок + подсказка.
///
/// Используется для двух кейсов (заголовок/подсказку даёт вызывающий):
/// пустой каталог без запроса и поиск без результатов.
class CatalogEmpty extends StatelessWidget {
  const CatalogEmpty({super.key, required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco_outlined, size: 36, color: c.inkMute),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 22, color: c.ink),
          ),
          const SizedBox(height: 6),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
          ),
        ],
      ),
    );
  }
}
