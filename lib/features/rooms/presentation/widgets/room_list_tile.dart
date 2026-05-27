import 'package:flutter/material.dart';

import '../../../../core/locations/garden_location.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Строка комнаты в списке: эмодзи (или дефолтная иконка) + имя, у дефолтной —
/// пометка «По умолчанию». Действия справа: изменить (всегда) и удалить (скрыто
/// для дефолтной — её нельзя удалить).
class RoomListTile extends StatelessWidget {
  const RoomListTile({
    super.key,
    required this.room,
    required this.onEdit,
    required this.onDelete,
  });

  final GardenLocation room;
  final VoidCallback onEdit;

  /// Удаление. Не вызывается для дефолтной комнаты (кнопка скрыта).
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final emoji = room.emoji?.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          _Leading(emoji: emoji),
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
          _IconAction(
            icon: Icons.edit_outlined,
            label: l10n.roomsEditAction,
            onTap: onEdit,
          ),
          // Дефолтную комнату удалить нельзя — действие скрыто.
          if (!room.isDefault)
            _IconAction(
              icon: Icons.delete_outline_rounded,
              label: l10n.roomsDeleteAction,
              onTap: onDelete,
              danger: true,
            ),
        ],
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({required this.emoji});

  final String? emoji;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final hasEmoji = emoji != null && emoji!.isNotEmpty;
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(14),
      ),
      child: hasEmoji
          ? Text(emoji!, style: const TextStyle(fontSize: 22))
          : Icon(Icons.home_outlined, size: 22, color: c.inkSoft),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, size: 20, color: danger ? c.terracotta : c.ink),
          ),
        ),
      ),
    );
  }
}
