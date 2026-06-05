import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vacation_range.dart';
import 'vacation_controller.dart';
import 'vacation_state.dart';
import 'widgets/vacation_active_banner.dart';
import 'widgets/vacation_date_card.dart';
import 'widgets/vacation_effects_card.dart';

/// Экран 25 «Режим отпуска».
///
/// Потребляет `vacationControllerProvider` → `AsyncValue<VacationState>`.
/// Состояния: loading (скелетон) / error загрузки (ErrorState + retry через
/// `ref.invalidate`) / data. В data: при активном отпуске — баннер «Отпуск
/// включён» + кнопка «Завершить отпуск» (`DELETE`); иначе — выбор диапазона дат
/// (две карточки → showDatePicker), пояснения и кнопка «Включить отпуск»
/// (`POST`).
///
/// «Передача догляда»/совместный уход (дизайн 25) НЕ реализованы — это
/// отдельный sharing-эндпоинт (issue #77), которого нет в текущем контракте;
/// клиентский воркэраунд недопустим (FLUTTER.md «контракт»).
class VacationScreen extends ConsumerWidget {
  const VacationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(vacationControllerProvider);

    // Ошибки действия (POST/DELETE) — снэкбаром, не закрывая экран.
    ref.listen(
      vacationControllerProvider.select((s) => s.value?.actionError),
      (prev, next) {
        if (next != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.messageForError(next))));
        }
      },
    );

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: async.when(
                loading: () => const _LoadingBody(),
                error: (error, _) => _ErrorBody(
                  message: l10n.messageForError(error),
                  onRetry: () => ref.invalidate(vacationControllerProvider),
                ),
                data: (state) => _DataBody(state: state),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: назад + оверлайн «РЕЖИМ ОТПУСКА».
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          _BackButton(tooltip: l10n.vacationBack),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              l10n.vacationOverline.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: c.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.tooltip});

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _pop(context),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(Icons.arrow_back_rounded, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

void _pop(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/profile');
  }
}

/// Контент data-состояния: ветвится по активности отпуска.
class _DataBody extends ConsumerWidget {
  const _DataBody({required this.state});

  final VacationState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 110),
          children: [
            const _TitleHeader(),
            const SizedBox(height: 20),
            if (state.isActive)
              VacationActiveBanner(pausedUntil: state.status.pausedUntil)
            else ...[
              _DateRangeCard(range: state.range),
              const SizedBox(height: 24),
              _SectionLabel(text: l10n.vacationWhatHappensSection),
              const SizedBox(height: 10),
              const VacationEffectsCard(),
            ],
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _Cta(state: state),
        ),
      ],
    );
  }
}

/// Серифный заголовок «Уезжаешь? Сад подождёт» + подзаголовок.
class _TitleHeader extends StatelessWidget {
  const _TitleHeader();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🏖', style: TextStyle(fontSize: 36)),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: l10n.vacationTitleLead),
              TextSpan(
                text: l10n.vacationTitleAccent,
                style: AppTheme.serif(
                  fontSize: 34,
                  color: c.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          style: AppTheme.serif(fontSize: 34, color: c.ink),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.vacationSubtitle,
          style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

/// Карточка выбора диапазона дат: две карточки С/По + длительность/ошибка.
class _DateRangeCard extends ConsumerWidget {
  const _DateRangeCard({required this.range});

  final VacationRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(vacationControllerProvider.notifier);
    final nowLocal = ref.read(clockProvider).nowUtc().toLocal();
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: VacationDateCard(
                    label: l10n.vacationFromLabel,
                    date: range.from,
                    onTap: () => _pickFrom(context, controller, today),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: VacationDateCard(
                    label: l10n.vacationToLabel,
                    date: range.to,
                    onTap: () => _pickTo(context, controller, range.from),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            range.isValid
                ? l10n.vacationDaysCount(range.days)
                : l10n.vacationRangeTooLong(kVacationMaxDays),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: range.isValid ? c.primary : c.terracotta,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFrom(
    BuildContext context,
    VacationController controller,
    DateTime today,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: range.from.isBefore(today) ? today : range.from,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) controller.setFrom(picked);
  }

  Future<void> _pickTo(
    BuildContext context,
    VacationController controller,
    DateTime from,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: range.to.isBefore(from) ? from : range.to,
      firstDate: from,
      lastDate: from.add(const Duration(days: kVacationMaxDays - 1)),
    );
    if (picked != null) controller.setTo(picked);
  }
}

/// Нижняя кнопка действия (включить / завершить), с градиентным фоном.
class _Cta extends ConsumerWidget {
  const _Cta({required this.state});

  final VacationState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(vacationControllerProvider.notifier);

    final label = state.isActive ? l10n.vacationDisableCta : l10n.vacationEnableCta;
    final enabled = state.isActive ? !state.busy : state.canEnable;

    Future<void> onPressed() async {
      final error = state.isActive
          ? await controller.disable()
          : await controller.enable();
      if (!context.mounted || error != null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              state.isActive
                  ? l10n.vacationDisabledSnack
                  : l10n.vacationEnabledSnack,
            ),
          ),
        );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        14,
        16,
        18 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [c.bg, c.bg.withValues(alpha: 0)],
          stops: const [0.72, 1],
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: state.isActive ? c.terracotta : c.ink,
            foregroundColor: c.surface,
            disabledBackgroundColor: c.inkMute,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: state.busy
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: c.surface,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
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

/// Loading: скелетон под структуру экрана.
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 40),
      children: const [
        SkeletonBox(width: 48, height: 40, radius: 10),
        SizedBox(height: 10),
        SkeletonBox(width: 240, height: 34, radius: 10),
        SizedBox(height: 8),
        SkeletonBox(width: 220, height: 13),
        SizedBox(height: 24),
        SkeletonBox(height: 150, radius: 22),
        SizedBox(height: 24),
        SkeletonBox(width: 140, height: 12),
        SizedBox(height: 10),
        SkeletonBox(height: 140, radius: 22),
      ],
    );
  }
}

/// Error загрузки: ErrorState по центру с retry.
class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: ErrorState(
          message: message,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
      ),
    );
  }
}

/// Формат даты для карточек/баннера (локаль ru): «14 июня 2026 г.».
String formatVacationDate(BuildContext context, DateTime date) {
  final l10n = AppLocalizations.of(context);
  return DateFormat.yMMMMd(l10n.localeName).format(date);
}

/// Короткий формат даты для карточек: «14 июня».
String formatVacationDateShort(BuildContext context, DateTime date) {
  final l10n = AppLocalizations.of(context);
  return DateFormat.MMMMd(l10n.localeName).format(date);
}
