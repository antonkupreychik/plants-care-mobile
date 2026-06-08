import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/ui_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/screen_layout.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/core/sdui/data/sdui_repository_impl.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';
import 'package:plantcare_mobile/core/sdui/sdui_catalog_version.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockUiClient extends Mock implements UiClient {}

void main() {
  late _MockApi api;
  late _MockUiClient ui;
  late SduiRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    ui = _MockUiClient();
    when(() => api.ui).thenReturn(ui);
    repo = SduiRepositoryImpl(api);
  });

  void stub(ScreenLayout layout) {
    when(() => ui.getUiScreen(
          screen: any(named: 'screen'),
          xUiCatalogVersion: any(named: 'xUiCatalogVersion'),
          extras: any(named: 'extras'),
        )).thenAnswer((_) async => layout);
  }

  test('parses screenId/version and all four known block types', () async {
    stub(const ScreenLayout(
      screenId: 'home',
      version: 3,
      blocks: [
        {'type': 'weather_strip', 'available': true, 'humidityPercent': 40},
        {
          'type': 'today_summary',
          'total': 4,
          'done': 1,
          'remaining': 3,
          'overdue': 0,
        },
        {
          'type': 'location_chips',
          'locations': [
            {'id': 1, 'name': 'Кухня'},
          ],
        },
        {
          'type': 'plant_grid',
          'plants': [
            {'id': 9, 'name': 'Монстера'},
          ],
        },
      ],
    ));

    final result = await repo.getHomeLayout();

    expect(result, isA<Success>());
    final layout = (result as Success).value;
    expect(layout.screenId, 'home');
    expect(layout.version, 3);
    expect(layout.blocks, hasLength(4));
    expect(layout.blocks[0], isA<SduiWeatherStripBlock>());
    expect(layout.blocks[1], isA<SduiTodaySummaryBlock>());
    expect(layout.blocks[2], isA<SduiLocationChipsBlock>());
    expect(layout.blocks[3], isA<SduiPlantGridBlock>());
  });

  test('graceful degradation: unknown block type is skipped, others survive',
      () async {
    stub(const ScreenLayout(
      screenId: 'home',
      version: 1,
      blocks: [
        {
          'type': 'today_summary',
          'total': 2,
          'done': 0,
          'remaining': 2,
          'overdue': 0,
        },
        // Тип из будущей версии каталога — клиент его не знает.
        {'type': 'super_future_block', 'payload': 'whatever'},
        {
          'type': 'plant_grid',
          'plants': [
            {'id': 1, 'name': 'X'},
          ],
        },
      ],
    ));

    final result = await repo.getHomeLayout();

    final layout = (result as Success).value;
    // Неизвестный блок выпал — остались только два известных, по порядку.
    expect(layout.blocks, hasLength(2));
    expect(layout.blocks[0], isA<SduiTodaySummaryBlock>());
    expect(layout.blocks[1], isA<SduiPlantGridBlock>());
  });

  test('empty blocks yields empty layout, not error', () async {
    stub(const ScreenLayout(screenId: 'home', version: 1, blocks: []));

    final layout = ((await repo.getHomeLayout()) as Success).value;
    expect(layout.blocks, isEmpty);
  });

  test('sends home screen, catalog version and chat auth scope', () async {
    stub(const ScreenLayout(screenId: 'home', version: 1, blocks: []));

    await repo.getHomeLayout();

    final captured = verify(() => ui.getUiScreen(
          screen: captureAny(named: 'screen'),
          xUiCatalogVersion: captureAny(named: 'xUiCatalogVersion'),
          extras: captureAny(named: 'extras'),
        )).captured;
    expect(captured[0], 'home');
    expect(captured[1], kUiCatalogVersion);
    expect(
      (captured[2] as Map)[kAuthScopeExtraKey],
      AuthScope.chat,
    );
  });

  test('dio error is mapped to Result.failure (ApiError), not thrown',
      () async {
    when(() => ui.getUiScreen(
          screen: any(named: 'screen'),
          xUiCatalogVersion: any(named: 'xUiCatalogVersion'),
          extras: any(named: 'extras'),
        )).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/api/v1/ui/home'),
      error: const ApiError.network(),
    ));

    final result = await repo.getHomeLayout();
    expect(result, isA<Failure>());
    expect((result as Failure).error, isA<NetworkError>());
  });
}
