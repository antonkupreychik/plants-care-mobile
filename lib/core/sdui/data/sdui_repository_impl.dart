import 'package:dio/dio.dart';

import '../../api/generated/plants_care_api.dart';
import '../../error/api_error.dart';
import '../../error/result.dart';
import '../../network/auth_scope.dart';
import '../../network/request_extra.dart';
import '../domain/sdui_block.dart';
import '../domain/sdui_repository.dart';
import '../domain/sdui_screen_layout.dart';
import '../sdui_catalog_version.dart';
import 'sdui_block_mapper.dart';

/// Реализация [SduiRepository] (MADR-015) поверх сгенерированного API-клиента
/// (MADR-007).
///
/// Контракт `GET /api/v1/ui/{screen}` ОПАКОВЫЙ: backend не типизирует блоки,
/// `ScreenLayout.blocks` приходит как `List<dynamic>` свободных JSON-объектов.
/// Разбор делает [sduiBlockFromJson] поэлементно — блок с неизвестным/битым
/// `type` даёт `null` и тихо выпадает (graceful degradation,
/// forward-compatibility), остальные рисуются.
///
/// Scope `chat` (как `/today`) → `Authorization: Bearer` подставит
/// `AuthInterceptor` из текущей `AuthSession` (MADR-006/008). Заголовок
/// `X-UI-Catalog-Version` = [kUiCatalogVersion] (FLUTTER.md / MADR-015).
///
/// Ошибки dio ловит `ErrorInterceptor` (кладёт [ApiError] в `DioException.error`);
/// здесь разворачивается в `Result.failure` (MADR-011), наружу не бросаем.
class SduiRepositoryImpl implements SduiRepository {
  const SduiRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Идентификатор home-экрана для path-параметра `{screen}`.
  static const String _homeScreen = 'home';

  @override
  Future<Result<SduiScreenLayout>> getHomeLayout() async {
    try {
      final layout = await _api.ui.getUiScreen(
        screen: _homeScreen,
        xUiCatalogVersion: kUiCatalogVersion,
        extras: authScopeExtra(AuthScope.chat),
      );
      return Result.success(
        SduiScreenLayout(
          screenId: layout.screenId,
          version: layout.version,
          blocks: _parseBlocks(layout.blocks),
        ),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// Поэлементный разбор опаковых `blocks` с graceful degradation: блок иной
  /// формы или с неизвестным `type` ([sduiBlockFromJson] → `null`) выпадает из
  /// результата — экран рисует остальные.
  List<SduiBlock> _parseBlocks(List<dynamic> raw) {
    final result = <SduiBlock>[];
    for (final entry in raw) {
      if (entry is! Map) continue;
      final block = sduiBlockFromJson(Map<String, Object?>.from(entry));
      if (block != null) result.add(block);
    }
    return result;
  }

  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
