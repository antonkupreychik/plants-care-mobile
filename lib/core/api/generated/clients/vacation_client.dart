// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/vacation_request.dart';
import '../models/vacation_response.dart';

part 'vacation_client.g.dart';

@RestApi()
abstract class VacationClient {
  factory VacationClient(Dio dio, {String? baseUrl}) = _VacationClient;

  /// Текущее состояние режима отпуска.
  ///
  /// Возвращает активный период отпуска или объект с `active = false`,.
  /// если отпуск не включён. «Активен» — `paused_until IS NOT NULL.
  /// AND paused_until > now()`.
  @GET('/api/v1/vacation')
  Future<VacationResponse> getVacation({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Включить режим отпуска.
  ///
  /// Включает режим отпуска: напоминания приостанавливаются с текущего.
  /// момента до конца дня `to` в таймзоне пользователя.
  ///
  /// **Поведение дедлайнов:** дедлайны расписаний **не переносятся**.
  /// Пока отпуск активен, задачи накапливаются как просроченные и.
  /// отображаются в сводке «С возвращением!» сразу после окончания отпуска.
  /// Это предсказуемо и понятно пользователю.
  ///
  /// **Идемпотентность:** повторный POST перезаписывает `paused_until`.
  /// (продление текущего отпуска). Если `to` < `from` или длительность.
  /// > 60 дней → `400`.
  @POST('/api/v1/vacation')
  Future<VacationResponse> startVacation({
    @Body() required VacationRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Выключить режим отпуска досрочно.
  ///
  /// Досрочно завершает режим отпуска — `paused_until` сбрасывается в `null`,.
  /// напоминания возобновляются немедленно. Идемпотентен: если отпуск уже.
  /// неактивен, возвращает `204` без ошибки.
  @DELETE('/api/v1/vacation')
  Future<void> endVacation({
    @Extras() Map<String, dynamic>? extras,
  });
}
