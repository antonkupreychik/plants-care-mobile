import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/care_event/presentation/first_care_success_screen.dart';
import 'package:plantcare_mobile/features/care_event/presentation/next_care_due_provider.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Никогда не завершается → nextCareDueProvider остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

const _plantId = 42;
// «Сейчас» зафиксировано — относительная метка «через N дн.» детерминирована.
final _now = DateTime.utc(2026, 6, 1, 9);

Widget _wrap({
  required CareEventKind careKind,
  required Future<DateTime?> Function() nextDue,
}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_now)),
      plantDetailProvider(_plantId).overrideWith(
        (ref) async => const Plant(id: _plantId, name: 'Фикус'),
      ),
      // nextCareDueProvider именован по plantId/kind — override под kind теста.
      nextCareDueProvider(plantId: _plantId, kind: careKind).overrideWith(
        (ref) => nextDue(),
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
        onTime: true,
      ),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(FirstCareSuccessScreen)));

/// Текст из rich-Text футера недоступен через find.text — собираем plain-текст
/// всех RichText. Load-bearing: счётчик — Text.rich с болдом относительной части.
String _allText(WidgetTester tester) {
  final buffer = StringBuffer();
  for (final w in tester.widgetList<RichText>(find.byType(RichText))) {
    buffer.write(w.text.toPlainText());
    buffer.write('\n');
  }
  return buffer.toString();
}

