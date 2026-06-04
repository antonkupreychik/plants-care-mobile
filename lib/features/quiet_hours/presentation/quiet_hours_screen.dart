import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/known_timezone.dart';
import '../domain/quiet_time.dart';
import '../domain/user_settings.dart';
import 'quiet_hours_controller.dart';
import 'widgets/quiet_hours_ring.dart';
import 'widgets/quiet_time_picker_sheet.dart';

/// Экран 23 «Тихие часы».
///
/// Потребляет `quietHoursControllerProvider` → `AsyncValue<QuietHoursState>`.
/// Рисует из `state.draft` (UserSettings): кольцо-визуализатор суток, две
/// карточки start/end (тап → пикер 36), таймзону (тап → экран 37) и
/// декоративные строки. Состояния: loading (скелетон) / error загрузки
/// (ErrorState + retry через `ref.invalidate`) / data.
///
/// G16-доводка: строки «Не беспокоить ночью» и «Утренний дайджест» НЕ покрыты
/// `/me` — рисуются визуально, но неактивными (бейдж «скоро», тумблер без
/// записи). UI не выдумывает для них состояние/запись.
class QuietHoursScreen extends ConsumerWidget {
  const QuietHoursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(quietHoursControllerProvider);

    // Ошибки сохранения (пикер/таймзона возвращают их сами, но на всякий —
    // показываем снэкбар на смену saveError, не закрывая экран).
    ref.listen(
      quietHoursControllerProvider.select((s) => s.value?.saveError),
      (prev, next) {
        if (next != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.messageForError(next))),
            );
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
                  onRetry: () =>
                      ref.invalidate(quietHoursControllerProvider),
                ),
                data: (state) => _DataBody(settings: state.draft),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: назад + оверлайн «УВЕДОМЛЕНИЯ И ВРЕМЯ».
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
          _BackButton(tooltip: l10n.quietHoursBack),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              l10n.quietHoursOverline.toUpperCase(),
              maxLines: 2,
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

/// Контент data-состояния.
class _DataBody extends StatelessWidget {
  const _DataBody({required this.settings});

  final UserSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 40),
      children: [
        const _TitleHeader(),
        const SizedBox(height: 20),
        QuietHoursRing(
          start: settings.quietHoursStart,
          end: settings.quietHoursEnd,
        ),
        const SizedBox(height: 16),
        const _Legend(),
        const SizedBox(height: 20),
        _TimeCards(
          start: settings.quietHoursStart,
          end: settings.quietHoursEnd,
        ),
        const SizedBox(height: 24),
        _SectionLabel(text: l10n.quietHoursParamsSection),
        const SizedBox(height: 10),
        _ParamsCard(timezone: settings.timezone),
        const SizedBox(height: 20),
        const _QuoteCard(),
      ],
    );
  }
}

/// Серифный заголовок «Тихие часы» (акцент курсивом) + подзаголовок.
class _TitleHeader extends StatelessWidget {
  const _TitleHeader();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: l10n.quietHoursTitleLead),
              TextSpan(
                text: l10n.quietHoursTitleAccent,
                style: AppTheme.serif(
                  fontSize: 36,
                  color: c.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          style: AppTheme.serif(fontSize: 36, color: c.ink),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.quietHoursSubtitle,
          style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

/// Легенда кольца: «Напоминания идут» / «Тишина».
class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(color: c.leafDark, label: l10n.quietHoursLegendOn),
        const SizedBox(width: 20),
        _LegendDot(color: c.leafLight, label: l10n.quietHoursLegendQuiet),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: c.inkSoft)),
      ],
    );
  }
}

/// Две карточки в ряд: «ЗАСЫПАЮ В {start}» и «ПРОСЫПАЮСЬ В {end}».
class _TimeCards extends StatelessWidget {
  const _TimeCards({required this.start, required this.end});

  final QuietTime start;
  final QuietTime end;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _TimeCard(
              label: l10n.quietHoursStartLabel,
              value: start,
              field: QuietHoursField.start,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TimeCard(
              label: l10n.quietHoursEndLabel,
              value: end,
              field: QuietHoursField.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.label,
    required this.value,
    required this.field,
  });

