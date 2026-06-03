import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/api_error_l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../shopping_providers.dart';

/// Ограничение длины названия позиции (страховка от слишком длинного запроса).
const _kTitleMaxLength = 60;

/// Открывает шит добавления новой позиции в список покупок (экран 19).
///
/// Material 3 modal bottom sheet с drag handle (как `showRoomEditSheet`,
/// MADR-005 — ввод через sheet, не роут). На успех сам закрывается; ошибку
/// мутации (`addItem` бросает [ApiError]) показывает inline над кнопкой.
Future<void> showShoppingAddSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => const _ShoppingAddSheet(),
  );
}

class _ShoppingAddSheet extends ConsumerStatefulWidget {
  const _ShoppingAddSheet();

  @override
  ConsumerState<_ShoppingAddSheet> createState() => _ShoppingAddSheetState();
}

class _ShoppingAddSheetState extends ConsumerState<_ShoppingAddSheet> {
  final _title = TextEditingController();

  bool _submitting = false;
  String? _submitError;

  String get _trimmed => _title.text.trim();
  bool get _valid => _trimmed.isNotEmpty && _trimmed.length <= _kTitleMaxLength;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_valid || _submitting) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(shoppingControllerProvider.notifier).addItem(_trimmed);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
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

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              overline: l10n.shoppingAddSheetOverline,
              title: l10n.shoppingAddSheetTitle,
            ),
            const SizedBox(height: 20),
            _FieldLabel(text: l10n.shoppingAddSheetLabel),
            const SizedBox(height: 8),
            _TitleField(
              controller: _title,
              hint: l10n.shoppingAddSheetHint,
              onChanged: (_) {
                setState(() {
                  if (_submitError != null) _submitError = null;
                });
              },
              onSubmitted: (_) => _submit(),
            ),
            if (_submitError != null) ...[
              const SizedBox(height: 14),
              _SubmitError(message: _submitError!),
            ],
            const SizedBox(height: 20),
            _SubmitButton(
              enabled: _valid,
              submitting: _submitting,
              label: l10n.shoppingAddSheetSubmit,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.overline, required this.title});

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
  const _FieldLabel({required this.text});

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

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: true,
      maxLength: _kTitleMaxLength,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(fontSize: 15, color: c.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15, color: c.inkMute),
        counterText: '',
        filled: true,
        fillColor: c.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
