import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import 'room_edit_sheet.dart';
import 'room_move_target_sheet.dart';
import 'rooms_controller.dart';
import 'widgets/room_list_tile.dart';

/// Экран управления комнатами (CRUD локаций, push `/profile/rooms`).
///
/// Состояния `roomsControllerProvider` (`AsyncValue<List<GardenLocation>>`):
/// loading → skeleton, error → [ErrorState] с retry (текст по типу `ApiError`),
/// empty → заглушка + кнопка добавить, data → ленивый список комнат.
///
/// Создание/изменение — через [showRoomEditSheet]. Удаление — с подтверждением,
/// затем delete без target; при `LocationNotEmptyError` — пикер переноса
/// растений и повтор delete с `targetLocationId` (delete-with-move flow).
class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  /// id комнат с активным флоу удаления — guard от повторного входа.
  /// Кнопка delete остаётся активной весь асинхронный флоу (диалог → delete →
  /// пикер → retry); без этого второй тап запускал бы параллельный флоу.
  final Set<int> _deleting = <int>{};

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(roomsControllerProvider);

    void openCreate() => showRoomEditSheet(context);
    void openEdit(GardenLocation room) => showRoomEditSheet(context, room: room);

    Future<void> deleteRoom(GardenLocation room) async {
      // Повторный тап во время активного удаления этой комнаты — игнор.
      if (_deleting.contains(room.id)) return;
      setState(() => _deleting.add(room.id));
      try {
        await _deleteWithMoveFlow(context, room);
      } finally {
        if (mounted) {
          setState(() => _deleting.remove(room.id));
        } else {
          _deleting.remove(room.id);
        }
      }
    }

    return Scaffold(
      backgroundColor: c.bg,
      floatingActionButton: async.hasValue
          ? _AddRoomFab(label: l10n.roomsAdd, onPressed: openCreate)
          : null,
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () => const _RoomsLoading(),
          error: (error, _) => _RoomsError(
            message: l10n.messageForError(error),
            onRetry: () => ref.invalidate(roomsControllerProvider),
          ),
          data: (rooms) => _RoomsContent(
            rooms: rooms,
            onAdd: openCreate,
            onEdit: openEdit,
            onDelete: deleteRoom,
          ),
        ),
      ),
    );
  }

  /// Удаление с подтверждением и (при непустой комнате) переносом растений.
  ///
  /// 1. Диалог подтверждения. 2. `delete(id)` без target. 3. `Success` →
  /// SnackBar. 4. `Failure(LocationNotEmptyError)` → пикер целевой комнаты
  /// (остальные комнаты) → повтор `delete(id, targetLocationId)`. 5. Прочие
  /// ошибки → SnackBar с текстом по типу `ApiError`.
  Future<void> _deleteWithMoveFlow(
    BuildContext context,
    GardenLocation room,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(roomsControllerProvider.notifier);

    final confirmed = await _confirmDelete(context, room);
    if (confirmed != true || !context.mounted) return;

    final first = await notifier.delete(id: room.id);
    if (!context.mounted) return;

    switch (first) {
      case Success():
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.roomDeleted)));
        return;
      case Failure(error: LocationNotEmptyError()):
        // Комната не пуста — нужен перенос растений в другую комнату.
        break;
      case Failure(:final error):
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.messageForError(error))));
        return;
    }

    // Целевые комнаты = все, кроме удаляемой (источник — текущее состояние).
    final targets = (ref.read(roomsControllerProvider).value ?? [])
        .where((r) => r.id != room.id)
        .toList(growable: false);
    if (targets.isEmpty || !context.mounted) return;

    final targetId = await showRoomMoveTargetSheet(
      context,
      deleting: room,
      targets: targets,
    );
    if (targetId == null || !context.mounted) return;

    final second =
        await notifier.delete(id: room.id, targetLocationId: targetId);
    if (!context.mounted) return;

    switch (second) {
      case Success():
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.roomDeleted)));
      case Failure(:final error):
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.messageForError(error))));
    }
  }

  Future<bool?> _confirmDelete(BuildContext context, GardenLocation room) {
    final l10n = AppLocalizations.of(context);
    final c = Theme.of(context).extension<PcColors>()!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text(l10n.roomDeleteConfirmTitle),
        content: Text(l10n.roomDeleteConfirmMessage(room.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.roomDeleteConfirmCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: c.terracotta),
            child: Text(l10n.roomDeleteConfirmDelete),
          ),
        ],
      ),
    );
  }
}

