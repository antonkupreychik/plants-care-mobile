import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/garden_location.dart';
import '../../../home/presentation/home_providers.dart';
import '../../domain/new_plant_draft.dart';
import 'wizard_chrome.dart';

/// Шаг 2 мастера: имя растения + выбор комнаты.
///
/// Имя — единственное обязательное поле; валидность берётся из
/// [NewPlantDraft.isNameValid] (UI логику не дублирует). Комната опциональна
/// («Без комнаты»). Список комнат из [homeLocationsProvider]; loading/error
/// деградируют мягко — выбор комнаты не обязателен.
class StepNameRoom extends ConsumerStatefulWidget {
  const StepNameRoom({
    super.key,
    required this.initialName,
    required this.selectedLocationId,
    required this.isNameValid,
    required this.onNameChanged,
    required this.onLocationChanged,
  });

  final String initialName;
  final int? selectedLocationId;
  final bool isNameValid;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<int?> onLocationChanged;

  @override
  ConsumerState<StepNameRoom> createState() => _StepNameRoomState();
}

class _StepNameRoomState extends ConsumerState<StepNameRoom> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.initialName);

  /// Показывать ошибку имени только после первого редактирования (не пугать
  /// пустым полем сразу при открытии шага без выбранного вида).
  bool _touched = false;

  @override
  void didUpdateWidget(StepNameRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Префилл из выбранного вида произошёл, пока поле не трогали — подтягиваем.
    if (!_touched && widget.initialName != _nameController.text) {
      _nameController.text = widget.initialName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locations = ref.watch(homeLocationsProvider);
    final showError = _touched && !widget.isNameValid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WizardStepTitle(
          overline: l10n.addPlantOverline,
          title: l10n.addPlantNameTitle,
          subtitle: l10n.addPlantNameSubtitle,
        ),
        const SizedBox(height: 20),
        _SectionLabel(text: l10n.addPlantNameLabel),
        const SizedBox(height: 8),
        _NameField(
          controller: _nameController,
          hasError: showError,
          onChanged: (value) {
            if (!_touched) setState(() => _touched = true);
            widget.onNameChanged(value);
          },
        ),
        if (showError) ...[
          const SizedBox(height: 6),
          _ErrorText(text: l10n.addPlantNameError(NewPlantDraft.nameMaxLength)),
        ],
        const SizedBox(height: 24),
        _SectionLabel(text: l10n.addPlantRoomLabel),
        const SizedBox(height: 10),
        locations.when(
          loading: () => const _RoomsSkeleton(),
          error: (_, _) => _RoomsUnavailable(message: l10n.addPlantRoomsEmpty),
          data: (locs) {
            if (locs.isEmpty) {
              return _RoomsUnavailable(message: l10n.addPlantRoomsEmpty);
            }
            return _RoomGrid(
              locations: locs,
              selectedId: widget.selectedLocationId,
              onSelected: widget.onLocationChanged,
            );
          },
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: c.inkSoft,
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final borderColor = hasError ? c.terracotta : c.line;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLength: NewPlantDraft.nameMaxLength,
      textInputAction: TextInputAction.next,
      style: AppTheme.serif(fontSize: 22, color: c.ink),
      decoration: InputDecoration(
        counterText: '',
        hintText: l10n.addPlantNameHint,
        hintStyle: AppTheme.serif(fontSize: 22, color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: hasError ? c.terracotta : c.primary),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: c.terracotta),
    );
  }
}

class _RoomGrid extends StatelessWidget {
  const _RoomGrid({
    required this.locations,
    required this.selectedId,
    required this.onSelected,
  });

  final List<GardenLocation> locations;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _RoomChip(
          label: l10n.addPlantRoomNone,
          emoji: null,
          selected: selectedId == null,
          onTap: () => onSelected(null),
        ),
        for (final loc in locations)
          _RoomChip(
            label: loc.name,
            emoji: loc.emoji,
            selected: selectedId == loc.id,
            onTap: () => onSelected(loc.id),
          ),
      ],
    );
  }
}

class _RoomChip extends StatelessWidget {
  const _RoomChip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? c.fab : c.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? c.fab : c.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (emoji != null && emoji!.isNotEmpty) ...[
                  Text(emoji!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? c.fabInk : c.ink,
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

class _RoomsUnavailable extends StatelessWidget {
  const _RoomsUnavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      message,
      style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.35),
    );
  }
}

class _RoomsSkeleton extends StatelessWidget {
  const _RoomsSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < 4; i++)
          Container(
            width: 96,
            height: 48,
            decoration: BoxDecoration(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
      ],
    );
  }
}
