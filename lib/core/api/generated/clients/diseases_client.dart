// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/disease_dto.dart';

part 'diseases_client.g.dart';

@RestApi()
abstract class DiseasesClient {
  factory DiseasesClient(Dio dio, {String? baseUrl}) = _DiseasesClient;

  /// Список болезней / полнотекстовый поиск.
  ///
  /// Публичный справочник болезней и вредителей комнатных растений.
  /// Без авторизации.
  ///
  /// Без параметра `q` — полный список в алфавитном порядке.
  /// С параметром `q` — полнотекстовый поиск (делегирует `DiseaseService.search(q, 20)`).
  ///
  /// [q] - Поисковая строка. Если пустая — возвращаются все болезни.
  @GET('/api/v1/diseases')
  Future<List<DiseaseDto>> listDiseases({
    @Query('q') String? q = '',
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
