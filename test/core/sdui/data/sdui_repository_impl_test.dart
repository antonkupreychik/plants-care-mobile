import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/sdui/data/sdui_repository_impl.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';

class _MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _ok(Map<String, dynamic> body) => Response(
      requestOptions: RequestOptions(path: '/api/v1/ui/home'),
      data: body,
      statusCode: 200,
    );

void main() {
  late _MockDio dio;
  late SduiRepositoryImpl repo;

  setUp(() {
    dio = _MockDio();
    repo = SduiRepositoryImpl(dio);
  });

  void stub(Map<String, dynamic> body) {
    when(() => dio.get<Map<String, dynamic>>(
          any(),
          options: any(named: 'options'),
        )).thenAnswer((_) async => _ok(body));
  }

  test('parses screenId/version and all four known block types', () async {
    stub({
      'screenId': 'home',
      'version': 3,
      'blocks': [
        {'type': 'weather_strip', 'available': true, 'humidityPercent': 40},
        {'type': 'today_summary', 'total': 4, 'done': 1, 'remaining': 3, 'overdue': 0},
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
    });

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
    stub({
      'screenId': 'home',
      'version': 1,
      'blocks': [
        {'type': 'today_summary', 'total': 2, 'done': 0, 'remaining': 2, 'overdue': 0},
        // Тип из будущей версии каталога — клиент его не знает.
        {'type': 'super_future_block', 'payload': 'whatever'},
        {
          'type': 'plant_grid',
          'plants': [
            {'id': 1, 'name': 'X'},
          ],
        },
      ],
    });

    final result = await repo.getHomeLayout();

    final layout = (result as Success).value;
    // Неизвестный блок выпал — остались только два известных, по порядку.
    expect(layout.blocks, hasLength(2));
    expect(layout.blocks[0], isA<SduiTodaySummaryBlock>());
    expect(layout.blocks[1], isA<SduiPlantGridBlock>());
  });

  test('empty/absent blocks yields empty layout, not error', () async {
    stub({'screenId': 'home', 'version': 1});

    final layout = ((await repo.getHomeLayout()) as Success).value;
    expect(layout.blocks, isEmpty);
  });

  test('dio error is mapped to Result.failure (ApiError), not thrown',
      () async {
    when(() => dio.get<Map<String, dynamic>>(
          any(),
          options: any(named: 'options'),
        )).thenThrow(DioException(
      requestOptions: RequestOptions(path: '/api/v1/ui/home'),
      error: const ApiError.network(),
    ));

    final result = await repo.getHomeLayout();
    expect(result, isA<Failure>());
    expect((result as Failure).error, isA<NetworkError>());
  });
}