  final String label;
  final QuietTime value;
  final QuietHoursField field;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: '$label ${value.format()}',
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showQuietTimePickerSheet(
            context,
            field: field,
            initial: value,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 80),
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value.format(),
                        style: AppTheme.serif(fontSize: 28, color: c.ink),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 20, color: c.inkMute),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Карточка секции «Параметры»: строка таймзоны (→ экран 37) и две
/// декоративные (не покрытые backend) строки.
class _ParamsCard extends StatelessWidget {
  const _ParamsCard({required this.timezone});

  final String timezone;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _DndRow(),
          _TimezoneRow(timezone: timezone),
          _DigestRow(),
        ],
      ),
    );
  }
}

/// Строка таймзоны: «Таймзона» → «{city · GMT±N}» → тап открывает экран 37.
class _TimezoneRow extends StatelessWidget {
  const _TimezoneRow({required this.timezone});

  final String timezone;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final known = knownTimezoneById(timezone);
    // Если таймзона не из курируемого списка — показываем сырой IANA без GMT.
    final value = known != null
        ? l10n.quietHoursTimezoneValue(known.city, known.gmtLabel)
        : timezone;

    return Semantics(
      button: true,
      label: '${l10n.quietHoursTimezoneTitle} $value',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/profile/timezone'),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.quietHoursTimezoneTitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 13, color: c.inkSoft),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.chevron_right_rounded, size: 20, color: c.inkMute),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Декоративная строка «Не беспокоить ночью» с тумблером.
///
/// G16-доводка: поля нет в `/me`. Тумблер визуальный (включён по дизайну, но
/// `onChanged: null` — без записи). Подпись «Перенести просроченное на утро».
class _DndRow extends StatelessWidget {
  const _DndRow();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.quietHoursDndTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SoonBadge(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.quietHoursDndSubtitle,
                  style: TextStyle(fontSize: 12, color: c.inkSoft),
                ),
              ],
            ),
          ),
          // Тумблер без записи: backend-gap, onChanged null → disabled.
          ExcludeSemantics(
            child: Switch(value: true, onChanged: null),
          ),
        ],
      ),
    );
  }
}

/// Декоративная строка «Утренний дайджест 9:00».
///
/// G16-доводка: поля нет в `/me`. Время фиксированное (декоративное), строка
/// неактивна (бейдж «скоро», шеврон приглушён, тапа нет).
class _DigestRow extends StatelessWidget {
  const _DigestRow();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        l10n.quietHoursDigestTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: c.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SoonBadge(),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.quietHoursDigestSubtitle,
                  style: TextStyle(fontSize: 12, color: c.inkSoft),
                ),
              ],
            ),
          ),
          Text(
            l10n.quietHoursDigestTime,
            style: TextStyle(fontSize: 13, color: c.inkMute),
          ),
        ],
      ),
    );
  }
}

/// Бейдж «скоро» для контролов, не покрытых backend.
class _SoonBadge extends StatelessWidget {
  const _SoonBadge();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: c.chipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.quietHoursSoon.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: c.inkSoft,
        ),
      ),
    );
  }
}

/// Декоративная цитата внизу экрана.
class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌙', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.quietHoursQuote,
              style: AppTheme.serif(fontSize: 15, color: c.ink).copyWith(
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
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

/// Loading: скелетон под структуру экрана (заголовок, кольцо, карточки).
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 40),
      children: const [
        SkeletonBox(width: 200, height: 34, radius: 10),
        SizedBox(height: 8),
        SkeletonBox(width: 240, height: 13),
        SizedBox(height: 24),
        Center(child: SkeletonBox(width: 200, height: 200, radius: 100)),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 80, radius: 20)),
            SizedBox(width: 12),
            Expanded(child: SkeletonBox(height: 80, radius: 20)),
          ],
        ),
        SizedBox(height: 24),
        SkeletonBox(width: 120, height: 12),
        SizedBox(height: 10),
        SkeletonBox(height: 180, radius: 22),
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
