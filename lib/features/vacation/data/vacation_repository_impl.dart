import 'package:dio/dio.dart';

import '../../../core/api/generated/models/vacation_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/vacation_range.dart';
import '../domain/vacation_status.dart';
import '../domain/vacation_repository.dart';
import 'mappers/vacation_mapper.dart';

/// Реализация [VacationRepository] поверх сгенерированного `VacationClient`
/// (MADR-007). User-scoped: на каждый запрос — [AuthScope.user] через
/// `authScopeExtra`; заголовок `Authorization: Bearer` подставит
/// `AuthInterceptor` из текущей `AuthSession` (MADR-006/008). Идентичность тут
/// НЕ хардкодится.
///
/// Дата-поля `from`/`to` тела `POST` спека объявляет как `format: date`, но
/// кодген сериализует `DateTime` через `toIso8601String()` (`...T00:00:00.000`),
/// а backend ждёт `YYYY-MM-DD`. Помечаем поля тела через [dateOnlyBodyExtra] —
/// `DateQueryInterceptor` усечёт их до date-only (тот же воркэраунд, что у
/// `/calendar` query, см. docs/BACKEND-GAPS.md).
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в `DioException.error`;
/// здесь это разворачивается в `Result.failure` (MADR-011), наружу не бросаем.
class VacationRepositoryImpl implements VacationRepository {
  const VacationRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<VacationStatus>> getStatus() async {
    try {
      final response = await _api.vacation.getVacation(
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(response.toVacationStatus());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<VacationStatus>> start(VacationRange range) async {
    try {
      final response = await _api.vacation.startVacation(
        body: VacationRequest(from: range.from, to: range.to),
        extras: {
          ...authScopeExtra(AuthScope.user),
          // `from`/`to` уйдут как `YYYY-MM-DD`, а не ISO-datetime (см. класс-док).
          ...dateOnlyBodyExtra({'from', 'to'}),
        },
      );
      return Result.success(response.toVacationStatus());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<VacationStatus>> end() async {
    try {
      await _api.vacation.endVacation(extras: authScopeExtra(AuthScope.user));
      // DELETE отдаёт 204 без тела; локально фиксируем неактивный статус
      // (backend идемпотентен — повторный вызов тоже 204).
      return Result.success(VacationStatus.inactive);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
