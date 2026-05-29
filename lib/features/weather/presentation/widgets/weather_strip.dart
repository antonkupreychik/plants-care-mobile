import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/watering_recommendation.dart';
import '../weather_providers.dart';

/// Микро-строка погоды на Home (G4) — под хедером, над карточкой «Сегодня».
///
/// Дизайн-референс: `design/screens.jsx` WEATHER STRIP (строки 309–315).
/// Реальный API отдаёт только влажность (`humidityPercent`) и рекомендацию
/// (`recommendation`) — температуру/текст погоды не показываем. Строка:
/// иконка-капля + «Влажность N%» + точка-разделитель + совет (primary).
///
/// Погода НЕ критична для Home: loading/error/`!hasData` тихо сворачиваются в
/// [SizedBox.shrink] — экран остаётся живым и появляется строка только когда
/// данные пришли (см. [WeatherSnapshot.hasData]).
class WeatherStrip extends ConsumerWidget {
  const WeatherStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(weatherSnapshotProvider);

    // Тихая деградация: пока грузится / при ошибке / когда погода не настроена
    // — строки нет. Home не блокируется.
    final data = snapshot.value;
    if (data == null || !data.hasData) return const SizedBox.shrink();

    return _WeatherStripContent(
      humidityPercent: data.humidityPercent!,
      recommendation: data.recommendation,
    );
  }
}

/// Сама строка (рисуется только при наличии данных).
class _WeatherStripContent extends StatelessWidget {
  const _WeatherStripContent({
    required this.humidityPercent,
    required this.recommendation,
  });

  final int humidityPercent;
  final WateringRecommendation? recommendation;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final humidityText = l10n.weatherHumidity(humidityPercent);
    final advice = _adviceText(l10n, recommendation);

    final semanticsLabel = advice == null
        ? l10n.weatherSemanticsHumidityOnly(humidityPercent)
        : l10n.weatherSemanticsWithAdvice(humidityPercent, advice);

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: Padding(
        // Горизонтальный паддинг как у соседних секций Home (~22 по бокам).
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
        child: Row(
          children: [
            Icon(Icons.water_drop_outlined, size: 14, color: c.inkSoft),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                humidityText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: c.inkSoft,
                ),
              ),
            ),
            if (advice != null) ...[
              const SizedBox(width: 10),
              _Dot(color: c.inkMute),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  advice,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: c.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Маппинг enum рекомендации → текст совета (presentation, через l10n).
  /// `neutral`/`null` — без отдельного совета (показываем только влажность),
  /// чтобы строка не пестрила.
  static String? _adviceText(
    AppLocalizations l10n,
    WateringRecommendation? recommendation,
  ) =>
      switch (recommendation) {
        WateringRecommendation.deferOk => l10n.weatherAdviceDeferOk,
        WateringRecommendation.doNotDefer => l10n.weatherAdviceDoNotDefer,
        WateringRecommendation.neutral || null => null,
      };
}

/// Точка-разделитель 4×4 (дизайн: `inkMute`).
class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
