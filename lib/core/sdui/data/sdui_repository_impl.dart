import 'package:dio/dio.dart';

import '../../api/generated/models/block.dart';
import '../../error/api_error.dart';
import '../../error/result.dart';
import '../../network/auth_scope.dart';
import '../../network/request_extra.dart';
import '../domain/sdui_block.dart';
import '../domain/sdui_repository.dart';
import '../domain/sdui_screen_layout.dart';
import '../sdui_catalog_version.dart';
import 'sdui_block_mapper.dart';

/// Реализация [SduiRepository] (MADR-015).
///
/// Намеренно ходит в backend «голым» [Dio] (`GET /api/v1/ui/home`), а не через
/// сгенерированный `UiClient.getHomeScreen`: типизированный `ScreenLayout.fromJson`
/// зовёт `Block.fromJson`, который на НЕИЗВЕСТНОМ дискриминаторе бросает
/// `FormatException` и роняет разбор ВСЕГО лейаута. Нам же нужна graceful
/// degradation: неизвестный блок — пропустить, остальные отрисовать. Поэтому
/// блоки разбираем поэлементно с try/catch (см. [_parseBlocks]).
///
/// Scope `chat` (как `/today`) → `Authorization: Bearer` подставит
/// `AuthInterceptor` из текущей `AuthSession` (MADR-006/008). Заголовок
/// `X-UI-Catalog-Version` = [kUiCatalogVersion] (FLUTTER.md / MADR-015).
///
/// Ошибки dio ловит `ErrorInterceptor` (кладёт [ApiError] в `DioException.error`);
/// здесь разворачивается в `Result.failure` (MADR-011), наружу не бросаем.
class SduiRepositoryImpl implements SduiRepository {
  const SduiRepositoryImpl(this._dio);

  final Dio _dio;

  static const String _homePath = '/api/v1/ui/home';

  @override
  Future<Result<SduiScreenLayout>> getHomeLayout() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _homePath,
        options: withAuthScope(AuthScope.chat).copyWith(
          headers: <String, dynamic>{'X-UI-Catalog-Version': kUiCatalogVersion},
        ),
      );
      final json = response.data ?? const <String, dynamic>{};
      return Result.success(
        SduiScreenLayout(
          screenId: (json['screenId'] as String?) ?? 'home',
          version: (json['version'] as num?)?.toInt() ?? 0,
          blocks: _parseBlocks(json['blocks']),
        ),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// Поэлементный разбор `blocks` с graceful degradation: блок с неизвестным
  /// `type` (его `Block.fromJson` бросает `FormatException`) или замапленный в
  /// [SduiUnknownBlock] выпадает из результата — экран рисует остальные.
  List<SduiBlock> _parseBlocks(Object? raw) {
    if (raw is! List) return const <SduiBlock>[];
    final result = <SduiBlock>[];
    for (final entry in raw) {
      if (entry is! Map<String, dynamic>) continue;
      try {
        final domain = Block.fromJson(entry).toDomain();
        // Защитно отбрасываем нераспознанный домен-блок (на будущее, если
        // кодген начнёт отдавать новый sealed-подтип) — рендерить нечего.
        if (domain is SduiUnknownBlock) continue;
        result.add(domain);
      } on Object {
        // Неизвестный дискриминатор / битый блок — тихо пропускаем.
        continue;
      }
    }
    return result;
  }

  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
