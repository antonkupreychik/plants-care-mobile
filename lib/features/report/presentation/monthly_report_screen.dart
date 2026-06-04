import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import 'report_providers.dart';
import 'widgets/report_big_numbers.dart';
import 'widgets/report_by_type.dart';
import 'widgets/report_empty.dart';
import 'widgets/report_header.dart';
import 'widgets/report_hero.dart';
import 'widgets/report_loading.dart';
import 'widgets/report_share_cta.dart';
import 'widgets/report_weekly_trend.dart';

/// Экран 14 «Месячный отчёт» (push `/profile/report`, поверх shell).
///
/// Потребляет [monthlyReportProvider]`(`[currentReportMonthProvider]`)` —
/// `AsyncValue<MonthlyReport>`. Реализованы все 4 состояния:
/// - loading → [ReportLoading] (шапка-заглушка + skeleton под раскладку);
/// - error → шапка + [ErrorState] с retry
///   (`ref.invalidate(monthlyReportProvider(month))`), текст по типу `ApiError`
///   через `messageForError`;
/// - empty (`report.isEmpty`) → шапка + [ReportEmpty];
/// - data → шапка + hero + большие числа + разбивка по типам + недельный тренд +
///   нижняя CTA.
///
/// Per-plant блоки «Звёзды месяца»/«Личный рекорд» и дельты дизайна v4 опущены —
/// backend этих данных не отдаёт. «Поделиться» (шапка и нижняя CTA) — coming-soon
/// (SnackBar `l10n.comingSoon`).
class MonthlyReportScreen extends ConsumerWidget {
  const MonthlyReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final month = ref.watch(currentReportMonthProvider);
    final async = ref.watch(monthlyReportProvider(month));

    void comingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () => ReportLoading(onShare: comingSoon),
          error: (error, _) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              ReportHeader(onShare: comingSoon),
              const SizedBox(height: 24),
              ErrorState(
                message: l10n.messageForError(error),
                retryLabel: l10n.retry,
                onRetry: () =>
                    ref.invalidate(monthlyReportProvider(month)),
              ),
            ],
          ),
          data: (report) {
            if (report.isEmpty) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  ReportHeader(onShare: comingSoon),
                  const SizedBox(height: 24),
                  const ReportEmpty(),
                ],
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
              children: [
                ReportHeader(onShare: comingSoon),
                const SizedBox(height: 14),
                ReportHero(report: report),
                const SizedBox(height: 16),
                ReportBigNumbers(report: report),
                const SizedBox(height: 24),
                ReportByType(byType: report.byType),
                if (report.healthTrend.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  ReportWeeklyTrend(buckets: report.healthTrend),
                ],
                const SizedBox(height: 28),
                ReportShareCta(onTap: comingSoon),
              ],
            );
          },
        ),
      ),
    );
  }
}
