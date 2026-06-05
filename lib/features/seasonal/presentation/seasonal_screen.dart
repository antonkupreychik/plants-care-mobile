import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/season.dart';
import '../domain/seasonal_mode.dart';
import '../domain/seasonal_settings.dart';
import 'current_season_provider.dart';
import 'seasonal_controller.dart';

/// Экран 35 «Сезонные интервалы».
///
/// Потребляет `seasonalControllerProvider` → `AsyncValue<SeasonalState>` и
/// `currentSeasonProvider` (текущий сезон по [Clock]). Рисует: тумблер
/// авто-подстройки (`me.seasonalEnabled` через PATCH), карточку текущего сезона,
/// столбчатую диаграмму относительной частоты полива по 4 сезонам, сноску про
/// per-plant интервалы и декоративную цитату.
///
/// Контракт-граница: глобальный тумблер — `me.seasonalEnabled`/`seasonalMode`.
/// Точные сезонные интервалы (`summerIntervalDays`/`winterIntervalDays` из
/// `CareScheduleDto.seasonal`) считает backend per-plant и здесь НЕ
/// показываются (это глобальный экран без контекста растения) — об этом сноска.
/// Диаграмма частоты декоративна (относительные доли, не данные конкретного
/// растения) и приглушается, когда авто-подстройка выключена.
///
/// Состояния: loading (скелетон) / error загрузки (ErrorState + retry через
/// `ref.invalidate`) / data.
class SeasonalScreen extends ConsumerWidget {
  const SeasonalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(seasonalControllerProvider);

    // Ошибка переключения тумблера: снэкбар на смену saveError, экран не
    // закрываем (тумблер уже откатился в контроллере).
    ref.listen(
      seasonalControllerProvider.select((s) => s.value?.saveError),
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
                  onRetry: () => ref.invalidate(seasonalControllerProvider),
                ),
                data: (state) => _DataBody(
                  settings: state.settings,
                  saving: state.saving,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: назад + оверлайн «СЕЗОННЫЕ ИНТЕРВАЛЫ».
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
          _BackButton(tooltip: l10n.seasonalBack),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              l10n.seasonalOverline.toUpperCase(),
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
class _DataBody extends ConsumerWidget {
  const _DataBody({required this.settings, required this.saving});

  final SeasonalSettings settings;
  final bool saving;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final season = ref.watch(currentSeasonProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 40),
      children: [
        const _TitleHeader(),
        const SizedBox(height: 20),
        _ToggleCard(
          enabled: settings.enabled,
          mode: settings.mode,
          saving: saving,
        ),
        const SizedBox(height: 14),
        _CurrentSeasonCard(season: season, enabled: settings.enabled),
        const SizedBox(height: 24),
        _SectionLabel(text: l10n.seasonalSeasonsSection),
        const SizedBox(height: 10),
        _SeasonsChart(current: season, dimmed: !settings.enabled),
        const SizedBox(height: 16),
        const _NoteCard(),
        const SizedBox(height: 16),
        const _QuoteCard(),
      ],
    );
  }
}

/// Серифный заголовок «Уход по сезону» (акцент курсивом) + подзаголовок.
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
              TextSpan(text: l10n.seasonalTitleLead),
              TextSpan(
                text: l10n.seasonalTitleAccent,
                style: AppTheme.serif(
                  fontSize: 32,
                  color: c.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          style: AppTheme.serif(fontSize: 32, color: c.ink),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.seasonalSubtitle,
          style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.45),
        ),
      ],
    );
  }
}

/// Карточка тумблера авто-подстройки + пояснение режима.
class _ToggleCard extends ConsumerWidget {
  const _ToggleCard({
    required this.enabled,
    required this.mode,
    required this.saving,
  });

  final bool enabled;
  final SeasonalMode mode;
  final bool saving;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final modeText = switch (mode) {
      SeasonalMode.multiplier => l10n.seasonalModeMultiplier,
      SeasonalMode.fixed => l10n.seasonalModeFixed,
      // Нераспознанный режим — показываем нейтральную подпись тумблера.
      SeasonalMode.unknown => l10n.seasonalToggleSubtitle,
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.seasonalToggleTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  enabled ? modeText : l10n.seasonalToggleSubtitle,
                  style: TextStyle(fontSize: 12, color: c.inkSoft),
                ),
              ],
            ),
          ),
          Semantics(
            toggled: enabled,
            label: l10n.seasonalToggleTitle,
            child: Switch(
              value: enabled,
              // Пока идёт PATCH — блокируем повторное переключение.
              onChanged: saving
                  ? null
                  : (v) => ref.read(seasonalControllerProvider.notifier).toggle(v),
            ),
          ),
        ],
      ),
    );
  }
}

