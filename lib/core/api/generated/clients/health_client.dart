// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/health_response.dart';

part 'health_client.g.dart';

@RestApi()
abstract class HealthClient {
  factory HealthClient(Dio dio, {String? baseUrl}) = _HealthClient;

  /// Liveness probe.
  ///
  /// Возвращает фиксированный `{"status":"UP"}` без обращения к БД или.
  /// внешним сервисам. Подходит как `livenessProbe` в Kubernetes/Railway.
  ///
  /// Не требует никаких заголовков и аутентификации.
  @GET('/api/v1/health')
  Future<HealthResponse> getHealth({
    @Extras() Map<String, dynamic>? extras,
  });
}
