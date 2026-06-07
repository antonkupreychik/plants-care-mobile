// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/disease_dto.dart';
import '../models/page_response_disease_dto.dart';

part 'diseases_client.g.dart';

@RestApi()
abstract class DiseasesClient {
  factory DiseasesClient(Dio dio, {String? baseUrl}) = _DiseasesClient;

  /// Список болезней / полнотекстовый поиск.
  ///
  /// Публичный справочник болезней и вредителей комнатных растений.
  /// Без авторизации.
  ///
  /// Без параметра `q` — полный список в алфавитном порядке постранично.
  /// С параметром `q` — полнотекстовый поиск (GIN-индекс `idx_diseases_search`).
  ///
  /// `limit` обрезается до 100.
  ///
  /// [q] - Поисковая строка. Если пустая — возвращаются все болезни.
  ///
  /// [offset] - Сдвиг от начала.
  ///
  /// [limit] - Размер страницы. Обрезается до 100.
  @GET('/api/v1/diseases')
  Future<PageResponseDiseaseDto> listDiseases({
    @Query('q') String? q = '',
    @Query('offset') int? offset = 0,
    @Query('limit') int? limit = 20,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Карточка болезни по id.
  ///
  /// Полная карточка болезни/вредителя. 404 если не найдена.
  ///
  /// [id] - Идентификатор болезни.
  @GET('/api/v1/diseases/{id}')
  Future<DiseaseDto> getDiseaseById({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
