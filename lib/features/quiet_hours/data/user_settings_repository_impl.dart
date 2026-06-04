import 'package:dio/dio.dart';

import '../../../core/api/generated/models/me_update_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/quiet_time.dart';
import '../domain/user_settings.dart';
import '../domain/user_settings_repository.dart';
import 'mappers/user_settings_mapper.dart';

/// Реализация [UserSettingsRepository] поверх сгенерированного `MeClient`
/// (MADR-007). User-scoped: на каждый запрос проставляет [AuthScope.user] через
/// `authScopeExtra` — заголовок `Authorization: Bearer` подставит
/// `AuthInterceptor` из текущей `AuthSession` (MADR-006/008). Идентичность здесь
/// НЕ хардкодится.
///
/// PATCH собирает [MeUpdateRequest] ТОЛЬКО из изменённых полей (остальные —
/// `null`, backend оставляет без изменений). Ошибки dio ловит `ErrorInterceptor`
/// и кладёт [ApiError] в `DioException.error`; здесь это разворачивается в
/// `Result.failure` (MADR-011), наружу не бросаем.
class UserSettingsRepositoryImpl implements UserSettingsRepository {
  const UserSettingsRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<UserSettings>> getSettings() async {
    try {
      final me = await _api.me.getMe(extras: authScopeExtra(AuthScope.user));
      return Result.success(me.toUserSettings());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<UserSettings>> updateQuietHours({
    QuietTime? start,
    QuietTime? end,
  }) async {
    // PATCH: шлём только переданные поля. `null` = «не трогать» (backend
    // сохранит текущее значение).
    final body = MeUpdateRequest(
      quietHoursStart: start?.format(),
      quietHoursEnd: end?.format(),
    );
    return _patch(body);
  }

  @override
  Future<Result<UserSettings>> updateTimezone(String iana) =>
      _patch(MeUpdateRequest(timezone: iana));

  Future<Result<UserSettings>> _patch(MeUpdateRequest body) async {
    try {
      final me = await _api.me.updateMe(
        body: body,
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(me.toUserSettings());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