/// Карточка текущего сезона: подсветка с текстом про подстройку (или про
/// выключенное состояние).
class _CurrentSeasonCard extends StatelessWidget {
  const _CurrentSeasonCard({required this.season, required this.enabled});

  final Season season;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final seasonName = _seasonName(l10n, season);

    final title =
        enabled ? l10n.seasonalCardOnTitle : l10n.seasonalCardOffTitle;
    final body = enabled
        ? switch (season) {
            Season.spring => l10n.seasonalCardOnSpring,
            Season.summer => l10n.seasonalCardOnSummer,
            Season.autumn => l10n.seasonalCardOnAutumn,
            Season.winter => l10n.seasonalCardOnWinter,
          }
        : l10n.seasonalCardOffBody;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: enabled ? c.primarySoft : c.surfaceWarm,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.seasonalNowLabel(seasonName).toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: enabled ? c.primary : c.inkSoft,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTheme.serif(fontSize: 22, color: c.ink),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
        ],
      ),
    );
  }
}

/// Столбчатая диаграмма относительной частоты полива по 4 сезонам.
///
/// Высоты/проценты декоративны (относительные доли по дизайну), это НЕ данные
/// конкретного растения — точные интервалы считает backend per-plant. Текущий
/// сезон подсвечивается; при выключенной авто-подстройке вся диаграмма
/// приглушается (акцентный столбец теряет выделение).
class _SeasonsChart extends StatelessWidget {
  const _SeasonsChart({required this.current, required this.dimmed});

  final Season current;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    // (сезон, относительная высота 0..1, подпись доли, эмодзи).
    final bars = <(Season, double, String, String)>[
      (Season.spring, 0.62, l10n.seasonalSpringFactor, '🌱'),
      (Season.summer, 0.95, l10n.seasonalSummerFactor, '☀️'),
      (Season.autumn, 0.5, l10n.seasonalAutumnFactor, '🍂'),
      (Season.winter, 0.32, l10n.seasonalWinterFactor, '❄️'),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: SizedBox(
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final (season, height, factor, emoji) in bars)
              Expanded(
                child: _SeasonBar(
                  label: _seasonNameBare(l10n, season),
                  factor: factor,
                  emoji: emoji,
                  heightFactor: height,
                  highlighted: !dimmed && season == current,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SeasonBar extends StatelessWidget {
  const _SeasonBar({
    required this.label,
    required this.factor,
    required this.emoji,
    required this.heightFactor,
    required this.highlighted,
  });

  final String label;
  final String factor;
  final String emoji;
  final double heightFactor;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    // Максимальная высота столбца (px) внутри 150-высотного бокса с подписями
    // (factor + bar + emoji + label со спейсингом должны уместиться).
    const maxBarHeight = 72.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            factor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: highlighted ? c.primary : c.inkSoft,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: maxBarHeight * heightFactor,
            decoration: BoxDecoration(
              color: highlighted ? c.primary : c.surfaceWarm,
              borderRadius: BorderRadius.circular(10),
              border: highlighted ? null : Border.all(color: c.line),
            ),
          ),
          const SizedBox(height: 8),
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
              color: highlighted ? c.ink : c.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

/// Сноска про per-plant интервалы (контракт-граница: точные дни считает
/// backend для каждого растения).
class _NoteCard extends StatelessWidget {
  const _NoteCard();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: c.inkSoft),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.seasonalNote,
              style: TextStyle(fontSize: 12, color: c.inkSoft, height: 1.4),
            ),
          ),
        ],
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
          const Text('❄️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.seasonalQuote,
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

/// Loading: скелетон под структуру экрана.
class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 40),
      children: const [
        SkeletonBox(width: 200, height: 32, radius: 10),
        SizedBox(height: 8),
        SkeletonBox(width: 240, height: 13),
        SizedBox(height: 24),
        SkeletonBox(height: 64, radius: 22),
        SizedBox(height: 14),
        SkeletonBox(height: 120, radius: 22),
        SizedBox(height: 24),
        SkeletonBox(width: 160, height: 12),
        SizedBox(height: 10),
        SkeletonBox(height: 150, radius: 22),
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

/// Название сезона с эмодзи (для оверлайна «Сейчас · …»).
String _seasonName(AppLocalizations l10n, Season season) => switch (season) {
      Season.spring => l10n.seasonalSpring,
      Season.summer => l10n.seasonalSummer,
      Season.autumn => l10n.seasonalAutumn,
      Season.winter => l10n.seasonalWinter,
    };

/// Название сезона без эмодзи (для подписи столбца) — берёт первое слово из
/// локализованного названия с эмодзи.
String _seasonNameBare(AppLocalizations l10n, Season season) =>
    _seasonName(l10n, season).split(' ').first;
