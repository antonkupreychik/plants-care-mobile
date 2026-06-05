import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/profile_repository.dart';
import '../domain/profile_summary.dart';
import 'mappers/profile_summary_mapper.dart';

/// Реализация [ProfileRepository] поверх сгенерированного `MeClient`
/// (MADR-007). User-scoped: на каждый запрос проставляет [AuthScope.user] —
/// заголовок подставит `AuthInterceptor` из текущей сессии (MADR-006/008),
/// идентичность здесь НЕ хардкодится.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь разворачивается в `Result.failure` (MADR-011),
/// наружу не бросаем.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<ProfileSummary>> getSummary() async {
    try {
      final me = await _api.me.getMe(extras: authScopeExtra(AuthScope.user));
      return Result.success(me.toProfileSummary());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
