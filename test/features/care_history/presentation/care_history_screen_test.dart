import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/care_history/data/care_history_repository_provider.dart';
import 'package:plantcare_mobile/features/care_history/domain/care_history_page.dart';
import 'package:plantcare_mobile/features/care_history/domain/care_history_repository.dart';
import 'package:plantcare_mobile/features/care_history/presentation/care_history_providers.dart';
import 'package:plantcare_mobile/features/care_history/presentation/care_history_screen.dart';
import 'package:plantcare_mobile/features/care_history/presentation/care_history_state.dart';
import 'package:plantcare_mobile/features/care_history/presentation/widgets/care_history_empty.dart';
import 'package:plantcare_mobile/features/care_history/presentation/widgets/care_history_filter_chips.dart';
import 'package:plantcare_mobile/features/care_history/presentation/widgets/care_history_load_more.dart';
import 'package:plantcare_mobile/features/care_history/presentation/widgets/care_history_timeline.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements CareHistoryRepository {}

const _plantId = 42;
const _pageSize = 50;

Future<T> _pending<T>() => Completer<T>().future;

CareHistoryEntry _entry(
  int id, {
  CareEventKind kind = CareEventKind.water,
  DateTime? performedAt,
}) =>
    CareHistoryEntry(
      id: id,
      plantId: _plantId,
      plantName: 'Фикус',
      kind: kind,
      performedAt: performedAt ?? DateTime.utc(2026, 5, 27, 8),
      onTime: true,
    );

CareHistoryPage _page({
  required List<CareHistoryEntry> items,
  required int total,
  required int offset,
}) =>
    CareHistoryPage(items: items, total: total, limit: _pageSize, offset: offset);

/// Большая поверхность, чтобы весь таймлайн помещался в один кадр (фильтр-чипы,
/// группы, футер — все участники assert'ов видны без скролла).
void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _wrap(CareHistoryRepository repo) => ProviderScope(
      overrides: [careHistoryRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const CareHistoryScreen(plantId: _plantId),
      ),
    );

/// Стандартная заглушка: деталь и стрик отдаются успешно, история — по [history].
void _stubAux(_MockRepo repo, {DateTime? createdAt}) {
  when(() => repo.getPlant(_plantId)).thenAnswer(
    (_) async => Result.success(
      Plant(
        id: _plantId,
        name: 'Фикус',
        speciesName: 'Ficus',
        createdAt: createdAt ?? DateTime.utc(2026, 1, 1),
      ),
    ),
  );
  when(() => repo.getStreak(_plantId)).thenAnswer(
    (_) async => const Result.success(Streak(plantId: _plantId, count: 3)),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(CareHistoryScreen)));

/// Текст [label] внутри ленты фильтр-чипов (тот же текст есть в строках
/// таймлайна — ограничиваем поиск чипами, чтобы тапнуть именно по фильтру).
Finder _chip(String label) => find.descendant(
      of: find.byType(CareHistoryFilterChips),
      matching: find.text(label),
    );

