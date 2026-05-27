import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/new_plant_draft.dart';

/// Шаг 4 мастера: саммари черновика + необязательная заметка + inline-ошибка
/// отправки. Кнопка «Добавить» и состояние submitting живут в панели действий
/// экрана-мастера (она же блокируется на время POST).
class StepConfirm extends StatefulWidget {
  const StepConfirm({
    super.key,
    required this.draft,
    required this.locationName,
    required this.errorMessage,
    required this.onNoteChanged,
  });

  final NewPlantDraft draft;

  /// Имя выбранной комнаты (null → «без комнаты»). Резолвится экраном из
  /// [homeLocationsProvider] по `draft.locationId`.
  final String? locationName;

  /// Локализованный текст ошибки последнего сабмита (null → ошибки нет).
  final String? errorMessage;
  final ValueChanged<String?> onNoteChanged;

  @override
  State<StepConfirm> createState() => _StepConfirmState();
}

class _StepConfirmState extends State<StepConfirm> {
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
    final draft = widget.draft;
    final planCount = draft.species?.carePlan.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(
          overline: l10n.addPlantConfirmTitle,
          subtitle: l10n.addPlantConfirmSubtitle,
        ),
        const SizedBox(height: 20),
        _SummaryCard(
          rows: [
            _SummaryRow(
              label: l10n.addPlantSummaryName,
              value: draft.trimmedName,
            ),
            _SummaryRow(
              label: l10n.addPlantSummaryRoom,
              value: widget.locationName ?? l10n.addPlantRoomNone,
            ),
            if (draft.species != null)
              _SummaryRow(
                label: l10n.addPlantSummaryCarePlan,
                value: l10n.addPlantSummaryCarePlanCount(planCount),
              ),
          ],
        ),
        const SizedBox(height: 24),
        _NoteLabel(
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
  const _Title({required this.overline, required this.subtitle});

  final String overline;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(overline, style: AppTheme.serif(fontSize: 32, color: c.ink)),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

class _SummaryRow {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.rows});

  final List<_SummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _SummaryRowView(row: rows[i]),
            if (i != rows.length - 1)
              Divider(color: c.line, height: 24, thickness: 1),
          ],
        ],
      ),
    );
  }
}

class _SummaryRowView extends StatelessWidget {
  const _SummaryRowView({required this.row});

  final _SummaryRow row;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            row.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.inkSoft,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            row.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoteLabel extends StatelessWidget {
  const _NoteLabel({required this.label, required this.trailing});

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
