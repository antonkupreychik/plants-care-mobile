import 'package:flutter/material.dart';

import '../../../core/locations/garden_location.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Открывает пикер «Куда перенести растения?» при удалении непустой комнаты
/// ([deleting]). Список [targets] — ОСТАЛЬНЫЕ комнаты (вызывающий уже исключил
/// удаляемую). Возвращает id выбранной комнаты или null (отмена/закрытие).
Future<int?> showRoomMoveTargetSheet(
  BuildContext context, {
  required GardenLocation deleting,
  required List<GardenLocation> targets,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _RoomMoveTargetSheet(deleting: deleting, targets: targets),
  );
}

class _RoomMoveTargetSheet extends StatelessWidget {
  const _RoomMoveTargetSheet({required this.deleting, required this.targets});

  final GardenLocation deleting;
  final List<GardenLocation> targets;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    // Высота ограничена ~70% экрана; длинный список скроллится лениво.
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.roomMoveOverline.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.roomMoveTitle,
                  style: AppTheme.serif(fontSize: 28, color: c.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.roomMoveSubtitle(deleting.name),
                  style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              itemCount: targets.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final room = targets[i];
                return _TargetTile(
                  room: room,
                  onTap: () => Navigator.of(context).pop(room.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetTile extends StatelessWidget {
  const _TargetTile({required this.room, required this.onTap});

  final GardenLocation room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final emoji = room.emoji?.trim();
    final hasEmoji = emoji != null && emoji.isNotEmpty;

    return Semantics(
      button: true,
      label: room.name,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.surfaceWarm,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: hasEmoji
                      ? Text(emoji, style: const TextStyle(fontSize: 20))
                      : Icon(Icons.home_outlined, size: 20, color: c.inkSoft),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        room.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                        ),
                      ),
                      if (room.isDefault) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.roomsDefaultBadge,
                          style: TextStyle(fontSize: 11, color: c.inkSoft),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 20, color: c.inkMute),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
