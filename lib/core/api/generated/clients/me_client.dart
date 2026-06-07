// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/me_response.dart';
import '../models/me_update_request.dart';

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
}
