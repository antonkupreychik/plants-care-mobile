import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/locations/garden_location.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/home_providers.dart';
import 'edit_plant_controller.dart';
import 'edit_plant_state.dart';

/// Экран «Редактировать растение» (из issue #79).
///
/// Вход: кнопка «⋯» в шапке [PlantCardScreen] → `context.pushNamed('editPlant',
/// pathParameters: {'id': '$plantId'})`.
///
/// Роут: `/home/plants/:id/edit` (на `_rootNavigatorKey`, без таб-бара).
///
/// Форма:
/// - НАЗВАНИЕ — обязательное текстовое поле.
/// - ЗАМЕТКИ — необязательное текстовое поле.
/// - КОМНАТА — пикер из [GardenLocation] (загружается через [homeLocationsProvider]).
/// - ВИД — задизейблено до plants-care#228.
///
/// «Сохранить» активно только при `isDirty && isNameValid`. После успеха —
/// pop + инвалидация деталей и домашнего списка (делает контроллер).
class EditPlantScreen extends ConsumerStatefulWidget {
  const EditPlantScreen({super.key, required this.plantId});

  final int plantId;

  @override
  ConsumerState<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends ConsumerState<EditPlantScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _notesCtrl;
  bool _initialized = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  /// Инициализируем поля один раз, когда данные впервые загрузились.
  void _initFields(EditPlantState state) {
    if (_initialized) return;
    _initialized = true;
    _nameCtrl = TextEditingController(text: state.draft.name);
    _notesCtrl = TextEditingController(text: state.draft.notes ?? '');
    // Слушаем изменения контроллеров и пробрасываем в Riverpod-контроллер.
    _nameCtrl.addListener(() {
      ref
          .read(editPlantControllerProvider(widget.plantId).notifier)
          .setName(_nameCtrl.text);
    });
    _notesCtrl.addListener(() {
      ref
          .read(editPlantControllerProvider(widget.plantId).notifier)
          .setNotes(_notesCtrl.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = Theme.of(context).extension<PcColors>()!;

    final asyncState = ref.watch(editPlantControllerProvider(widget.plantId));

    // Слушаем submitStatus для pop / snackbar.
    ref.listen(editPlantControllerProvider(widget.plantId), (prev, next) {
      final s = next.value;
      if (s == null) return;
      if (s.submitStatus == SubmitStatus.success) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.editPlantSuccessSnackbar)));
        if (context.canPop()) context.pop();
      } else if (s.submitStatus == SubmitStatus.failure &&
          s.submitError != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.messageForError(s.submitError))),
          );
      }
    });

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: asyncState.when(
          loading: () => _buildLoading(context, l10n, c),
          error: (error, _) => _buildError(context, l10n, error),
          data: (state) {
            _initFields(state);
            return _buildForm(context, l10n, c, state);
          },
        ),
      ),
    );
  }

  Widget _buildLoading(
    BuildContext context,
    AppLocalizations l10n,
    PcColors c,
  ) {
    return Column(
      children: [
        _AppBar(
          l10n: l10n,
          c: c,
          canSave: false,
          isSubmitting: false,
          onSave: null,
        ),
        const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }

  Widget _buildError(
    BuildContext context,
    AppLocalizations l10n,
    Object error,
  ) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: ErrorState(
        message: l10n.messageForError(error),
        retryLabel: l10n.retry,
        onRetry: () =>
            ref.invalidate(editPlantControllerProvider(widget.plantId)),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    AppLocalizations l10n,
    PcColors c,
    EditPlantState state,
  ) {
    return Column(
      children: [
        _AppBar(
          l10n: l10n,
          c: c,
          canSave: state.canSave,
          isSubmitting: state.isSubmitting,
          onSave: state.canSave && !state.isSubmitting
              ? () => ref
                  .read(editPlantControllerProvider(widget.plantId).notifier)
                  .submit()
              : null,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // НАЗВАНИЕ
                _SectionLabel(label: l10n.editPlantNameLabel, c: c),
                const SizedBox(height: 8),
                _PlantTextField(
                  controller: _nameCtrl,
                  hintText: l10n.editPlantNameLabel,
                  maxLines: 1,
                ),
                const SizedBox(height: 20),

                // ЗАМЕТКИ
                _SectionLabel(
                  label: l10n.editPlantNotesLabel,
                  optional: true,
                  c: c,
                ),
                const SizedBox(height: 8),
                _PlantTextField(
                  controller: _notesCtrl,
                  hintText: l10n.editPlantNotesLabel,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                // КОМНАТА
                _SectionLabel(label: l10n.editPlantLocationLabel, c: c),
                const SizedBox(height: 8),
                _LocationPicker(
                  plantId: widget.plantId,
                  selectedId: state.draft.locationId,
                  onSelect: (id) => ref
                      .read(
                          editPlantControllerProvider(widget.plantId).notifier)
                      .setLocation(id),
                ),
                const SizedBox(height: 20),

                // ВИД (задизейблено до plants-care#228)
                _SectionLabel(label: l10n.editPlantSpeciesLabel, c: c),
                const SizedBox(height: 8),
                Tooltip(
                  message: l10n.comingSoon,
                  child: _SpeciesPickerDisabled(
                    label: l10n.editPlantSpeciesNone,
                    c: c,
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Шапка экрана: «← Редактировать» слева, «Сохранить» справа.
class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.l10n,
    required this.c,
    required this.canSave,
    required this.isSubmitting,
    required this.onSave,
  });

  final AppLocalizations l10n;
  final PcColors c;
  final bool canSave;
  final bool isSubmitting;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: c.ink),
            tooltip: l10n.editPlantTitle,
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
          Expanded(
            child: Text(
              l10n.editPlantTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
          if (isSubmitting)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: onSave,
              child: Text(
                l10n.editPlantSave,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: canSave ? null : Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Заголовок секции формы.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.c,
    this.optional = false,
  });

  final String label;
  final PcColors c;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: c.inkSoft,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 6),
          Text(
            '(необязательно)',
            style: TextStyle(fontSize: 11, color: c.inkMute),
          ),
        ],
      ],
    );
  }
}

/// Текстовое поле формы.
class _PlantTextField extends StatelessWidget {
  const _PlantTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 15, color: c.ink),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

/// Пикер комнаты — выпадающее меню из [GardenLocation].
class _LocationPicker extends ConsumerWidget {
  const _LocationPicker({
    required this.plantId,
    required this.selectedId,
    required this.onSelect,
  });

  final int plantId;
  final int? selectedId;
  final void Function(int?) onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = Theme.of(context).extension<PcColors>()!;
    final asyncLocs = ref.watch(homeLocationsProvider);

    return asyncLocs.when(
      loading: () => _shell(
        c: c,
        child: Text(
          '…',
          style: TextStyle(fontSize: 15, color: c.inkMute),
        ),
      ),
      error: (_, stack) => _shell(
        c: c,
        child: Text(
          l10n.editPlantLocationLabel,
          style: TextStyle(fontSize: 15, color: c.inkMute),
        ),
      ),
      data: (locations) {
        return _shell(
          c: c,
          child: DropdownButton<int?>(
            value: selectedId,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: Icon(Icons.expand_more_rounded, color: c.inkSoft),
            dropdownColor: c.surface,
            style: TextStyle(fontSize: 15, color: c.ink),
            hint: Text(
              l10n.addPlantRoomNone,
              style: TextStyle(fontSize: 15, color: c.inkMute),
            ),
            onChanged: onSelect,
            items: [
              DropdownMenuItem<int?>(
                value: null,
                child: Text(
                  l10n.addPlantRoomNone,
                  style: TextStyle(color: c.inkSoft),
                ),
              ),
              for (final loc in locations)
                DropdownMenuItem<int?>(
                  value: loc.id,
                  child: Text(loc.name),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _shell({required PcColors c, required Widget child}) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line),
      ),
      child: child,
    );
  }
}

/// Задизейбленное поле «Вид» — до plants-care#228.
class _SpeciesPickerDisabled extends StatelessWidget {
  const _SpeciesPickerDisabled({required this.label, required this.c});

  final String label;
  final PcColors c;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: c.inkMute),
            ),
          ),
          Icon(Icons.expand_more_rounded, color: c.inkMute),
        ],
      ),
    );
  }
}
