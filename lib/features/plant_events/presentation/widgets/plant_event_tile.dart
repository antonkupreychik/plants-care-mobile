import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/plant_event.dart';
import '../plant_event_type_l10n.dart';

/// Строка журнала событий: иконка типа, локализованное название, дата
/// (+ комментарий, если есть).
///
/// Время [PlantEvent.eventDate] приходит в UTC — показываем в локальной TZ
/// (`.toLocal()`).
class PlantEventTile extends StatelessWidget {
  const PlantEventTile({super.key, required this.event, this.showDivider = false});

  final PlantEvent event;

  /// Рисовать разделитель сверху (для строк, кроме первой в группе).
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final local = event.eventDate.toLocal();
    final dateLabel = DateFormat.yMMMd(l10n.localeName).format(local);
    final comment = event.comment?.trim();

    return Column(
      children: [
        if (showDivider) Divider(height: 1, color: c.line),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(event.eventType.icon, size: 16, color: c.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.eventType.label(l10n),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
                    if (comment != null && comment.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        comment,
                        style: TextStyle(
                          fontSize: 12,
                          color: c.inkSoft,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
