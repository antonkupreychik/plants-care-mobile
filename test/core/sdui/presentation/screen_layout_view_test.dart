import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/care/care_task.dart';
import 'package:plantcare_mobile/core/care/care_task_type.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_action.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_screen_layout.dart';
import 'package:plantcare_mobile/core/sdui/presentation/home_room_filter.dart';
import 'package:plantcare_mobile/core/sdui/presentation/screen_layout_view.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/care_event/data/care_event_repository_provider.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_draft.dart';
import 'package:plantcare_mobile/features/care_event/domain/care_event_repository.dart';
import 'package:plantcare_mobile/features/care_event/domain/logged_care_event.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/guest_banner.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/location_chips.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/plant_card.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_event_kind.dart';
import 'package:plantcare_mobile/features/weather/domain/watering_recommendation.dart';
import 'package:plantcare_mobile/features/weather/presentation/widgets/weather_strip.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockCareRepo extends Mock implements CareEventRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

Widget _wrap(SduiScreenLayout layout, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(
        body: SingleChildScrollView(child: ScreenLayoutView(layout: layout)),
      ),
    ),
  );
}

SduiScreenLayout _layout(List<SduiBlock> blocks) =>
    SduiScreenLayout(screenId: 'home', version: 1, blocks: blocks);

void main() {
  group('ScreenLayoutView renders each block type', () {
    testWidgets('weather_strip renders WeatherStripContent', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.weatherStrip(
          available: true,
          humidityPercent: 60,
          recommendation: WateringRecommendation.doNotDefer,
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherStripContent), findsOneWidget);
    });

    testWidgets('unavailable weather_strip renders nothing', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.weatherStrip(available: false),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherStripContent), findsNothing);
    });

    testWidgets('today_summary renders TodayCard', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.todaySummary(total: 5, done: 2, remaining: 3, overdue: 1),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(TodayCard), findsOneWidget);
    });

    testWidgets('today_tasks renders TodayCard with the task', (tester) async {
      await tester.pumpWidget(_wrap(_layout([
        SduiBlock.todayTasks(
          completedCount: 1,
          totalCount: 3,
          tasks: [
            CareTask(
              scheduleId: 1,
              plantId: 42,
              plantName: 'Фикус',
              type: CareTaskType.fertilizing,
              dueAt: DateTime.utc(2026, 5, 27, 9),
            ),
          ],
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(TodayCard), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(TodayCard),
          matching: find.text('Фикус'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('location_chips renders LocationChips', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.locationChips(
          locations: [
            SduiLocationChip(
              location: GardenLocation(id: 1, name: 'Кухня', isDefault: false),
              count: 2,
            ),
          ],
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(LocationChips), findsOneWidget);
      expect(find.text('Кухня'), findsOneWidget);
    });

    testWidgets('plant_grid renders PlantCard per item', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.plantGrid(
          plants: [
            SduiPlantGridItem(id: 1, name: 'Монстера'),
            SduiPlantGridItem(id: 2, name: 'Кактус'),
          ],
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(PlantCard), findsNWidgets(2));
      expect(find.text('Монстера'), findsOneWidget);
      expect(find.text('Кактус'), findsOneWidget);
    });

    testWidgets('renders multiple blocks in order', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.todaySummary(total: 1, done: 0, remaining: 1, overdue: 0),
        SduiBlock.plantGrid(plants: [SduiPlantGridItem(id: 1, name: 'X')]),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(TodayCard), findsOneWidget);
      expect(find.byType(PlantCard), findsOneWidget);
    });
  });

  group('plant_grid water button (MADR-017)', () {
    setUpAll(() {
      registerFallbackValue(
        CareEventDraft(
          plantId: 0,
          type: CareEventKind.water,
          performedAtUtc: DateTime.utc(2020),
        ),
      );
    });

    testWidgets('item without waterAction renders no water button',
        (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.plantGrid(plants: [SduiPlantGridItem(id: 1, name: 'X')]),
      ])));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.water_drop_outlined), findsNothing);
    });

    testWidgets('tapping water button runs log_care via care repo',
        (tester) async {
      final careRepo = _MockCareRepo();
      CareEventDraft? captured;
      when(() => careRepo.logCareEvent(any())).thenAnswer((inv) async {
        captured = inv.positionalArguments.first as CareEventDraft;
        return Result.success(
          LoggedCareEvent(
            id: 1,
            plantId: 10,
            plantName: 'Монстера',
            type: CareEventKind.water,
            performedAtUtc: DateTime.utc(2026, 5, 27, 9),
            onTime: true,
            clientId: captured!.clientId,
          ),
        );
      });

      await tester.pumpWidget(_wrap(
        _layout(const [
          SduiBlock.plantGrid(
            plants: [
              SduiPlantGridItem(
                id: 10,
                name: 'Монстера',
                waterAction: SduiAction(
                  kind: SduiActionKind.logCare,
                  method: 'POST',
                  path: '/care-events',
                  payload: {'plantId': 10, 'type': 'WATER'},
                  invalidates: ['home', 'today'],
                ),
              ),
            ],
          ),
        ]),
        overrides: [
          clockProvider.overrideWithValue(
            _FixedClock(DateTime.utc(2026, 5, 27, 9)),
          ),
          careEventRepositoryProvider.overrideWithValue(careRepo),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.water_drop_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.water_drop_outlined));
      await tester.pumpAndSettle();

      verify(() => careRepo.logCareEvent(any())).called(1);
      expect(captured!.plantId, 10);
      expect(captured!.type, CareEventKind.water);
    });
  });

  group('guest_banner / empty_state blocks (MADR-017)', () {
    testWidgets('guest_banner renders GuestBannerCard with resolved text',
        (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.guestBanner(
          titleKey: 'home.guest.title',
          bodyKey: 'home.guest.body',
          ctaAction: SduiAction(
            kind: SduiActionKind.navigate,
            target: '/home/register',
          ),
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(GuestBannerCard), findsOneWidget);
      final l10n = AppLocalizations.of(
        tester.element(find.byType(GuestBannerCard)),
      );
      expect(find.text(l10n.sduiHomeGuestTitle), findsOneWidget);
    });

    testWidgets('empty_state renders title/body + CTA', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.emptyState(
          iconKey: 'home.empty.icon',
          titleKey: 'home.empty.title',
          bodyKey: 'home.empty.body',
          ctaAction: SduiAction(
            kind: SduiActionKind.navigate,
            target: '/home/add',
          ),
        ),
      ])));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(
        tester.element(find.byType(ScreenLayoutView)),
      );
      expect(find.text(l10n.sduiHomeEmptyTitle), findsOneWidget);
      expect(find.text(l10n.sduiHomeEmptyBody), findsOneWidget);
      expect(find.text(l10n.homeAddPlant), findsOneWidget);
    });
  });

  group('location_chips room filter (MADR-016/017)', () {
    Widget wrapWithContainer(ProviderContainer container, SduiScreenLayout l) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: Scaffold(
            body: SingleChildScrollView(child: ScreenLayoutView(layout: l)),
          ),
        ),
      );
    }

    testWidgets('tapping a room chip requests that locationId', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Держим провайдер живым (autoDispose сбросил бы state между ридами).
      container.listen(homeRoomFilterProvider, (_, _) {}, fireImmediately: true);

      await tester.pumpWidget(wrapWithContainer(
        container,
        _layout(const [
          SduiBlock.locationChips(
            selectedLocationId: null,
            totalCount: 5,
            locations: [
              SduiLocationChip(
                location: GardenLocation(id: 7, name: 'Кухня', isDefault: false),
                count: 3,
              ),
            ],
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      // До тапа фильтр пуст («Все»).
      expect(container.read(homeRoomFilterProvider), isNull);

      await tester.tap(find.text('Кухня'));
      await tester.pump();

      // Тап по комнате → запрошен её locationId (перезапрос делает провайдер).
      expect(container.read(homeRoomFilterProvider), 7);
    });

    testWidgets('re-tapping the selected chip resets filter to null',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(homeRoomFilterProvider, (_, _) {}, fireImmediately: true);
      // Стартуем из состояния «запрошена комната 7» (как после первого тапа).
      container.read(homeRoomFilterProvider.notifier).select(7);

      await tester.pumpWidget(wrapWithContainer(
        container,
        _layout(const [
          SduiBlock.locationChips(
            // Сервер уже отфильтровал по комнате 7 (single source of truth).
            selectedLocationId: 7,
            totalCount: 3,
            locations: [
              SduiLocationChip(
                location: GardenLocation(id: 7, name: 'Кухня', isDefault: false),
                count: 3,
              ),
            ],
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      // Повторный тап по уже выбранной комнате → сброс на «Все» (null).
      await tester.tap(find.text('Кухня'));
      await tester.pump();
      expect(container.read(homeRoomFilterProvider), isNull);
    });

    testWidgets('tapping «Все» resets filter to null', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(homeRoomFilterProvider, (_, _) {}, fireImmediately: true);
      container.read(homeRoomFilterProvider.notifier).select(7);

      await tester.pumpWidget(wrapWithContainer(
        container,
        _layout(const [
          SduiBlock.locationChips(
            selectedLocationId: 7,
            totalCount: 3,
            locations: [
              SduiLocationChip(
                location: GardenLocation(id: 7, name: 'Кухня', isDefault: false),
                count: 3,
              ),
            ],
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(LocationChips)));
      await tester.tap(find.text(l10n.homeLocationAll));
      await tester.pump();
      expect(container.read(homeRoomFilterProvider), isNull);
    });

    testWidgets('selected chip is highlighted by server selectedLocationId',
        (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.locationChips(
          selectedLocationId: 7,
          totalCount: 3,
          locations: [
            SduiLocationChip(
              location: GardenLocation(id: 7, name: 'Кухня', isDefault: false),
              count: 3,
            ),
          ],
        ),
      ])));
      await tester.pumpAndSettle();

      // LocationChips подсвечивает чип по selectedLocationId (передан вниз).
      final chips = tester.widget<LocationChips>(find.byType(LocationChips));
      expect(chips.selectedLocationId, 7);
    });

    testWidgets('empty room renders contextual empty state, not a grid',
        (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.plantGrid(
          plants: [],
          emptyTitleKey: 'home.room.empty.title',
          emptyBodyKey: 'home.room.empty.body',
        ),
      ])));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(ScreenLayoutView)));
      expect(find.text(l10n.sduiHomeRoomEmptyTitle), findsOneWidget);
      expect(find.text(l10n.sduiHomeRoomEmptyBody), findsOneWidget);
      expect(find.byType(PlantCard), findsNothing);
    });
  });

  group('graceful degradation', () {
    testWidgets('unknown block renders nothing and does not throw',
        (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.todaySummary(total: 1, done: 0, remaining: 1, overdue: 0),
        SduiBlock.unknown(),
        SduiBlock.plantGrid(plants: [SduiPlantGridItem(id: 1, name: 'X')]),
      ])));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Известные блоки отрисованы, неизвестный — пропущен (ничего не рисует).
      expect(find.byType(TodayCard), findsOneWidget);
      expect(find.byType(PlantCard), findsOneWidget);
    });
  });
}
