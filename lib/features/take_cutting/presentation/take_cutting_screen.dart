import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../plant_card/presentation/plant_card_providers.dart';
import '../domain/propagation_method.dart';
import 'take_cutting_controller.dart';
import 'take_cutting_state.dart';
import 'widgets/cutting_lineage_viz.dart';
import 'widgets/cutting_method_card.dart';
import 'widgets/cutting_name_suggestions.dart';

/// Экран 18 «Взять черенок» — мастер создания ростка-потомка.
///
/// Полноэкранно поверх shell (на root-навигаторе, без таб-бара), как карточка
/// растения. Вход: карточка растения 02 → меню «⋯» → «Взять черенок».
///
/// Имя родителя берём из переиспользуемого `plantDetailProvider(parentPlantId)`
/// (не дублируем `GET /plants/{id}`); пока деталь грузится — заголовок показывает
/// нейтральный фолбэк. Данные ростка (имя, способ, дата среза) держит
/// [TakeCuttingController]; на сервер из них уходит только имя + `parentPlantId`.
class TakeCuttingScreen extends ConsumerStatefulWidget {
  const TakeCuttingScreen({super.key, required this.parentPlantId});

  /// Растение-родитель, от которого берём черенок.
  final int parentPlantId;

  @override
  ConsumerState<TakeCuttingScreen> createState() => _TakeCuttingScreenState();
}

class _TakeCuttingScreenState extends ConsumerState<TakeCuttingScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final provider = takeCuttingControllerProvider(widget.parentPlantId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    final detail = ref.watch(plantDetailProvider(widget.parentPlantId));
    final parentName = detail.value?.name;
    final parentSpeciesName = detail.value?.speciesName;

    // Успех сабмита → снэкбар + переход на карточку нового ростка.
    ref.listen(provider, (prev, next) {
      final status = next.status;
      if (status is TakeCuttingSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.takeCuttingSuccessSnack)),
        );
        context.pushReplacementNamed(
          'plantCard',
          pathParameters: {'id': '${status.plantId}'},
        );
      } else if (status is TakeCuttingFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.messageForError(status.error)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final isSubmitting = state.status is TakeCuttingSubmitting;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(22, 6, 22, 130),
              children: [
                _Header(onBack: () => _onCancel(context)),
                const SizedBox(height: 12),
                CuttingLineageViz(
                  parentName: parentName,
                  parentSpeciesName: parentSpeciesName,
                  childName: state.trimmedName.isEmpty
                      ? null
                      : state.trimmedName,
                ),
                const SizedBox(height: 16),
                _Title(parentName: parentName),
                const SizedBox(height: 24),

                // Секция «Имя ростка».
                _SectionLabel(text: l10n.takeCuttingNameSectionLabel),
                const SizedBox(height: 10),
                _NameField(
                  controller: _nameController,
                  enabled: !isSubmitting,
                  onChanged: controller.setName,
                ),
                const SizedBox(height: 10),
                CuttingNameSuggestions(
                  parentName: parentName,
                  onSelected: (name) {
                    _nameController.text = name;
                    _nameController.selection = TextSelection.collapsed(
                      offset: name.length,
                    );
                    controller.setName(name);
                  },
                ),
                const SizedBox(height: 24),

                // Секция «Как размножается».
                _SectionLabel(text: l10n.takeCuttingMethodSectionLabel),
                const SizedBox(height: 10),
                _MethodRow(
                  selected: state.method,
                  onSelected: controller.selectMethod,
                ),
                const SizedBox(height: 24),

                // Секция «Когда срезал(а)».
                _SectionLabel(text: l10n.takeCuttingDateSectionLabel),
                const SizedBox(height: 10),
                _DatePickerRow(
                  date: state.cutAt,
                  onTap: () => _pickDate(context, controller, state.cutAt),
                ),
              ],
            ),

            // Sticky нижняя панель: «Отмена» + «🌱 Завести в семью».
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(
                canSubmit: state.canSubmit,
                isSubmitting: isSubmitting,
                onCancel: () => _onCancel(context),
                onSubmit: controller.submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCancel(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(
        'plantCard',
        pathParameters: {'id': '${widget.parentPlantId}'},
      );
    }
  }

  Future<void> _pickDate(
    BuildContext context,
    TakeCuttingController controller,
    DateTime? current,
  ) async {
    final today = ref.read(clockProvider).nowUtc().toLocal();
    final lastDate = DateTime(today.year, today.month, today.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? lastDate,
      firstDate: DateTime(2000),
      lastDate: lastDate,
    );
    if (picked != null) {
      controller.setCutAt(picked);
    }
  }
}

