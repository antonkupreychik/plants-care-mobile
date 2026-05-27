// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/care_type_dto.dart';

part 'care_types_client.g.dart';

@RestApi()
abstract class CareTypesClient {
  factory CareTypesClient(Dio dio, {String? baseUrl}) = _CareTypesClient;

  /// Справочник типов ухода.
  ///
  /// Возвращает все типы ухода с локализованными русскими названиями.
  /// Список фиксирован: `WATERING`, `MISTING`, `FERTILIZING`, `SOIL_CHECK`.
  ///
  /// Аутентификация не требуется.
  @GET('/api/v1/care-types')
  Future<List<CareTypeDto>> listCareTypes({
    @Extras() Map<String, dynamic>? extras,
  });
}
