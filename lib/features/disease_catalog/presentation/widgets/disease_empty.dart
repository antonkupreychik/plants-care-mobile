import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';

/// Пустое состояние справочника болезней: иконка + текст (issue #68).
/// Текст передаёт вызывающий (пустой справочник / поиск без результатов).
class DiseaseEmpty extends StatelessWidget {
  const DiseaseEmpty({super.key, required this.title});

  final String title;

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
          Icon(Icons.search_off_rounded, size: 36, color: c.inkMute),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.serif(fontSize: 22, color: c.ink),
          ),
        ],
      ),
    );
  }
}