/// Шапка: кнопка «←» + overline «Новый росток» по центру.
class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Tooltip(
          message: l10n.takeCuttingBack,
          child: Material(
            color: c.surface,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onBack,
              child: SizedBox(
                width: 44,
                height: 44,
                child: Semantics(
                  button: true,
                  label: l10n.takeCuttingBack,
                  child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            l10n.takeCuttingOverline.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: c.inkSoft,
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}

/// Серифный заголовок «Черенок от {имя}» (имя primary italic) + подзаголовок.
class _Title extends StatelessWidget {
  const _Title({required this.parentName});

  final String? parentName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    // Имя в родительном падеже отдаёт backend (источник правды по контенту) —
    // здесь подставляем как пришло; пока деталь грузится — нейтральный фолбэк
    // (имя отдельным span не выделяем, чтобы не разрезать ICU-строку).
    final title = l10n.takeCuttingTitle(parentName ?? '…');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.serif(fontSize: 30, color: c.ink),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.takeCuttingSubtitle,
          style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

/// Капс-лейбл секции.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.7,
        color: c.inkSoft,
      ),
    );
  }
}

/// Серифное поле ввода имени ростка (border primary 2px).
class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.enabled,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.primary, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        maxLength: TakeCuttingState.nameMaxLength,
        style: AppTheme.serif(fontSize: 22, color: c.ink),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          hintText: l10n.takeCuttingNameHint,
          hintStyle: AppTheme.serif(fontSize: 22, color: c.inkSoft),
        ),
      ),
    );
  }
}

/// Ряд из трёх карточек-toggle способа размножения.
class _MethodRow extends StatelessWidget {
  const _MethodRow({required this.selected, required this.onSelected});

  final PropagationMethod selected;
  final ValueChanged<PropagationMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: CuttingMethodCard(
            emoji: '💧',
            label: l10n.takeCuttingMethodWater,
            sub: l10n.takeCuttingMethodWaterSub,
            active: selected == PropagationMethod.water,
            onTap: () => onSelected(PropagationMethod.water),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CuttingMethodCard(
            emoji: '🪴',
            label: l10n.takeCuttingMethodSoil,
            sub: l10n.takeCuttingMethodSoilSub,
            active: selected == PropagationMethod.soil,
            onTap: () => onSelected(PropagationMethod.soil),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CuttingMethodCard(
            emoji: '🌿',
            label: l10n.takeCuttingMethodMoss,
            sub: l10n.takeCuttingMethodMossSub,
            active: selected == PropagationMethod.moss,
            onTap: () => onSelected(PropagationMethod.moss),
          ),
        ),
      ],
    );
  }
}

/// Строка-пикер даты среза с иконкой calendar, датой и стрелкой.
class _DatePickerRow extends ConsumerWidget {
  const _DatePickerRow({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final today = ref.watch(clockProvider).nowUtc().toLocal();
    final isToday = date != null &&
        date!.year == today.year &&
        date!.month == today.month &&
        date!.day == today.day;
    final formatted = date == null
        ? ''
        : DateFormat.yMMMMd(l10n.localeName).format(date!);

    return Semantics(
      button: true,
      label: formatted,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: c.line),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: c.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatted,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                        ),
                      ),
                      if (isToday) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.takeCuttingDateTodayHint,
                          style: TextStyle(fontSize: 11, color: c.inkSoft),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 18, color: c.inkSoft),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sticky нижняя панель: «Отмена» (surfaceWarm) + «🌱 Завести в семью» (primary).
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.canSubmit,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool canSubmit;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final Future<int?> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        14,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [c.bg, c.bg.withAlpha(0)],
          stops: const [0.7, 1],
        ),
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: l10n.takeCuttingCancel,
            child: Material(
              color: c.surfaceWarm,
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: isSubmitting ? null : onCancel,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: c.line),
                  ),
                  child: Text(
                    l10n.takeCuttingCancel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SubmitButton(
              enabled: canSubmit,
              loading: isSubmitting,
              onPressed: () => onSubmit(),
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
    required this.loading,
    required this.onPressed,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final active = enabled && !loading;
    return Semantics(
      button: true,
      enabled: active,
      label: l10n.takeCuttingSubmit,
      child: Material(
        color: active ? c.primary : c.inkMute,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: active ? onPressed : null,
          child: SizedBox(
            height: 52,
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(c.surface),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🌱', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          l10n.takeCuttingSubmit,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: c.surface,
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
