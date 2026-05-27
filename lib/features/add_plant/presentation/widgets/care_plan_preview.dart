import 'package:flutter/material.dart';

import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/care_plan_item.dart';

/// Read-only превью «плана ухода» по виду: карточки типов ухода с интервалом
/// «каждые N дней». Интервалы рекомендованные (backend не сохраняет), поэтому
/// список не редактируется (см. BACKEND-GAPS). Иконки/подписи — из care_task_l10n.
class CarePlanPreview extends StatelessWidget {
  const CarePlanPreview({super.key, required this.items});

  final List<CarePlanItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _CarePlanCard(item: items[i]),
          if (i != items.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _CarePlanCard extends StatelessWidget {
  const _CarePlanCard({required this.item});

  final CarePlanItem item;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.type.icon, size: 20, color: c.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.type.label(l10n),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.addPlantCarePlanEvery(item.everyDays),
                  style: TextStyle(fontSize: 12, color: c.inkSoft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Нейтральная подсказка-плейсхолдер на месте плана ухода (вид не выбран или у
/// вида нет интервалов).
class CarePlanHint extends StatelessWidget {
  const CarePlanHint({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Icon(Icons.spa_outlined, size: 22, color: c.inkMute),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
