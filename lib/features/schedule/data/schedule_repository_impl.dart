import 'package:dio/dio.dart';

import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/schedule_repository.dart';
import '../domain/schedule_week.dart';
import 'mappers/calendar_mapper.dart';

/// Реализация [ScheduleRepository] поверх сгенерированного клиента (MADR-007).
///
/// Паттерн — как у `HomeRepositoryImpl`: [AuthScope.chat] через `authScopeExtra`
/// (заголовок `X-Chat-Id` ставит `AuthInterceptor`, идентичность тут не
/// хардкодится — см. [_headerOverriddenByInterceptor]); `DioException` →
/// `Result.failure(_toApiError)` (MADR-011), наружу не бросаем.
class ScheduleRepositoryImpl implements ScheduleRepository {
  const ScheduleRepositoryImpl(this._api);

  final PlantsCareApi _api;

  /// Заглушка обязательного `@Header('X-Chat-Id')` сгенерированного клиента:
  /// реальный заголовок перезаписывает `AuthInterceptor` из `AuthSession`,
  /// data-слой идентичность не знает (см. `HomeRepositoryImpl`).
  static const int _headerOverriddenByInterceptor = 0;

  @override
  Future<Result<ScheduleWeek>> getWeek({required DateTime weekStart}) async {
    // Диапазон [from, to] включительно: понедельник .. воскресенье (7 дней).
    // Лимит backend 60 дней не достигается. Передаём date-only локальную
    // полночь; группировка ответа идёт по серверным ключам-датам (см. маппер).
    final from = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final to = DateTime(from.year, from.month, from.day + 6);

    try {
      final response = await _api.calendar.getCalendar(
        xChatId: _headerOverriddenByInterceptor,
        from: from,
        to: to,
        // from/to backend ждёт как date-only; кодген шлёт ISO-8601 с временем
        // → DateQueryInterceptor усекает помеченные ключи. См. BACKEND-GAPS.
        extras: {
          ...authScopeExtra(AuthScope.chat),
          ...dateOnlyQueryExtra({'from', 'to'}),
        },
      );
      return Result.success(response.toScheduleWeek(weekStart: from));
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`; fallback на `unknown`, если там не [ApiError].
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