void main() {
  group('FirstCareSuccessScreen footer counter — data(non-null)', () {
    testWidgets(
        'should_show_water_counter_with_relative_part_and_no_generic_hint',
        (tester) async {
      // nextDueAt = +5 дней от «сейчас» (1 июня) → «через 5 дн.».
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        nextDue: () async => DateTime.utc(2026, 6, 6, 9),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final text = _allText(tester);

      // Тип-специфичный префикс полива + относительная часть «через 5 дн.».
      expect(text, contains(l10n.firstCareSuccessNextPrefixWater));
      expect(text, contains(l10n.editScheduleDueInDays(5)));
      expect(text, contains(l10n.firstCareSuccessNextSuffix));
      // Generic-хинт НЕ показан, когда есть конкретный срок.
      expect(find.text(l10n.firstCareSuccessNextHint), findsNothing);
    });

    testWidgets('should_use_fertilize_prefix_when_careKind_fertilize',
        (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.fertilize,
        nextDue: () async => DateTime.utc(2026, 6, 6, 9),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final text = _allText(tester);

      // Префикс именно подкормки — доказывает keying по careKind, не константу.
      expect(text, contains(l10n.firstCareSuccessNextPrefixFertilize));
      expect(text, isNot(contains(l10n.firstCareSuccessNextPrefixWater)));
      expect(find.text(l10n.firstCareSuccessNextHint), findsNothing);
    });

    testWidgets('should_render_bold_relative_part_as_separate_span',
        (tester) async {
      // Болд относительной части — load-bearing: ловим отдельный span с w700.
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        nextDue: () async => DateTime.utc(2026, 6, 6, 9),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final relative = l10n.editScheduleDueInDays(5);

      // Среди RichText футера есть span с текстом «через 5 дн.» и FontWeight.w700.
      var foundBold = false;
      for (final rich in tester.widgetList<RichText>(find.byType(RichText))) {
        rich.text.visitChildren((span) {
          if (span is TextSpan &&
              span.text == relative &&
              span.style?.fontWeight == FontWeight.w700) {
            foundBold = true;
          }
          return true;
        });
      }
      expect(foundBold, isTrue,
          reason: 'относительная часть «$relative» должна быть болдом');
    });
  });

  group('FirstCareSuccessScreen footer — generic hint degrade', () {
    testWidgets('should_show_generic_hint_when_data_null', (tester) async {
      // Срок не определён (выключено / нет расписания) → провайдер вернул null.
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        nextDue: () async => null,
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.firstCareSuccessNextHint), findsOneWidget);
      // Счётчика (префикс+суффикс) нет.
      expect(_allText(tester),
          isNot(contains(l10n.firstCareSuccessNextPrefixWater)));
    });

    testWidgets('should_show_generic_hint_while_loading', (tester) async {
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        nextDue: _pending<DateTime?>,
      ));
      // Деталь растения резолвится, провайдер срока висит в loading.
      await tester.pump();
      await tester.pump();

      final l10n = _l10n(tester);
      expect(find.text(l10n.firstCareSuccessNextHint), findsOneWidget);
      expect(_allText(tester),
          isNot(contains(l10n.firstCareSuccessNextPrefixWater)));
    });

    testWidgets('should_show_generic_hint_and_no_error_wall_when_error',
        (tester) async {
      // Запрос расписаний упал → мягкая деградация: празднование цело.
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        nextDue: () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.firstCareSuccessNextHint), findsOneWidget);
      // Празднование на месте — error срока не превращает экран в стену ошибки.
      expect(find.text(l10n.firstCareSuccessBubble), findsOneWidget);
      expect(find.text(l10n.firstCareSuccessCta), findsOneWidget);
      expect(_allText(tester),
          isNot(contains(l10n.firstCareSuccessNextPrefixWater)));
    });

    testWidgets('should_show_generic_hint_when_careKind_unknown',
        (tester) async {
      // unknown не имеет префикса → даже при data(non-null) деградируем к generic.
      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.unknown,
        nextDue: () async => DateTime.utc(2026, 6, 6, 9),
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.firstCareSuccessNextHint), findsOneWidget);
    });
  });

  group('FirstCareSuccessScreen footer — non-UTC timezone', () {
    // Относительная часть «через N дн.» обязана считаться по ЛОКАЛЬНОЙ дате
    // nextDueAt (nextDueLabel(.toLocal())), а не по её UTC-дню. Конструируем
    // nextDueAt у границы суток так, чтобы UTC-день ≠ локальный день, и фиксируем
    // nowLocal так, чтобы разница в днях зависела от выбора local vs UTC:
    //   - host восточнее UTC: due 6 июня 23:30Z → локально 7 июня → «через 6 дн.»
    //     (по UTC-дню дало бы «через 5 дн.»).
    //   - host западнее UTC: due 6 июня 00:30Z → локально 5 июня → «через 4 дн.»
    //     (по UTC-дню дало бы «через 5 дн.»).
    // clockProvider зафиксирован 1 июня 09:00Z; «сейчас» локально — 1 июня
    // (час сдвинется TZ, но календарный день у дневного UTC-часа устойчив).
    testWidgets('should_compute_days_from_local_date_of_nextDueAt',
        (tester) async {
      final offset = DateTime.now().timeZoneOffset;

      final DateTime dueUtc;
      final int expectedDays;
      if (offset.isNegative) {
        dueUtc = DateTime.utc(2026, 6, 6, 0, 30); // локально → 5 июня
        expectedDays = 4;
      } else {
        dueUtc = DateTime.utc(2026, 6, 6, 23, 30); // локально → 7 июня
        expectedDays = 6;
      }

      // Подтверждаем, что сдвиг реально перевёл календарный день due.
      expect(dueUtc.toLocal().day, isNot(dueUtc.day));

      await tester.pumpWidget(_wrap(
        careKind: CareEventKind.water,
        nextDue: () async => dueUtc,
      ));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      final text = _allText(tester);
      // Метка по локальной дате — не «через 5 дн.» (UTC-день).
      expect(text, contains(l10n.editScheduleDueInDays(expectedDays)));
      expect(text, isNot(contains(l10n.editScheduleDueInDays(5))));
      // host TZ == UTC: сдвиг календарного дня воспроизвести нельзя.
    }, skip: DateTime.now().timeZoneOffset == Duration.zero);
  });
}