/// Шапка экрана: кнопка «назад», overline, серифный заголовок + счётчик комнат.
class _RoomsHeader extends StatelessWidget {
  const _RoomsHeader({this.count});

  /// null → счётчик скрыт (loading/error, число неизвестно).
  final int? count;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackButton(label: l10n.roomsBack),
        const SizedBox(height: 14),
        Text(
          l10n.roomsOverline.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 6),
        Text(l10n.roomsTitle, style: AppTheme.serif(fontSize: 40, color: c.ink)),
        if (count != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.roomsCount(count!),
            style: TextStyle(fontSize: 14, color: c.inkSoft),
          ),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          // Стек пуст (deep link) — уходим на /profile.
          onTap: () =>
              context.canPop() ? context.pop() : context.go('/profile'),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
          ),
        ),
      ),
    );
  }
}

/// Контент data-состояния: шапка + ленивый список комнат (или пустое состояние).
class _RoomsContent extends StatelessWidget {
  const _RoomsContent({
    required this.rooms,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<GardenLocation> rooms;
  final VoidCallback onAdd;
  final ValueChanged<GardenLocation> onEdit;
  final ValueChanged<GardenLocation> onDelete;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        children: [
          const _RoomsHeader(count: 0),
          const SizedBox(height: 24),
          _RoomsEmpty(onAdd: onAdd),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 120),
      itemCount: rooms.length + 1,
      separatorBuilder: (_, index) =>
          SizedBox(height: index == 0 ? 20 : 8),
      itemBuilder: (context, index) {
        if (index == 0) return _RoomsHeader(count: rooms.length);
        final room = rooms[index - 1];
        return RoomListTile(
          room: room,
          onEdit: () => onEdit(room),
          onDelete: () => onDelete(room),
        );
      },
    );
  }
}

/// Пустое состояние: у пользователя обычно есть дефолтная локация, но на случай
/// пустого списка — аккуратная заглушка с кнопкой добавить.
class _RoomsEmpty extends StatelessWidget {
  const _RoomsEmpty({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Icon(Icons.home_outlined, size: 36, color: c.leaf),
          const SizedBox(height: 14),
          Text(
            l10n.roomsEmptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.roomsEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
          const SizedBox(height: 18),
          _AddRoomButton(label: l10n.roomsAdd, onPressed: onAdd),
        ],
      ),
    );
  }
}

class _AddRoomButton extends StatelessWidget {
  const _AddRoomButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.fab,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 20, color: c.fabInk),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.fabInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddRoomFab extends StatelessWidget {
  const _AddRoomFab({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: c.fab,
      foregroundColor: c.fabInk,
      icon: const Icon(Icons.add_rounded),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Loading: шапка-заглушка + несколько skeleton-строк комнат.
class _RoomsLoading extends StatelessWidget {
  const _RoomsLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      children: [
        const _RoomsHeader(),
        const SizedBox(height: 24),
        for (var i = 0; i < 4; i++) ...[
          const _RoomTileSkeleton(),
          if (i < 3) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _RoomTileSkeleton extends StatelessWidget {
  const _RoomTileSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          const SkeletonBox(width: 44, height: 44, radius: 14),
          const SizedBox(width: 12),
          const Expanded(child: SkeletonBox(width: 120, height: 16)),
          const SizedBox(width: 12),
          SkeletonBox(width: 20, height: 20, radius: 10),
        ],
      ),
    );
  }
}

/// Error: кнопка «назад» + блок ошибки с retry (стек может быть пуст).
class _RoomsError extends StatelessWidget {
  const _RoomsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      children: [
        const _RoomsHeader(),
        const SizedBox(height: 24),
        ErrorState(
          message: message,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
      ],
    );
  }
}
