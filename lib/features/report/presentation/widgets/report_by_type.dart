import 'package:flutter/material.dart';

import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/care/care_task_type.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'report_section_label.dart';

/// Разбивка выполненного по типам ухода (дизайн v4): чипы тип → счётчик с
/// иконкой/подписью. Переиспользует общий маппинг типов
/// [CareTaskTypeL10n] (иконка + локализованная подпись).
///
/// Показываются только типы с count > 0, в стабильном порядке enum-а. Если
/// все нули — секция не рисуется (родитель показывает её только при наличии
/// данных; здесь подстраховка пустым `SizedBox`).
class ReportByType extends StatelessWidget {
  const ReportByType({super.key, required this.byType});

  final Map<CareTaskType, int> byType;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Стабильный порядок по enum-у, только ненулевые.
    final entries = CareTaskType.values
        .where((t) => (byType[t] ?? 0) > 0)
        .toList(growable: false);

    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportSectionLabel(text: l10n.reportByTypeLabel),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final type in entries)
              _TypeChip(type: type, count: byType[type]!),
          ],
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type, required this.count});

  final CareTaskType type;
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type.icon, size: 18, color: c.leaf),
          const SizedBox(width: 8),
          Text(
            type.label(l10n),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: c.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
