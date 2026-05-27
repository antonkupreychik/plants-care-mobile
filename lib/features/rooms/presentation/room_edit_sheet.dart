import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/error/result.dart';
import '../../../core/locations/garden_location.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'rooms_controller.dart';

/// Ограничения полей (зеркалят `LocationCreateRequest` API).
const _kNameMaxLength = 30;
const _kEmojiMaxLength = 16;

/// Открывает sheet создания (если [room] == null) или редактирования комнаты.
///
/// Material 3 modal bottom sheet с drag handle (как care-event sheet, MADR-005 —
/// CRUD через sheet, не роут). На успех сам закрывается; SnackBar показывает
/// вызывающий через результат — здесь же, чтобы не плодить состояние снаружи.
Future<void> showRoomEditSheet(
  BuildContext context, {
  GardenLocation? room,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _RoomEditSheet(room: room),
  );
}

class _RoomEditSheet extends ConsumerStatefulWidget {
  const _RoomEditSheet({required this.room});

  final GardenLocation? room;

  @override
  ConsumerState<_RoomEditSheet> createState() => _RoomEditSheetState();
}

class _RoomEditSheetState extends ConsumerState<_RoomEditSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.room?.name ?? '');
  late final TextEditingController _emoji =
      TextEditingController(text: widget.room?.emoji ?? '');

  bool _submitting = false;
  bool _nameTouched = false;

  /// Локализованная ошибка последней неудачной отправки (inline над кнопкой).
  String? _submitError;

  bool get _isEdit => widget.room != null;

  String get _trimmedName => _name.text.trim();

  bool get _nameValid =>
      _trimmedName.isNotEmpty && _trimmedName.length <= _kNameMaxLength;

  @override
  void dispose() {
    _name.dispose();
    _emoji.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _nameTouched = true);
    if (!_nameValid || _submitting) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final notifier = ref.read(roomsControllerProvider.notifier);
    final emoji = _emoji.text.trim();
    final emojiArg = emoji.isEmpty ? null : emoji;

    final result = _isEdit
        ? await notifier.rename(
            id: widget.room!.id,
            name: _trimmedName,
            emoji: emojiArg,
          )
        : await notifier.create(name: _trimmedName, emoji: emojiArg);

    if (!mounted) return;

    final l10n = AppLocalizations.of(context);
    switch (result) {
      case Success():
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(_isEdit ? l10n.roomUpdated : l10n.roomCreated)),
          );
      case Failure(:final error):
        setState(() {
          _submitting = false;
          _submitError = l10n.messageForError(error);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final showNameError = _nameTouched && !_nameValid;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetHeader(
              overline:
                  _isEdit ? l10n.roomSheetEditOverline : l10n.roomSheetCreateOverline,
              title: _isEdit ? l10n.roomSheetEditTitle : l10n.roomSheetCreateTitle,
            ),
            const SizedBox(height: 20),

            _FieldLabel(text: l10n.roomSheetNameLabel),
            const SizedBox(height: 8),
            _NameField(
              controller: _name,
              hasError: showNameError,
              // Безусловный setState: пересчитывает `_nameValid` на каждый ввод,
              // чтобы submit-кнопка загоралась по мере набора (в т.ч. на первом
              // открытии create-sheet, когда `_nameTouched` ещё false). Inline-
              // ошибку прошлой неудачной отправки сбрасываем при правке.
              onChanged: (_) {
                setState(() {
                  if (_submitError != null) _submitError = null;
                });
              },
              onSubmitted: (_) => _submit(),
            ),
            if (showNameError) ...[
              const SizedBox(height: 6),
              _InlineFieldError(text: l10n.roomSheetNameError(_kNameMaxLength)),
            ],
            const SizedBox(height: 20),

            _FieldLabel(
              text: l10n.roomSheetEmojiLabel,
              trailing: l10n.roomSheetEmojiOptional,
            ),
            const SizedBox(height: 8),
            _EmojiField(controller: _emoji),

            if (_submitError != null) ...[
              const SizedBox(height: 14),
              _SubmitError(message: _submitError!),
            ],

            const SizedBox(height: 20),
            _SubmitButton(
              enabled: _nameValid,
              submitting: _submitting,
              label: _isEdit ? l10n.roomSheetEditSubmit : l10n.roomSheetCreateSubmit,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.overline, required this.title});

  final String overline;
  final String title;

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
        Text(title, style: AppTheme.serif(fontSize: 30, color: c.ink)),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: c.inkSoft,
          ),
        ),
        if (trailing != null)
          Text(trailing!, style: TextStyle(fontSize: 11, color: c.inkMute)),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.hasError,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: true,
      maxLength: _kNameMaxLength,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(fontSize: 15, color: c.ink),
      decoration: InputDecoration(
        hintText: l10n.roomSheetNameHint,
        hintStyle: TextStyle(fontSize: 15, color: c.inkMute),
        counterText: '',
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: _border(c.line),
        enabledBorder: _border(hasError ? c.terracotta : c.line),
        focusedBorder: _border(hasError ? c.terracotta : c.primary),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color),
      );
}

class _EmojiField extends StatelessWidget {
  const _EmojiField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      maxLength: _kEmojiMaxLength,
      inputFormatters: [LengthLimitingTextInputFormatter(_kEmojiMaxLength)],
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        hintText: l10n.roomSheetEmojiHint,
        hintStyle: const TextStyle(fontSize: 20),
        counterText: '',
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: _border(c.line),
        enabledBorder: _border(c.line),
        focusedBorder: _border(c.primary),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color),
      );
}

class _InlineFieldError extends StatelessWidget {
  const _InlineFieldError({required this.text});

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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.submitting,
    required this.label,
    required this.onPressed,
  });

  final bool enabled;
  final bool submitting;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final active = enabled && !submitting;

    return Semantics(
      button: true,
      enabled: active,
      label: label,
      child: Material(
        color: active ? c.fab : c.inkMute,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: active ? onPressed : null,
          child: SizedBox(
            height: 56,
            child: Center(
              child: submitting
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(c.fabInk),
                      ),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: c.fabInk,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
