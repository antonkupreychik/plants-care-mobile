import 'package:dio/dio.dart';

import '../../../core/api/generated/models/status.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/archive_repository.dart';
import '../domain/archive_view.dart';
import '../domain/archived_plant.dart';
import 'archived_plant_mapper.dart';

/// Реализация [ArchiveRepository] поверх сгенерированного API-клиента (MADR-007).
///
/// Запрашивает `GET /api/v1/plants?status=archived` с постраничной загрузкой
/// всего списка (до 100 записей за раз, лимит API). Для экрана архива (мемориала)
/// все записи загружаются в один список — частичная подгрузка не нужна, поскольку
/// архив пользователя невелик.
///
/// `AuthScope.user` проставляется через `authScopeExtra` (MADR-006/008).
/// Ошибки dio ловит `ErrorInterceptor` → `DioException.error` содержит [ApiError],
/// здесь разворачивается в `Result.failure` (MADR-011), наружу не бросаем.
class ArchiveRepositoryImpl implements ArchiveRepository {
  const ArchiveRepositoryImpl(this._api);

  final PlantsCareApi _api;

  static const int _pageLimit = 100;

  @override
  Future<Result<ArchiveView>> getArchive() async {
    try {
      final page = await _api.plants.listPlants(
        status: Status.archived,
        offset: 0,
        limit: _pageLimit,
        extras: authScopeExtra(AuthScope.user),
      );

      final plants = page.items
          .map((dto) => dto.toDomain())
          .toList(growable: false);

      final view = ArchiveView(
        plants: plants,
        retrospective: plants.isNotEmpty
            ? _buildRetrospective(plants)
            : null,
      );

      return Result.success(view);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// Собирает [ArchiveRetrospective] из списка архивных растений.
  ///
  /// Среднее время жизни считается по [ArchivedPlant.livedLabel] нет —
  /// там уже строки. Строим из исходных данных: маппер отработал, строки
  /// уже в domain-модели. Ретроспектива показывает общее количество растений
  /// в архиве; детальная статистика — в roadmap.
  ///
  /// Сейчас возвращаем лейбл с количеством; если бэкенд добавит
  /// среднее — маппинг обновится здесь, domain не меняется.
  ArchiveRetrospective _buildRetrospective(List<ArchivedPlant> plants) {
    // Среднее строим из totalCareDays через items, но у нас уже domain-
    // модели без этого поля. Лейбл: показываем число растений.
    // TODO(#149): когда backend вернёт avgCareDays — использовать его.
    final count = plants.length;
    final label = '$count ${_pluralPlants(count)} в архиве';
    return ArchiveRetrospective(averageLivedLabel: label);
  }

  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}

String _pluralPlants(int n) {
  final mod10 = n % 10;
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 14) return 'растений';
  if (mod10 == 1) return 'растение';
  if (mod10 >= 2 && mod10 <= 4) return 'растения';
  return 'растений';
}
