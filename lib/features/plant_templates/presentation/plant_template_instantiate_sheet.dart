import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/error/result.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/plant_template.dart';
import 'plant_templates_controller.dart';

/// Максимальная длина имени нового растения.
const _kPlantNameMaxLength = 100;

/// Открывает sheet инстанцирования шаблона (создание нового растения).
///
/// При успехе закрывает sheet и возвращает результат через SnackBar на
/// вызывающем экране.
Future<void> showPlantTemplateInstantiateSheet(
  BuildContext context, {
  required PlantTemplate template,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _PlantTemplateInstantiateSheet(template: template),
  );
}

class _PlantTemplateInstantiateSheet extends ConsumerStatefulWidget {
  const _PlantTemplateInstantiateSheet({required this.template});

  final PlantTemplate template;

  @override
  ConsumerState<_PlantTemplateInstantiateSheet> createState() =>
      _PlantTemplateInstantiateSheetState();
}

class _PlantTemplateInstantiateSheetState
    extends ConsumerState<_PlantTemplateInstantiateSheet> {
  final TextEditingController _nameController = TextEditingController();
  bool _submitting = false;
  String? _submitError;

  String get _trimmedName => _nameController.text.trim();

  bool get _nameValid =>
      _trimmedName.isNotEmpty && _trimmedName.length <= _kPlantNameMaxLength;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_nameValid) return;
    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final result = await ref
        .read(plantTemplatesControllerProvider.notifier)
        .instantiate(
          templateId: widget.template.id,
          plantName: _trimmedName,
        );

    if (!mounted) return;

    switch (result) {
      case Success(:final value):
        final l10n = AppLocalizations.of(context);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content:
                  Text(l10n.plantTemplatesInstantiateSuccess(value.name)),
            ),
          );
      case Failure(:final error):
        setState(() {
          _submitting = false;
          _submitError = AppLocalizations.of(context).messageForError(error);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final insets = MediaQuery.viewInsetsOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, insets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.plantTemplatesInstantiateSheetTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.ink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.template.name,
            style: TextStyle(fontSize: 14, color: c.inkSoft),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            maxLength: _kPlantNameMaxLength,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.plantTemplatesInstantiateNameLabel,
              hintText: l10n.plantTemplatesInstantiateNameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onSubmitted: (_) => _submit(),
            onChanged: (_) => setState(() {}),
          ),
          if (_submitError != null) ...[
            const SizedBox(height: 8),
            Text(
              _submitError!,
              style: TextStyle(fontSize: 13, color: c.terracotta),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: (_nameValid && !_submitting) ? _submit : null,
            style: FilledButton.styleFrom(
              backgroundColor: c.fab,
              foregroundColor: c.fabInk,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _submitting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: c.fabInk,
                    ),
                  )
                : Text(
                    l10n.plantTemplatesInstantiateAction,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
