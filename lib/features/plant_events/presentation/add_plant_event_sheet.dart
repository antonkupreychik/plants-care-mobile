import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/plant_event_type.dart';
import 'plant_event_type_l10n.dart';
import 'plant_events_providers.dart';

/// Открывает sheet добавления события (журнал событий) для [plantId].
///
/// Material 3 modal bottom sheet с drag handle: 4 кнопки-типа с иконками. Тап по
/// типу → `POST` через `PlantEventsController.addEvent`, оптимистичное
/// добавление в список (внутри контроллера) и закрытие sheet. Дедуп (409) →
/// тост «Событие уже записано». Sheet сам закрывается; вызывающему ничего
/// делать не нужно.
Future<void> showAddPlantEventSheet(
  BuildContext context, {
  required int plantId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _AddPlantEventSheet(plantId: plantId),
  );
}

class _AddPlantEventSheet extends ConsumerStatefulWidget {
  const _AddPlantEventSheet({required this.plantId});

  final int plantId;

  @override
  ConsumerState<_AddPlantEventSheet> createState() =>
      _AddPlantEventSheetState();
}

class _AddPlantEventSheetState extends ConsumerState<_AddPlantEventSheet> {
  /// Тип, по которому идёт отправка (для спиннера/блокировки). `null` — простой.
  PlantEventType? _submitting;

  Future<void> _onTap(PlantEventType type) async {
    if (_submitting != null) return; // защита от двойного тапа
    setState(() => _submitting = type);

    final error = await ref
        .read(plantEventsControllerProvider(widget.plantId).notifier)
        .addEvent(type);

    if (!mounted) return;

    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (error == null) {
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.plantEventAddedSnackbar)));
      return;
    }

    // Ошибка: дедуп (409) — отдельный понятный тост, sheet закрываем (событие
    // уже записано на бэке). Прочие ошибки — оставляем sheet открытым, тост.
    setState(() => _submitting = null);
    final isDuplicate = error is ConflictError;
    if (isDuplicate) navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isDuplicate
                ? l10n.plantEventDuplicateSnackbar
                : l10n.messageForError(error),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.addPlantEventSheetOverline.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: c.inkSoft,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.addPlantEventSheetTitle,
            style: AppTheme.serif(fontSize: 30, color: c.ink),
          ),
          const SizedBox(height: 20),
          // 2×2 сетка кнопок-типов.
          for (var i = 0; i < PlantEventType.values.length; i += 2) ...[
            Row(
              children: [
                Expanded(
                  child: _EventTypeButton(
                    type: PlantEventType.values[i],
                    submitting: _submitting == PlantEventType.values[i],
                    disabled: _submitting != null &&
                        _submitting != PlantEventType.values[i],
                    onTap: () => _onTap(PlantEventType.values[i]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _EventTypeButton(
                    type: PlantEventType.values[i + 1],
                    submitting: _submitting == PlantEventType.values[i + 1],
                    disabled: _submitting != null &&
                        _submitting != PlantEventType.values[i + 1],
                    onTap: () => _onTap(PlantEventType.values[i + 1]),
                  ),
                ),
              ],
            ),
            if (i + 2 < PlantEventType.values.length)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

/// Кнопка-тип события: иконка + локализованное название; спиннер при отправке.
class _EventTypeButton extends StatelessWidget {
  const _EventTypeButton({
    required this.type,
    required this.submitting,
    required this.disabled,
    required this.onTap,
  });

  final PlantEventType type;
  final bool submitting;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final label = type.label(l10n);

    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Material(
          color: c.surface,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: disabled ? null : onTap,
            child: Container(
              constraints: const BoxConstraints(minHeight: 96),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: c.line),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (submitting)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(c.primary),
                      ),
                    )
                  else
                    Icon(type.icon, size: 26, color: c.primary),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
