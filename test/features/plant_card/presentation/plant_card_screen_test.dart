import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_screen.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/widgets/plant_hero.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/widgets/plant_journal_card.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/widgets/plant_streak_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

const _plantId = 42;
final _utcNow = DateTime.utc(2026, 5, 27, 9);

typedef _Detail = Future<Plant> Function();
typedef _Streak = Future<Streak> Function();
typedef _History = Future<List<CareHistoryEntry>> Function();

Widget _wrap({
  _Detail? detail,
  _Streak? streak,
  _History? history,
}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      plantDetailProvider(_plantId).overrideWith(
        (ref) => (detail ?? () async => const Plant(id: _plantId, name: 'x'))(),
      ),
      plantStreakProvider(_plantId).overrideWith(
        (ref) =>
            (streak ?? () async => const Streak(plantId: _plantId, count: 0))(),
      ),
      plantHistoryProvider(_plantId).overrideWith(
        (ref) => (history ?? () async => const <CareHistoryEntry>[])(),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const PlantCardScreen(plantId: _plantId),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(PlantCardScreen)));

void main() {
  group('PlantCardScreen loading', () {
    testWidgets('should_show_skeletons_when_all_sections_loading',
        (tester) async {
      // Высокая поверхность, чтобы слиперы всех секций были в вьюпорте.
      tester.view.physicalSize = const Size(1080, 3600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(
        detail: _pending<Plant>,
        streak: _pending<Streak>,
        history: _pending<List<CareHistoryEntry>>,
      ));
      await tester.pump();

      expect(find.byType(PlantHeroSkeleton), findsOneWidget);
      expect(find.byType(PlantStreakCardSkeleton), findsOneWidget);
      expect(find.byType(PlantJournalCardSkeleton), findsOneWidget);
    });
  });

  group('PlantCardScreen error', () {
    testWidgets('should_show_error_with_retry_for_each_failing_section',
        (tester) async {
      await tester.pumpWidget(_wrap(
        detail: () async => throw const ApiError.notFound(),
        streak: () async => throw const ApiError.network(),
        history: () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      // Три секции упали → три ErrorState. Кнопка retry в каждой.
      expect(find.byType(ErrorState), findsNWidgets(3));
      expect(find.text(_l10n(tester).retry), findsNWidgets(3));
    });
  });

  group('PlantCardScreen empty', () {
    testWidgets('should_show_journal_empty_hint_when_history_empty',
        (tester) async {
      await tester.pumpWidget(_wrap(
        history: () async => const <CareHistoryEntry>[],
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.plantCardJournalEmpty), findsOneWidget);
      expect(find.text(l10n.plantCardJournalEmptyHint), findsOneWidget);
    });

    testWidgets('should_show_streak_empty_label_when_count_zero',
        (tester) async {
      await tester.pumpWidget(_wrap(
        streak: () async => const Streak(plantId: _plantId, count: 0),
      ));
      await tester.pumpAndSettle();

      expect(find.text(_l10n(tester).plantCardStreakEmpty), findsOneWidget);
    });
  });

  group('PlantCardScreen data', () {
    testWidgets('should_render_detail_streak_and_journal_when_data_present',
        (tester) async {
      await tester.pumpWidget(_wrap(
        detail: () async => const Plant(
          id: _plantId,
          name: 'Фикус',
          speciesName: 'Ficus',
          locationName: 'Кухня',
        ),
        streak: () async => const Streak(plantId: _plantId, count: 7),
        history: () async => [
          CareHistoryEntry(
            id: 1,
            plantId: _plantId,
            plantName: 'Фикус',
            kind: CareEventKind.water,
            performedAt: DateTime.utc(2026, 5, 26, 8),
            onTime: true,
            note: 'Полил утром',
          ),
        ],
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);

      // Деталь: имя + вид/локация в overline.
      expect(find.byType(PlantHero), findsOneWidget);
      expect(find.text('Фикус'), findsOneWidget);
      expect(find.text('FICUS · КУХНЯ'), findsOneWidget);

      // Стрик: счётчик (не empty).
      expect(find.byType(PlantStreakCard), findsOneWidget);
      expect(find.text(l10n.plantCardStreakCount(7)), findsOneWidget);
      expect(find.text(l10n.plantCardStreakEmpty), findsNothing);

      // Дневник: запись (подпись типа + заметка), пустой подписи нет.
      expect(find.byType(PlantJournalCard), findsOneWidget);
      expect(find.text(l10n.careDoneWater), findsOneWidget);
      expect(find.text('Полил утром'), findsOneWidget);
      expect(find.text(l10n.plantCardJournalEmpty), findsNothing);
    });
  });

  group('PlantCardScreen log-care action', () {
    testWidgets('should_open_log_care_sheet_when_log_care_tapped',
        (tester) async {
      await tester.pumpWidget(_wrap(
        detail: () async => const Plant(id: _plantId, name: 'Фикус'),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);

      // До тапа sheet не открыт — его контролов на экране нет.
      expect(find.text(l10n.careSheetSubmit), findsNothing);

      await tester.tap(find.text(l10n.plantCardLogCare));
      await tester.pumpAndSettle(); // проиграть анимацию открытия sheet

      // Открылся sheet отметки ухода (а не comingSoon snackbar):
      // присутствуют его маркеры — лейбл «Тип ухода» и кнопка «Отметить».
      expect(find.text(l10n.careSheetTypeLabel.toUpperCase()), findsOneWidget);
      expect(find.text(l10n.careSheetSubmit), findsOneWidget);
      expect(find.text(l10n.comingSoon), findsNothing);
    });
  });

  group('PlantCardScreen timezone', () {
    testWidgets(
        'should_render_journal_time_in_local_tz_not_raw_utc_when_offset_present',
        (tester) async {
      // performedAt = 23:00 UTC. Журнал форматирует через `.toLocal()`.
      // В НЕ-UTC окружении (тест-процесс с TZ != UTC) локальный час ≠ 23,
      // и подпись обязана совпасть с локальным форматированием, а не с UTC.
      final performedUtc = DateTime.utc(2026, 5, 26, 23, 0);

      await tester.pumpWidget(_wrap(
        history: () async => [
          CareHistoryEntry(
            id: 1,
            plantId: _plantId,
            plantName: 'Фикус',
            kind: CareEventKind.water,
            performedAt: performedUtc,
            onTime: false,
          ),
        ],
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final local = performedUtc.toLocal();
      final expectedLabel = l10n.plantCardHistoryDate(
        DateFormat.MMMd(l10n.localeName).format(local),
        DateFormat.Hm(l10n.localeName).format(local),
      );

      // Подпись = локальное форматирование (load-bearing: совпадает с .toLocal()).
      expect(find.text(expectedLabel), findsOneWidget);

      // Если окружение реально не-UTC — убеждаемся, что это НЕ сырой UTC-час.
      if (local.hour != performedUtc.hour) {
        final rawUtcLabel = l10n.plantCardHistoryDate(
          DateFormat.MMMd(l10n.localeName).format(performedUtc),
          DateFormat.Hm(l10n.localeName).format(performedUtc),
        );
        expect(find.text(rawUtcLabel), findsNothing);
      }
    });
  });
}
