import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plant_history_client.dart';
import 'package:plantcare_mobile/core/api/generated/clients/plants_client.dart';
import 'package:plantcare_mobile/core/api/generated/clients/stats_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/care_event_type.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/plant_history_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/streak_response.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/care_history/data/care_history_repository_impl.dart';
import 'package:plantcare_mobile/features/care_history/data/care_history_repository_provider.dart';
import 'package:plantcare_mobile/features/care_history/presentation/care_history_screen.dart';
import 'package:plantcare_mobile/features/care_history/presentation/widgets/care_history_filter_chips.dart';
import 'package:plantcare_mobile/features/care_history/presentation/widgets/care_history_load_more.dart';
import 'package:plantcare_mobile/features/care_history/presentation/widgets/care_history_timeline.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockPlantsClient extends Mock implements PlantsClient {}

class _MockPlantHistoryClient extends Mock implements PlantHistoryClient {}

class _MockStatsClient extends Mock implements StatsClient {}

const _plantId = 42;

CareEventResponse _ev(int id, CareEventType type) => CareEventResponse(
      id: id,
      plantId: _plantId,
      plantName: 'Фикус',
      type: type,
      performedAt: DateTime.utc(2026, 5, 1, 8),
      onTime: true,
    );

PlantHistoryResponse _resp(
  List<CareEventResponse> items, {
  required int total,
  required int offset,
}) =>
    PlantHistoryResponse(items: items, total: total, limit: 50, offset: offset);

void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 4200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(CareHistoryScreen)));

Finder _chip(String label) => find.descendant(
      of: find.byType(CareHistoryFilterChips),
      matching: find.text(label),
    );

void main() {
  late _MockApi api;
  late _MockPlantsClient plants;
  late _MockPlantHistoryClient history;
  late _MockStatsClient stats;

  setUp(() {
    api = _MockApi();
    plants = _MockPlantsClient();
    history = _MockPlantHistoryClient();
    stats = _MockStatsClient();
    when(() => api.plants).thenReturn(plants);
    when(() => api.plantHistory).thenReturn(history);
    when(() => api.stats).thenReturn(stats);

    // Деталь и стрик — общие стабы для всех тестов флоу.
    when(() => plants.getPlant(
          xUserId: any(named: 'xUserId'),
          id: any(named: 'id'),
          extras: any(named: 'extras'),
        )).thenAnswer(
      (_) async => PlantDto(
        id: _plantId,
        name: 'Фикус',
        archived: false,
        speciesName: 'Ficus',
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    when(() => stats.getPlantStreak(
          xChatId: any(named: 'xChatId'),
          plantId: any(named: 'plantId'),
          extras: any(named: 'extras'),
        )).thenAnswer(
      (_) async => const StreakResponse(plantId: _plantId, streak: 2),
    );
  });

  /// Реальный repo поверх мок-API — экран ходит через настоящий контроллер и
  /// маппер, как в проде. Это полноценный флоу, не подмена логики.
  Widget app() => ProviderScope(
        overrides: [
          careHistoryRepositoryProvider
              .overrideWithValue(CareHistoryRepositoryImpl(api)),
        ],
        child: MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          home: const CareHistoryScreen(plantId: _plantId),
        ),
      );

  testWidgets(
      'should_open_show_data_loadMore_then_filter_through_two_pages_flow',
      (tester) async {
    _tallSurface(tester);

    // Страница 1 (offset 0): два water. Страница 2 (offset 2): fertilize + water.
    when(() => history.getPlantHistory(
          xChatId: any(named: 'xChatId'),
          id: _plantId,
          limit: any(named: 'limit'),
          offset: 0,
          extras: any(named: 'extras'),
        )).thenAnswer(
      (_) async => _resp(
        [_ev(1, CareEventType.water), _ev(2, CareEventType.water)],
        total: 4,
        offset: 0,
      ),
    );
    when(() => history.getPlantHistory(
          xChatId: any(named: 'xChatId'),
          id: _plantId,
          limit: any(named: 'limit'),
          offset: 2,
          extras: any(named: 'extras'),
        )).thenAnswer(
      (_) async => _resp(
        [_ev(3, CareEventType.fertilize), _ev(4, CareEventType.water)],
        total: 4,
        offset: 2,
      ),
    );

    // 1. Открытие → первая страница.
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.byType(CareHistoryTimelineRow), findsNWidgets(2));
    expect(find.byType(CareHistoryLoadMoreButton), findsOneWidget);

    // 2. Load-more → вторая страница аппендится, кнопки больше нет.
    await tester.tap(find.byType(CareHistoryLoadMoreButton));
    await tester.pumpAndSettle();
    expect(find.byType(CareHistoryTimelineRow), findsNWidgets(4));
    expect(find.byType(CareHistoryLoadMoreButton), findsNothing);

    // 3. Фильтр по fertilize (только со 2-й страницы) → 1 запись.
    await tester.tap(_chip(_l10n(tester).careDoneFertilize));
    await tester.pumpAndSettle();
    expect(find.byType(CareHistoryTimelineRow), findsOneWidget);

    // Auth-слот: обе страницы истории ушли со scope chat (extras), а деталь
    // растения — со scope user. Идентичность не хардкодится в data-слое;
    // ловит молчаливую регрессию при подключении реального auth.
    final histExtras = verify(() => history.getPlantHistory(
          xChatId: any(named: 'xChatId'),
          id: any(named: 'id'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: captureAny(named: 'extras'),
        )).captured.cast<Map<String, dynamic>>();
    expect(histExtras, isNotEmpty);
    expect(
      histExtras.every((e) => e[kAuthScopeExtraKey] == AuthScope.chat),
      isTrue,
    );

    final plantExtras = verify(() => plants.getPlant(
          xUserId: any(named: 'xUserId'),
          id: any(named: 'id'),
          extras: captureAny(named: 'extras'),
        )).captured.single as Map<String, dynamic>;
    expect(plantExtras[kAuthScopeExtraKey], AuthScope.user);
  });

  testWidgets('should_show_error_with_retry_when_network_fails_offline',
      (tester) async {
    // Offline: интерсептор завернул сетевую ошибку в ApiError.network внутри
    // DioException — repo вернёт failure, контроллер уйдёт в AsyncError.
    when(() => history.getPlantHistory(
          xChatId: any(named: 'xChatId'),
          id: any(named: 'id'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          extras: any(named: 'extras'),
        )).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/plants/$_plantId/history'),
        error: const ApiError.network(),
      ),
    );

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // Экран ошибки с retry — не пустой, не повисший.
    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text(_l10n(tester).retry), findsOneWidget);
  });
}
