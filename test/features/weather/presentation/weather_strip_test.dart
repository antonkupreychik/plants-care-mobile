import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/weather/domain/watering_recommendation.dart';
import 'package:plantcare_mobile/features/weather/domain/weather_snapshot.dart';
import 'package:plantcare_mobile/features/weather/presentation/weather_providers.dart';
import 'package:plantcare_mobile/features/weather/presentation/widgets/weather_strip.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<WeatherSnapshot> _pending() => Completer<WeatherSnapshot>().future;

Widget _wrap(Future<WeatherSnapshot> Function() snapshot) {
  return ProviderScope(
    overrides: [
      weatherSnapshotProvider.overrideWith((ref) => snapshot()),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const Scaffold(body: WeatherStrip()),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold)));

void main() {
  group('WeatherStrip', () {
    testWidgets('should_show_humidity_and_deferOk_advice_when_data',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const WeatherSnapshot(
          available: true,
          humidityPercent: 88,
          recommendation: WateringRecommendation.deferOk,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(_l10n(tester).weatherHumidity(88)), findsOneWidget);
      expect(find.text(_l10n(tester).weatherAdviceDeferOk), findsOneWidget);
    });

    testWidgets('should_show_doNotDefer_advice_when_recommendation_doNotDefer',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const WeatherSnapshot(
          available: true,
          humidityPercent: 20,
          recommendation: WateringRecommendation.doNotDefer,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(_l10n(tester).weatherHumidity(20)), findsOneWidget);
      expect(find.text(_l10n(tester).weatherAdviceDoNotDefer), findsOneWidget);
    });

    // neutral → влажность есть, но отдельного совета нет (строка не пестрит).
    testWidgets('should_show_humidity_without_advice_when_neutral',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const WeatherSnapshot(
          available: true,
          humidityPercent: 50,
          recommendation: WateringRecommendation.neutral,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(_l10n(tester).weatherHumidity(50)), findsOneWidget);
      expect(find.text(_l10n(tester).weatherAdviceDeferOk), findsNothing);
      expect(find.text(_l10n(tester).weatherAdviceDoNotDefer), findsNothing);
    });

    testWidgets('should_show_humidity_without_advice_when_recommendation_null',
        (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const WeatherSnapshot(
          available: true,
          humidityPercent: 50,
          recommendation: null,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(_l10n(tester).weatherHumidity(50)), findsOneWidget);
      expect(find.text(_l10n(tester).weatherAdviceDeferOk), findsNothing);
      expect(find.text(_l10n(tester).weatherAdviceDoNotDefer), findsNothing);
    });

    // КЛЮЧЕВОЕ: available=false (hasData=false) — строки нет вообще, даже без
    // влажности. Десериализация null-полей не должна ронять виджет.
    testWidgets('should_render_nothing_when_available_false', (tester) async {
      await tester.pumpWidget(_wrap(
        () async => const WeatherSnapshot(available: false),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Row), findsNothing);
      expect(find.textContaining('Влажность'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should_render_nothing_when_loading', (tester) async {
      await tester.pumpWidget(_wrap(_pending));
      await tester.pump();

      expect(find.byType(Row), findsNothing);
      expect(find.textContaining('Влажность'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should_hide_silently_when_error', (tester) async {
      await tester.pumpWidget(_wrap(
        () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsNothing);
      expect(find.textContaining('Влажность'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
