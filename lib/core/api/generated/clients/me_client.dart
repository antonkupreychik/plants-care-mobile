// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/me_response.dart';
import '../models/me_update_request.dart';
import '../models/season.dart';
import '../models/seasonal_settings_response.dart';
import '../models/seasonal_settings_update_request.dart';
import '../models/weather_location_request.dart';

part 'me_client.g.dart';

@RestApi()
abstract class MeClient {
  factory MeClient(Dio dio, {String? baseUrl}) = _MeClient;

  /// Профиль и настройки пользователя.
  ///
  /// Возвращает профиль текущего пользователя: имя, аватар, счётчики для.
  /// хедера (растения, задачи на сегодня, непрочитанные уведомления) и.
  /// настройки (тихие часы, таймзона, язык).
  ///
  /// `tasksToday` считается в **таймзоне пользователя** (`users.timezone`) —.
  /// число **невыполненных** (pending) задач ухода, дедлайн которых наступает.
  /// до конца сегодняшнего дня. Уже отмеченные сегодня задачи не учитываются.
  @GET('/api/v1/me')
  Future<MeResponse> getMe({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Удаление аккаунта (GDPR / App Store).
  ///
  /// Необратимо удаляет аккаунт текущего пользователя и все связанные данные.
  /// (растения, расписания, история ухода, локации, список покупок и т.д.) через.
  /// FK `ON DELETE CASCADE` на уровне БД.
  ///
  /// **Поведение Telegram-связки**: поле `telegram_chat_id` удаляется вместе.
  /// со строкой пользователя. При следующем `/start` в боте для того же.
  /// chat\_id создаётся **новый** пользователь с нуля — история не восстанавливается.
  ///
  /// **Идемпотентность**: повторный вызов с токеном удалённого пользователя.
  /// вернёт `204` (tolerant-delete), а не `500` или `404`.
  ///
  /// Операция необратима. Требует действующего Bearer-токена.
  @DELETE('/api/v1/me')
  Future<void> deleteMe({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Частичное обновление настроек пользователя.
  ///
  /// PATCH-семантика: обновляются только переданные поля, остальные остаются.
  /// без изменений. Имя и аватар через этот эндпоинт не меняются.
  ///
  /// Смена `timezone` пересчитывает активные расписания так, чтобы локальное.
  /// время дня сохранилось (полить в 9:00 остаётся 9:00 в новой зоне).
  /// Невалидный IANA-идентификатор → `400`. Совпадение тихих часов.
  /// (`quietHoursStart == quietHoursEnd`, в т.ч. с учётом текущего значения,.
  /// если передано только одно поле) → `400`.
  @PATCH('/api/v1/me')
  Future<MeResponse> updateMe({
    @Body() required MeUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Установить координаты для погодного виджета.
  ///
  /// Сохраняет широту и долготу пользователя (`weather_lat` / `weather_lon`),.
  /// необходимые для получения данных о влажности через.
  /// `GET /api/v1/weather/snapshot`.
  ///
  /// Без координат `weatherEnabled=true` в `PATCH /me` бесполезен — погодные.
  /// эвристики не запустятся. После успешного вызова этого эндпоинта.
  /// `WeatherService.isWeatherUsable()` начнёт возвращать `true` при включённом.
  /// `weatherEnabled`.
  ///
  /// Ответ `204 No Content` — нет тела, обновление применено.
  @PUT('/api/v1/me/weather-location')
  Future<void> updateWeatherLocation({
    @Body() required WeatherLocationRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Per-season настройки сезонности.
  ///
  /// Возвращает тонкие per-season настройки сезонности текущего пользователя:.
  /// множитель (`multiplier`) и фиксированный интервал (`intervalDays`) для.
  /// каждого сезона (`SUMMER`, `WINTER`), а также глобальный флаг `enabled`.
  /// и `mode`.
  ///
  /// Какое поле реально применяется к расчёту — зависит от `mode`:.
  /// в режиме `MULTIPLIER` используется `multiplier`, в режиме `FIXED` —.
  /// `intervalDays` (а если он `null`, fallback на базовый интервал растения).
  ///
  /// Глобальный флаг включения (`seasonalEnabled`) и режим (`seasonalMode`).
  /// меняются через `PATCH /api/v1/me`; здесь они отдаются только для контекста.
  @GET('/api/v1/me/seasonal')
  Future<SeasonalSettingsResponse> getSeasonalSettings({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Задать множитель/интервал для сезона.
  ///
  /// Устанавливает множитель и/или фиксированный интервал для одного сезона.
  /// `season` обязателен. Переданные поля (`multiplier`, `intervalDays`).
  /// применяются, отсутствующие (`null`) остаются без изменений.
  ///
  /// - `multiplier` — коэффициент к базовому интервалу (диапазон `0.50..1.50`,.
  ///   округляется до сотых). Используется в режиме `MULTIPLIER`.
  /// - `intervalDays` — фиксированный интервал в днях (`1..60`). Используется.
  ///   в режиме `FIXED`. Чтобы вернуть сезон к дефолту (использовать базовый.
  ///   интервал растения), используйте `DELETE /api/v1/me/seasonal/{season}`.
  ///
  /// Изменение влияет на ленивый пересчёт `next_due_at` так же, как в боте.
  @PATCH('/api/v1/me/seasonal')
  Future<SeasonalSettingsResponse> updateSeasonalSettings({
    @Body() required SeasonalSettingsUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Очистить фиксированный интервал сезона.
  ///
  /// Сбрасывает фиксированный интервал (`intervalDays`) указанного сезона в.
  /// `null` — сезон возвращается к дефолтному поведению (в режиме `FIXED`.
  /// используется базовый интервал растения). Множитель сезона не затрагивается.
  ///
  /// Идемпотентно: повторный вызов для уже очищенного сезона тоже вернёт `200`.
  ///
  /// [season] - Сезон, чей фиксированный интервал нужно очистить.
  @DELETE('/api/v1/me/seasonal/{season}')
  Future<SeasonalSettingsResponse> clearSeasonalInterval({
    @Path('season') required Season season,
    @Extras() Map<String, dynamic>? extras,
  });
}