void main() {
  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
  });

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  group('CareHistoryScreen states', () {
    testWidgets('should_show_skeleton_when_loading', (tester) async {
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) => _pending<Result<CareHistoryPage>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      // Первичная загрузка: индикатор дозагрузки в _LoadingView, без таймлайна.
      expect(find.byType(CareHistoryLoadMoreIndicator), findsOneWidget);
      expect(find.byType(CareHistoryTimelineRow), findsNothing);
    });

    testWidgets('should_show_error_with_retry_when_initial_load_fails',
        (tester) async {
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(_l10n(tester).retry), findsOneWidget);
    });

    testWidgets('should_show_empty_screen_31_when_total_zero', (tester) async {
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(_page(items: const [], total: 0, offset: 0)),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Экран 31, а не таймлайн.
      expect(find.byType(CareHistoryEmpty), findsOneWidget);
      expect(find.text(_l10n(tester).careHistoryEmptyCta), findsOneWidget);
      expect(find.byType(CareHistoryTimelineRow), findsNothing);
    });

    testWidgets('should_render_timeline_when_data', (tester) async {
      _tallSurface(tester);
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2), _entry(3)], total: 3, offset: 0),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(CareHistoryTimelineRow), findsNWidgets(3));
      expect(find.byType(CareHistoryEmpty), findsNothing);
    });
  });

  group('CareHistoryScreen month grouping with non-UTC timezone', () {
    testWidgets(
        'should_group_by_LOCAL_month_not_utc_when_instant_crosses_month_boundary',
        (tester) async {
      _tallSurface(tester);

      // Окружение теста заведомо НЕ UTC (Dart берёт TZ процесса; CI/локально
      // здесь +03). Берём смещение как есть и строим UTC-момент, который при
      // переводе в локальную TZ перепрыгивает границу месяца — так тест честно
      // проверяет, что группировка идёт по local-месяцу, не по UTC-месяцу.
      final localOffset = DateTime.now().timeZoneOffset;
      expect(
        localOffset,
        isNot(Duration.zero),
        reason: 'TZ окружения должна быть не-UTC, иначе тест границы бессмыслен '
            '(запусти под TZ=America/Los_Angeles или TZ=Asia/... через env)',
      );

      // Локальная полночь 1-го мая → соответствующий UTC-инстант.
      // При +03 это 2026-04-30T21:00Z: UTC-месяц = апрель, local-месяц = май.
      // При отрицательном смещении строим симметрично у нижней границы месяца.
      final DateTime utcAtMonthBoundary;
      final int expectedLocalMonth;
      final int otherUtcMonth;
      if (localOffset > Duration.zero) {
        // local 2026-05-01 00:30 → UTC раньше → может уехать в апрель.
        final local = DateTime(2026, 5, 1, 0, 30);
        utcAtMonthBoundary = local.toUtc();
        expectedLocalMonth = 5;
        otherUtcMonth = utcAtMonthBoundary.month; // ожидаем 4 при +03
      } else {
        // local 2026-05-31 23:30 → UTC позже → может уехать в июнь.
        final local = DateTime(2026, 5, 31, 23, 30);
        utcAtMonthBoundary = local.toUtc();
        expectedLocalMonth = 5;
        otherUtcMonth = utcAtMonthBoundary.month; // ожидаем 6 при отриц. смещ.
      }

      // Sanity: UTC-месяц инстанта ОТЛИЧАЕТСЯ от локального — иначе тест ничего
      // не доказывает (момент не на границе для данной TZ).
      expect(
        utcAtMonthBoundary.month,
        isNot(expectedLocalMonth),
        reason: 'Инстант должен пересекать границу месяца для текущей TZ '
            '(local=$expectedLocalMonth, utc=$otherUtcMonth)',
      );

      // Вторая запись — заведомо в локальном месяце, отличном от первой
      // (середина июня по локали), чтобы получить ДВЕ месячные группы.
      final secondLocal = DateTime(2026, 6, 15, 12);
      final secondUtc = secondLocal.toUtc();

      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _page(
            items: [
              _entry(2, performedAt: secondUtc), // июнь (local)
              _entry(1, performedAt: utcAtMonthBoundary), // май (local)
            ],
            total: 2,
            offset: 0,
          ),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // Две записи → две месячные группы (июнь и май по ЛОКАЛЬНОЙ TZ).
      // Если бы группировка шла по UTC, граничная запись попала бы в чужой
      // месяц и заголовки/состав групп отличались бы.
      final groups = tester
          .widgetList<CareHistoryMonthGroup>(find.byType(CareHistoryMonthGroup))
          .toList();
      expect(groups, hasLength(2));

      // Месяц граничной записи в её группе считается по local — её сосед
      // в группе отсутствует (она одна в своём local-месяце).
      final boundaryGroup = groups.firstWhere(
        (g) => g.entries.any((e) => e.id == 1),
      );
      expect(
        boundaryGroup.entries.single.id,
        1,
        reason: 'Граничная запись группируется одна по своему ЛОКАЛЬНОМУ месяцу '
            '($expectedLocalMonth), а не по UTC ($otherUtcMonth)',
      );
    });
  });

  group('CareHistoryScreen filter chips', () {
    testWidgets('should_narrow_timeline_when_kind_chip_tapped', (tester) async {
      _tallSurface(tester);
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _page(
            items: [
              _entry(1, kind: CareEventKind.water),
              _entry(2, kind: CareEventKind.spray),
              _entry(3, kind: CareEventKind.water),
            ],
            total: 3,
            offset: 0,
          ),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(CareHistoryTimelineRow), findsNWidgets(3));

      // Тап по чипу «Опрыскано» (1 запись).
      await tester.tap(_chip(_l10n(tester).careDoneSpray));
      await tester.pumpAndSettle();

      // Таймлайн сузился до одной записи типа spray.
      expect(find.byType(CareHistoryTimelineRow), findsOneWidget);
    });

    // Пустой результат под активным фильтром (тип выбран, но среди загруженных
    // записей его нет) → _FilteredEmpty, а НЕ экран 31. Чип с count 0 виден,
    // только пока активен, поэтому такое состояние достижимо в реальном UI
    // лишь после смены набора при сохранённом фильтре — здесь моделируем его
    // напрямую через стаб-контроллер с filter, не совпадающим с данными.
    testWidgets('should_show_filteredEmpty_not_screen31_when_filter_yields_zero',
        (tester) async {
      _tallSurface(tester);
      _stubAux(repo);
      // getHistoryPage не нужен — контроллер застаблен готовым состоянием.

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            careHistoryRepositoryProvider.overrideWithValue(repo),
            careHistoryControllerProvider(_plantId).overrideWith(
              () => _StubController(
                CareHistoryState(
                  // Загружены только water, а активный фильтр — fertilize.
                  entries: [_entry(1, kind: CareEventKind.water)],
                  total: 1,
                  offset: 1,
                  filter: CareEventKind.fertilize,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            home: const CareHistoryScreen(plantId: _plantId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // total != 0 → НЕ экран 31; visibleEntries пуст → _FilteredEmpty.
      expect(find.byType(CareHistoryEmpty), findsNothing);
      expect(find.byType(CareHistoryTimelineRow), findsNothing);
      // _FilteredEmpty показывает текст plantCardJournalEmpty.
      expect(find.text(_l10n(tester).plantCardJournalEmpty), findsOneWidget);
    });
  });

  group('CareHistoryScreen load more', () {
    testWidgets('should_show_loadMore_button_when_hasMore', (tester) async {
      _tallSurface(tester);
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 4, offset: 0),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // hasMore (2 < 4) → кнопка «Показать ещё».
      expect(find.byType(CareHistoryLoadMoreButton), findsOneWidget);
      // Маркер появления растения скрыт, пока есть ещё страницы.
      expect(find.byType(CareHistoryPlantCreatedMarker), findsNothing);
    });

    testWidgets('should_load_next_page_when_loadMore_button_tapped',
        (tester) async {
      _tallSurface(tester);
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 4, offset: 0),
        ),
      );
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(3), _entry(4)], total: 4, offset: 2),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CareHistoryLoadMoreButton));
      await tester.pumpAndSettle();

      // Подгрузилась вторая страница: 4 записи, кнопки больше нет.
      expect(find.byType(CareHistoryTimelineRow), findsNWidgets(4));
      expect(find.byType(CareHistoryLoadMoreButton), findsNothing);
      verify(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .called(1);
    });

    testWidgets('should_show_loadMore_error_and_retry_when_loadMore_fails',
        (tester) async {
      _tallSurface(tester);
      _stubAux(repo);
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 0))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 4, offset: 0),
        ),
      );
      var loadMoreCalls = 0;
      when(() => repo.getHistoryPage(_plantId, limit: 50, offset: 2))
          .thenAnswer((_) async {
        loadMoreCalls++;
        if (loadMoreCalls == 1) {
          return const Result.failure(ApiError.network());
        }
        return Result.success(
          _page(items: [_entry(3), _entry(4)], total: 4, offset: 2),
        );
      });

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CareHistoryLoadMoreButton));
      await tester.pumpAndSettle();

      // Плашка ошибки дозагрузки + список сохранён.
      expect(find.byType(CareHistoryLoadMoreError), findsOneWidget);
      expect(find.byType(CareHistoryTimelineRow), findsNWidgets(2));

      // Retry → успех, список дополнен.
      await tester.tap(find.text(_l10n(tester).retry));
      await tester.pumpAndSettle();

      expect(find.byType(CareHistoryLoadMoreError), findsNothing);
      expect(find.byType(CareHistoryTimelineRow), findsNWidgets(4));
    });
  });

  group('CareHistoryScreen plant-created marker', () {
    testWidgets('should_show_created_marker_when_allLoaded_and_no_filter',
        (tester) async {
      _tallSurface(tester);
      _stubAux(repo, createdAt: DateTime.utc(2026, 1, 10));
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _page(items: [_entry(1), _entry(2)], total: 2, offset: 0),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // !hasMore (2 == 2) и фильтра нет → маркер виден.
      expect(find.byType(CareHistoryPlantCreatedMarker), findsOneWidget);
    });

    testWidgets('should_hide_created_marker_when_filter_active', (tester) async {
      _tallSurface(tester);
      _stubAux(repo, createdAt: DateTime.utc(2026, 1, 10));
      when(() => repo.getHistoryPage(_plantId,
              limit: any(named: 'limit'), offset: any(named: 'offset')))
          .thenAnswer(
        (_) async => Result.success(
          _page(
            items: [
              _entry(1, kind: CareEventKind.water),
              _entry(2, kind: CareEventKind.spray),
            ],
            total: 2,
            offset: 0,
          ),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(CareHistoryPlantCreatedMarker), findsOneWidget);

      // Активируем фильтр → маркер скрывается (filter != null).
      await tester.tap(_chip(_l10n(tester).careDoneWater));
      await tester.pumpAndSettle();

      expect(find.byType(CareHistoryPlantCreatedMarker), findsNothing);
    });
  });
}

/// Стаб контроллера: отдаёт фиксированное состояние, чтобы детерминированно
/// смоделировать активный фильтр без подходящих записей (_FilteredEmpty).
class _StubController extends CareHistoryController {
  _StubController(this._state);

  final CareHistoryState _state;

  @override
  Future<CareHistoryState> build(int plantId) async => _state;
}
