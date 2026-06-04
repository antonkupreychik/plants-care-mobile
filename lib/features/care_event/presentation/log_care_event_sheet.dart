import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../plant_card/domain/care_event_kind.dart';
import '../../plant_card/presentation/care_event_kind_l10n.dart';
import 'care_event_form_state.dart';
import 'care_event_kind_action_l10n.dart';
import 'care_event_providers.dart';
import 'log_care_event_controller.dart';

/// Открывает sheet отметки ухода (экран 06) для [plantId].
///
/// Material 3 modal bottom sheet с drag handle. [presetType] передаётся, когда
/// sheet открыт из задачи `/today` (предвыбор типа). [plantName] — для подписи
/// в шапке (если известно вызывающему); не влияет на отправку.
///
/// Жизненный цикл состояния — у family-провайдера
/// `logCareEventControllerProvider(plantId, presetType: …)`. Sheet сам
/// закрывается на успешной отправке (через [Navigator.pop]); вызывающему ничего
/// делать не нужно (инвалидация чтений — внутри контроллера).
Future<void> showLogCareEventSheet(
  BuildContext context, {
  required int plantId,
  CareEventKind? presetType,
  String? plantName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _LogCareEventSheet(
      plantId: plantId,
      presetType: presetType,
      plantName: plantName,
    ),
  );
}

class _LogCareEventSheet extends ConsumerWidget {
  const _LogCareEventSheet({
    required this.plantId,
    required this.presetType,
    required this.plantName,
  });

  final int plantId;
  final CareEventKind? presetType;
  final String? plantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider =
        logCareEventControllerProvider(plantId, presetType: presetType);
    final form = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    // Закрытие sheet ровно один раз на переход в success (а не в build —
    // используем listen, чтобы не дёргать Navigator при ребилдах). Если это был
    // ПЕРВЫЙ уход растения — после закрытия sheet открываем экран 33 «Успех
    // первого ухода» (push поверх shell). Иначе — обычный снэкбар.
    ref.listen(provider.select((s) => s.status), (prev, next) {
      if (next case SubmitSuccess(:final wasFirstCare, :final kind, :final onTime)) {
        Navigator.of(context).pop();
        if (wasFirstCare) {
          if (!context.mounted) return;
          context.push(
            '/home/care-success/$plantId?kind=${kind.name}&onTime=$onTime',
          );
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.careSheetSubmitted)));
        }
      }
    });

    // Запас под клавиатуру: поднимаем содержимое над инсетом ввода.
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    final submitLabel = switch (form.type) {
      CareEventKind.water => l10n.careSheetWaterSubmit,
      CareEventKind.spray => l10n.careSheetSpraySubmit,
      CareEventKind.fertilize => l10n.careSheetFertilizeSubmit,
      _ => l10n.careSheetSubmit,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(plantName: plantName),
            const SizedBox(height: 20),

            _FieldLabel(text: l10n.careSheetTypeLabel),
            const SizedBox(height: 8),
            _TypeSelector(
              selected: form.type,
              onSelected: controller.setType,
              availableKinds: ref
                  .watch(enabledCareKindsProvider(plantId))
                  .value ??
                  const [
                    CareEventKind.water,
                    CareEventKind.spray,
                    CareEventKind.fertilize,
                  ],
            ),
            const SizedBox(height: 20),

            // Секция, специфичная для типа WATER: слайдер мл + quick-chips + тоггл.
            if (form.type == CareEventKind.water) ...[
              _FieldLabel(text: l10n.careSheetWaterAmountLabel),
              const SizedBox(height: 8),
              _WaterAmountSection(
                amountMl: form.amountMl,
                soilWasDry: form.soilWasDry,
                onAmountChanged: controller.setAmountMl,
                onSoilWasDryChanged: (v) => controller.setSoilWasDry(value: v),
              ),
              const SizedBox(height: 20),
            ],

            // Секция, специфичная для FERTILIZE: поле названия удобрения.
            if (form.type == CareEventKind.fertilize) ...[
              _FieldLabel(
                text: l10n.careSheetFertilizerNameLabel,
                trailing: l10n.careSheetNoteOptional,
              ),
              const SizedBox(height: 8),
              _FertilizerNameField(
                initial: form.fertilizerName,
                onChanged: controller.setFertilizerName,
              ),
              const SizedBox(height: 20),
            ],

            _FieldLabel(text: l10n.careSheetWhenLabel),
            const SizedBox(height: 8),
            _WhenRow(
              performedAtUtc: form.performedAtUtc,
              onPick: (local) => controller.setPerformedAt(local.toUtc()),
            ),
            const SizedBox(height: 20),

            _FieldLabel(
              text: l10n.careSheetNoteLabel,
              trailing: l10n.careSheetNoteOptional,
            ),
            const SizedBox(height: 8),
            _NoteField(
              initial: form.note,
              onChanged: controller.setNote,
            ),

            // Ошибка отправки — inline над кнопкой, кнопка остаётся активной.
            if (form.status case SubmitFailure(:final error)) ...[
              const SizedBox(height: 14),
              _SubmitError(message: l10n.messageForError(error)),
            ],

            const SizedBox(height: 20),
            _SubmitButton(
              enabled: form.canSubmit,
              submitting: form.status is Submitting,
              label: submitLabel,
              onPressed: controller.submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: overline + серифный заголовок (с именем растения, если известно).
class _Header extends StatelessWidget {
  const _Header({required this.plantName});

  final String? plantName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final name = plantName?.trim();
    final title = (name == null || name.isEmpty)
        ? l10n.careSheetTitle
        : l10n.careSheetTitleFor(name);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.careSheetOverline.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.serif(fontSize: 30, color: c.ink),
        ),
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
          Text(
            trailing!,
            style: TextStyle(fontSize: 11, color: c.inkMute),
          ),
      ],
    );
  }
}

