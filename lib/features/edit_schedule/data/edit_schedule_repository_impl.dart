import 'package:dio/dio.dart';

import '../../../core/api/generated/models/type.dart' as sched;
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/edit_schedule_repository.dart';
import '../domain/plant_care_schedule.dart';
import 'mappers/care_schedule_mapper.dart';

/// Реализация [EditScheduleRepository] поверх сгенерированного API-клиента
/// (MADR-007). User-scoped: на запрос проставляет [AuthScope.user] через
/// `authScopeExtra` — заголовок `Authorization` подставит `AuthInterceptor` из
/// текущей `AuthSession` (MADR-006/008). Идентичность здесь НЕ хардкодится:
/// см. `AuthInterceptor`.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class EditScheduleRepositoryImpl implements EditScheduleRepository {
  const EditScheduleRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<List<PlantCareSchedule>>> getSchedules(int plantId) async {
    try {
      final dtos = await _api.schedules.listPlantSchedules(
        id: plantId,
        extras: authScopeExtra(AuthScope.user),
      );
      final schedules =
          dtos.map((dto) => dto.toDomain()).toList(growable: false);
      return Result.success(schedules);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<PlantCareSchedule>> updateSchedule(
    int plantId,
    PlantCareSchedule schedule,
  ) async {
    try {
      final dto = await _api.schedules.updatePlantSchedule(
        id: plantId,
        // Path-параметр `{type}` кодген отдал как enum `Type`; восстанавливаем
        // из исходной backend-строки расписания.
        type: sched.Type.fromJson(schedule.rawType),
        body: schedule.toUpdateRequest(),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
