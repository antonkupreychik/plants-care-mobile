import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../plant_card/domain/care_event_kind.dart';
import '../../../plant_card/domain/care_history_entry.dart';
import '../../../plant_card/presentation/care_event_kind_l10n.dart';

/// Группа таймлайна за один месяц: заголовок-месяц + вертикальная линия +
/// карточки записей. [entries] уже отфильтрованы и относятся к одному месяцу
/// (группировку по локальному месяцу делает экран).
class CareHistoryMonthGroup extends StatelessWidget {
  const CareHistoryMonthGroup({
    super.key,
    required this.monthLabel,
    required this.entries,
  });

  final String monthLabel;
  final List<CareHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 6),
          child: Text(
            monthLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: c.inkSoft,
            ),
          ),
        ),
        // Вертикальная линия проходит через центр иконок-нод (left = 19).
        Stack(
          children: [
            Positioned(
              left: 19,
              top: 14,
              bottom: 14,
              child: Container(width: 2, color: c.line),
            ),
            Column(
              children: [
                for (final e in entries) CareHistoryTimelineRow(entry: e),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Строка таймлайна: иконка-нода типа + карточка с подписью, датой, заметкой и
/// меткой «вовремя / с опозданием».
class CareHistoryTimelineRow extends StatelessWidget {
  const CareHistoryTimelineRow({super.key, required this.entry});

  final CareHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final local = entry.performedAt.toLocal();
    final dateLabel = l10n.careHistoryEntryDate(
      DateFormat.E(l10n.localeName).format(local),
      DateFormat.d(l10n.localeName).format(local),
      DateFormat.Hm(l10n.localeName).format(local),
    );
    final tint = _tintFor(entry.kind, c);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Node(icon: entry.kind.icon, tint: tint),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: c.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          entry.kind.doneLabel(l10n),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: c.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateLabel,
                        style: TextStyle(fontSize: 11, color: c.inkSoft),
                      ),
                    ],
                  ),
                  if (entry.note != null && entry.note!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      entry.note!.trim(),
                      style: TextStyle(
                        fontSize: 12,
                        color: c.inkSoft,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _StatusLabel(onTime: entry.onTime),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Цветовой акцент ноды по типу ухода (из токенов, без хардкода).
  static Color _tintFor(CareEventKind kind, PcColors c) => switch (kind) {
        CareEventKind.water => c.primary,
        CareEventKind.spray => c.terracotta,
        CareEventKind.fertilize => c.leafDark,
        CareEventKind.unknown => c.inkMute,
      };
}

class _Node extends StatelessWidget {
  const _Node({required this.icon, required this.tint});

  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: c.surface,
        shape: BoxShape.circle,
        border: Border.all(color: tint, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: tint),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.onTime});

  final bool onTime;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final color = onTime ? c.primary : c.terracotta;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          onTime ? l10n.careHistoryOnTime : l10n.careHistoryLate,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Маркер «появления растения» в конце таймлайна (из `Plant.createdAt`).
class CareHistoryPlantCreatedMarker extends StatelessWidget {
  const CareHistoryPlantCreatedMarker({
    super.key,
    required this.plantName,
    required this.createdAtLocal,
  });

  final String plantName;
  final DateTime createdAtLocal;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final dateText = DateFormat.yMMMMd(l10n.localeName).format(createdAtLocal);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.careHistoryPlantCreated(plantName, dateText),
              style: AppTheme.serif(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: c.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