/// Выбор типа ухода: сегменты-чипы по включённым расписаниям растения.
class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selected,
    required this.onSelected,
    required this.availableKinds,
  });

  final CareEventKind selected;
  final ValueChanged<CareEventKind> onSelected;
  final List<CareEventKind> availableKinds;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final kind in availableKinds) ...[
          Expanded(
            child: _TypeChip(
              kind: kind,
              active: kind == selected,
              onTap: () => onSelected(kind),
            ),
          ),
          if (kind != availableKinds.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.kind,
    required this.active,
    required this.onTap,
  });

  final CareEventKind kind;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final label = kind.actionLabel(l10n);

    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Material(
        color: active ? c.primary : c.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: active ? c.primary : c.line),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  kind.icon,
                  size: 22,
                  color: active ? c.surface : c.ink,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: active ? c.surface : c.ink,
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

/// Строка выбора момента выполнения. Тап → date picker → time picker; результат
/// (локальное время) отдаём наружу, конвертацию в UTC делает вызывающий.
class _WhenRow extends ConsumerWidget {
  const _WhenRow({required this.performedAtUtc, required this.onPick});

  final DateTime performedAtUtc;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final local = performedAtUtc.toLocal();
    final nowLocal = ref.read(clockProvider).nowUtc().toLocal();

    // «Сейчас», если выбранный момент в пределах минуты от текущего.
    final isNow = nowLocal.difference(local).abs() < const Duration(minutes: 1);
    final valueText = isNow
        ? l10n.careSheetWhenNow
        : l10n.careSheetWhenValue(
            DateFormat.MMMd(l10n.localeName).format(local),
            DateFormat.Hm(l10n.localeName).format(local),
          );

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _pick(context, nowLocal, local),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.line),
          ),
          child: Row(
            children: [
              Icon(Icons.schedule_rounded, size: 20, color: c.ink),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  valueText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
              ),
              Icon(Icons.expand_more_rounded, size: 20, color: c.inkSoft),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(
    BuildContext context,
    DateTime nowLocal,
    DateTime currentLocal,
  ) async {
    // Backdating разрешён: нижняя граница — год назад, верхняя — «сейчас».
    final date = await showDatePicker(
      context: context,
      initialDate: currentLocal.isAfter(nowLocal) ? nowLocal : currentLocal,
      firstDate: DateTime(nowLocal.year - 1),
      lastDate: nowLocal,
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentLocal),
    );
    if (!context.mounted) return;

    final t = time ?? TimeOfDay.fromDateTime(currentLocal);
    var picked = DateTime(date.year, date.month, date.day, t.hour, t.minute);
    // Не позволяем выбрать будущее (уход «сделан» — не позже сейчас).
    if (picked.isAfter(nowLocal)) picked = nowLocal;
    onPick(picked);
  }
}

/// Секция WATER: слайдер объёма (0–1000 мл, шаг 50) + quick-chips +
/// тоггл «грунт был сухой». Разделена на виджеты по ~80 строк.
class _WaterAmountSection extends StatelessWidget {
  const _WaterAmountSection({
    required this.amountMl,
    required this.soilWasDry,
    required this.onAmountChanged,
    required this.onSoilWasDryChanged,
  });

