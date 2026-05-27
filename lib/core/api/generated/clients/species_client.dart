// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/page_response_species_summary_dto.dart';
import '../models/species_detail_dto.dart';

part 'species_client.g.dart';

@RestApi()
abstract class SpeciesClient {
  factory SpeciesClient(Dio dio, {String? baseUrl}) = _SpeciesClient;

  /// Поиск/список видов растений.
  ///
  /// Публичный справочник видов. Без авторизации. Кеширован на стороне.
  /// сервера (TTL 1 час) для популярных запросов.
  ///
  /// Параметр `q` — необязательный поиск по подстроке имени/латинского имени.
  /// Если пустой — возвращаются все виды постранично.
  ///
  /// Пагинация в этой версии переведена с `page/size` на унифицированный.
  /// `offset/limit` (как в остальных списках API). Внутри сервиса.
  /// конвертируется в `PageRequest.of(offset/limit, limit)`, поэтому.
  /// `offset` должен быть кратен `limit` для предсказуемой страницы.
  ///
  /// `limit` обрезается до 100.
  ///
  /// [q] - Подстрока для поиска по имени или латинскому имени. Если пустая — без фильтра.
  ///
  /// [offset] - Сдвиг от начала.
  ///
  /// [limit] - Размер страницы. Обрезается до 100.
  @GET('/api/v1/species')
  Future<PageResponseSpeciesSummaryDto> listSpecies({
    @Query('q') String? q = '',
    @Query('offset') int? offset = 0,
    @Query('limit') int? limit = 20,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Детали вида растения.
  ///
  /// Полная карточка вида, включая `description`. Кешируется по `id`.
  /// (TTL 1 час).
  ///
  /// [id] - Идентификатор вида.
  @GET('/api/v1/species/{id}')
  Future<SpeciesDetailDto> getSpecies({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
