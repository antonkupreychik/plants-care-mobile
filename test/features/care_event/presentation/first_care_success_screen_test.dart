import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/care_event/presentation/first_care_success_screen.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

const _plantId = 42;

typedef _Detail = Future<Plant> Function();

Widget _wrap({
  required CareEventKind careKind,
  required bool onTime,
  _Detail? detail,
}) {
  return ProviderScope(
    overrides: [
      plantDetailProvider(_plantId).overrideWith(
        (ref) =>
            (detail ?? () async => const Plant(id: _plantId, name: 'Фикус'))(),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: FirstCareSuccessScreen(
        plantId: _plantId,
        careKind: careKind,
        onTime: onTime,
      ),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(FirstCareSuccessScreen)));

/// Собирает весь текст экрана из обычных Text и rich-Text (заголовок —
/// `Text.rich`, его не найти через `find.text`). Load-bearing для проверки
/// типизированного глагола.
String _allText(WidgetTester tester) {
  final buffer = StringBuffer();
  for (final w in tester.widgetList<RichText>(find.byType(RichText))) {
    buffer.write(w.text.toPlainText());
    buffer.write('\n');
  }
  return buffer.toString();
}

void main() {
  group('FirstCareSuccessScreen data', () {
    testWidgets('should_render_eyebrow_bubble_and_cta_when_plant_loaded',
        (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        onTime: true,
        detail: () async => const Plant(
          id: _plantId,
          name: 'Фикус',
          speciesName: 'Ficus',
        ),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.firstCareSuccessEyebrow.toUpperCase()),
          findsOneWidget);
      expect(find.text(l10n.firstCareSuccessBubble), findsOneWidget);
      expect(find.text(l10n.firstCareSuccessCta), findsOneWidget);
      // Без стены ошибки в норме.
      expect(find.byType(ErrorState), findsNothing);
    });

    testWidgets('should_render_water_verb_when_careKind_water', (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        onTime: true,
        detail: () async => const Plant(id: _plantId, name: 'Фикус'),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final text = _allText(tester);
      expect(text, contains('Фикус'));
      expect(text, contains(l10n.firstCareSuccessVerbWater)); // «напоена»
      // Не глагол другого типа (доказывает keying по careKind, а не константу).
      expect(text, isNot(contains(l10n.firstCareSuccessVerbFertilize)));
    });

    testWidgets('should_render_fertilize_verb_when_careKind_fertilize',
        (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.fertilize,
        onTime: true,
        detail: () async => const Plant(id: _plantId, name: 'Фикус'),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final text = _allText(tester);
      expect(text, contains(l10n.firstCareSuccessVerbFertilize)); // «удобрена»
      expect(text, isNot(contains(l10n.firstCareSuccessVerbWater)));
    });
  });

  group('FirstCareSuccessScreen streak chip', () {
    testWidgets('should_show_streak_chip_when_onTime_true', (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        onTime: true,
      ));
      await tester.pumpAndSettle();

      expect(
        find.text(_l10n(tester).firstCareSuccessStreakDayOne),
        findsOneWidget,
      );
    });

    testWidgets('should_hide_streak_chip_when_onTime_false', (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        onTime: false,
      ));
      await tester.pumpAndSettle();

      // Поздний первый уход стрик не начинает — чипа быть не должно.
      expect(
        find.text(_l10n(tester).firstCareSuccessStreakDayOne),
        findsNothing,
      );
    });
  });

  group('FirstCareSuccessScreen loading', () {
    testWidgets('should_show_loader_and_no_crash_while_detail_loading',
        (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        onTime: true,
        detail: _pending<Plant>,
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Празднование ещё не нарисовано (имя не пришло), но CTA-футер всегда есть.
      expect(find.text(_l10n(tester).firstCareSuccessCta), findsOneWidget);
    });
  });

  group('FirstCareSuccessScreen error degrade', () {
    testWidgets('should_degrade_to_fallback_name_without_error_wall',
        (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        onTime: true,
        detail: () async => throw const ApiError.notFound(),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Уход уже записан → НЕ стена ошибки, а то же празднование.
      expect(find.byType(ErrorState), findsNothing);
      // Нейтральное имя-фолбэк присутствует в заголовке.
      expect(_allText(tester), contains(l10n.firstCareSuccessFallbackPlantName));
      // Празднование и CTA на месте.
      expect(find.text(l10n.firstCareSuccessBubble), findsOneWidget);
      expect(find.text(l10n.firstCareSuccessCta), findsOneWidget);
    });
  });
}