  final int? amountMl;
  final bool soilWasDry;
  final ValueChanged<int?> onAmountChanged;
  final ValueChanged<bool> onSoilWasDryChanged;

  static const _quickChips = [100, 200, 300, 500];

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final currentMl = amountMl ?? 0;
    final valueText = currentMl == 0
        ? l10n.careSheetWaterAmountNotSet
        : l10n.careSheetWaterAmountValue(currentMl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Текущее значение
        Text(
          valueText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: currentMl == 0 ? c.inkMute : c.primary,
          ),
        ),
        // Слайдер
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: c.primary,
            inactiveTrackColor: c.primarySoft,
            thumbColor: c.primary,
            overlayColor: c.primary.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: currentMl.toDouble(),
            min: 0,
            max: 1000,
            divisions: 20, // шаг 50 → 1000/50 = 20 делений
            onChanged: (v) => onAmountChanged(v.round()),
          ),
        ),
        // Quick-chips
        _AmountChips(
          selectedMl: amountMl,
          chips: _quickChips,
          onSelected: onAmountChanged,
        ),
        const SizedBox(height: 12),
        // Тоггл «Грунт был сухой»
        _SoilDryToggle(
          value: soilWasDry,
          onChanged: onSoilWasDryChanged,
        ),
      ],
    );
  }
}

/// Быстрые чипы объёма воды: 100 / 200 / 300 / 500 мл.
class _AmountChips extends StatelessWidget {
  const _AmountChips({
    required this.selectedMl,
    required this.chips,
    required this.onSelected,
  });

  final int? selectedMl;
  final List<int> chips;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final ml in chips) ...[
            _AmountChip(
              label: '$ml мл',
              selected: selectedMl == ml,
              onTap: () => onSelected(selectedMl == ml ? null : ml),
              activeColor: c.primary,
              activeFgColor: c.fabInk,
              inactiveBg: c.chipBg,
              inactiveFg: c.ink,
            ),
            if (ml != chips.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.activeColor,
    required this.activeFgColor,
    required this.inactiveBg,
    required this.inactiveFg,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color activeFgColor;
  final Color inactiveBg;
  final Color inactiveFg;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? activeColor : inactiveBg,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? activeFgColor : inactiveFg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Тоггл «Грунт был сухой» для WATER.
class _SoilDryToggle extends StatelessWidget {
  const _SoilDryToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.line),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.careSheetSoilDryLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.ink,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: c.fabInk,
                activeTrackColor: c.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Поле ввода названия удобрения (FERTILIZE, экран 06b).
class _FertilizerNameField extends StatefulWidget {
  const _FertilizerNameField({required this.initial, required this.onChanged});

  final String? initial;
  final ValueChanged<String?> onChanged;

  @override
  State<_FertilizerNameField> createState() => _FertilizerNameFieldState();
}

class _FertilizerNameFieldState extends State<_FertilizerNameField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: 1,
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: 14, color: c.ink),
      decoration: InputDecoration(
        hintText: l10n.careSheetFertilizerNameHint,
        hintStyle: TextStyle(fontSize: 14, color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          borderSide: BorderSide(color: c.leafDark),
        ),
      ),
    );
  }
}

/// Необязательная заметка. Локальный контроллер текста (несинхронизируем посимвольно
/// в state на каждом кадре — пишем в state на onChanged, этого достаточно).
class _NoteField extends StatefulWidget {
  const _NoteField({required this.initial, required this.onChanged});

  final String? initial;
  final ValueChanged<String?> onChanged;

  @override
  State<_NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends State<_NoteField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: 3,
      minLines: 2,
      textInputAction: TextInputAction.newline,
      style: TextStyle(fontSize: 14, color: c.ink),
      decoration: InputDecoration(
        hintText: l10n.careSheetNoteHint,
        hintStyle: TextStyle(fontSize: 14, color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

/// Inline-ошибка отправки (текст уже локализован вызывающим по типу ApiError).
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

/// Кнопка подтверждения: dis при `canSubmit=false`, спиннер при отправке.
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
  final Future<bool> Function() onPressed;

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
          onTap: active ? () => onPressed() : null,
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
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 20, color: c.fabInk),
                        const SizedBox(width: 10),
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
      ),
    );
  }
}
