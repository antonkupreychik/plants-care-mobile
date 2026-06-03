import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/new_plant_draft.dart';
import '../../domain/window_side.dart';
import '../window_side_l10n.dart';

/// Шаг 04c мастера: фото (плейсхолдер) + сторона окна + необязательная заметка.
///
/// Фото и сторона окна — UI-only (backend полей нет: `POST /plants` принимает
/// только `{name, locationId, speciesId, notes}`). Кнопки загрузки фото —
/// заглушки (бэклог `photoFileId`), показывают снэкбар «скоро». Сторона окна
/// хранится в черновике для будущего использования. Кнопка «Добавить в сад» и
/// состояние submitting живут в панели действий экрана-мастера.
class StepPhotoWindow extends StatefulWidget {
  const StepPhotoWindow({
    super.key,
    required this.draft,
    required this.errorMessage,
    required this.onWindowSideChanged,
    required this.onNoteChanged,
    required this.onPhotoUnavailable,
  });

  final NewPlantDraft draft;

  /// Локализованный текст ошибки последнего сабмита (null → ошибки нет).
  final String? errorMessage;

  final ValueChanged<WindowSide?> onWindowSideChanged;
  final ValueChanged<String?> onNoteChanged;

  /// Тап по заглушке загрузки фото (камера / галерея) — экран показывает
  /// снэкбар «скоро» (реальный upload — бэклог).
  final VoidCallback onPhotoUnavailable;

  @override
  State<StepPhotoWindow> createState() => _StepPhotoWindowState();
}

class _StepPhotoWindowState extends State<StepPhotoWindow> {
  late final TextEditingController _noteController =
      TextEditingController(text: widget.draft.notes ?? '');

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(
          overline: l10n.addPlantPhotoOverline,
          title: l10n.addPlantPhotoTitle,
          subtitle: l10n.addPlantPhotoSubtitle,
        ),
        const SizedBox(height: 18),
        _PhotoPlaceholder(
          name: widget.draft.trimmedName,
          onTap: widget.onPhotoUnavailable,
        ),
        const SizedBox(height: 24),
        _SectionLabel(
          label: l10n.addPlantWindowLabel,
          trailing: l10n.addPlantWindowOptional,
        ),
        const SizedBox(height: 10),
        _WindowGrid(
          selected: widget.draft.windowSide,
          onSelected: widget.onWindowSideChanged,
        ),
        const SizedBox(height: 24),
        _SectionLabel(
          label: l10n.addPlantNoteLabel,
          trailing: l10n.addPlantNoteOptional,
        ),
        const SizedBox(height: 8),
        _NoteField(controller: _noteController, onChanged: widget.onNoteChanged),
        if (widget.errorMessage != null) ...[
          const SizedBox(height: 16),
          _SubmitError(message: widget.errorMessage!),
        ],
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.overline,
    required this.title,
    required this.subtitle,
  });

  final String overline;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overline.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: AppTheme.serif(fontSize: 32, color: c.ink)),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

/// Карточка-плейсхолдер фото: иллюстрация-рамка + имя + две кнопки-заглушки.
class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 84,
            height: 104,
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.line, width: 1.5),
            ),
            child: Icon(Icons.local_florist_outlined, size: 40, color: c.leaf),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name.isNotEmpty)
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.serif(fontSize: 22, color: c.ink),
                  ),
                const SizedBox(height: 2),
                Text(
                  l10n.addPlantPhotoPlaceholder,
                  style: TextStyle(fontSize: 12, color: c.inkSoft, height: 1.3),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PhotoButton(
                      label: l10n.addPlantPhotoCamera,
                      icon: Icons.photo_camera_outlined,
                      filled: true,
                      onTap: onTap,
                    ),
                    _PhotoButton(
                      label: l10n.addPlantPhotoGallery,
                      icon: Icons.photo_library_outlined,
                      filled: false,
                      onTap: onTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoButton extends StatelessWidget {
  const _PhotoButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = filled ? c.fabInk : c.ink;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: filled ? c.fab : c.surface,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: filled ? null : Border.all(color: c.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 15, color: fg),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: fg,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.trailing});

  final String label;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: c.inkSoft,
          ),
        ),
        Text(trailing, style: TextStyle(fontSize: 11, color: c.inkMute)),
      ],
    );
  }
}

/// Сетка 2×2 сторон окна. Порядок как в дизайне: Север/Восток/Юг/Запад.
class _WindowGrid extends StatelessWidget {
  const _WindowGrid({required this.selected, required this.onSelected});

  final WindowSide? selected;
  final ValueChanged<WindowSide?> onSelected;

  static const _order = [
    WindowSide.north,
    WindowSide.east,
    WindowSide.south,
    WindowSide.west,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final tileWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final side in _order)
              SizedBox(
                width: tileWidth,
                child: _WindowTile(
                  side: side,
                  selected: selected == side,
                  onTap: () => onSelected(side),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _WindowTile extends StatelessWidget {
  const _WindowTile({
    required this.side,
    required this.selected,
    required this.onTap,
  });

  final WindowSide side;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: side.label(l10n),
      child: Material(
        color: selected ? c.fab : c.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? c.fab : c.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? c.fabInk.withValues(alpha: 0.12)
                        : c.surfaceWarm,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    side.letter(l10n),
                    style: AppTheme.serif(
                      fontSize: 17,
                      color: selected ? c.fabInk : c.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        side.label(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: selected ? c.fabInk : c.ink,
                        ),
                      ),
                      Text(
                        side.hint(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: selected
                              ? c.fabInk.withValues(alpha: 0.8)
                              : c.inkSoft,
                        ),
                      ),
                    ],
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

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller, required this.onChanged});

  // Ограничение backend `PlantCreateRequest.notes`.
  static const int _maxLength = 2000;

  final TextEditingController controller;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 4,
      minLines: 3,
      maxLength: _maxLength,
      textInputAction: TextInputAction.newline,
      style: TextStyle(fontSize: 14, color: c.ink),
      decoration: InputDecoration(
        counterText: '',
        hintText: l10n.addPlantNoteHint,
        hintStyle: TextStyle(fontSize: 14, color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: c.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: c.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: c.primary),
        ),
      ),
    );
  }
}

class _SubmitError extends StatelessWidget {
  const _SubmitError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: c.terracotta),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: c.ink, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
