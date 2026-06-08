// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/photo_progress_compare_response.dart';
import '../models/photo_progress_frequency_request.dart';
import '../models/photo_progress_frequency_response.dart';
import '../models/photo_progress_history_response.dart';
import '../models/photo_progress_item_dto.dart';

part 'photo_progress_client.g.dart';

@RestApi()
abstract class PhotoProgressClient {
  factory PhotoProgressClient(Dio dio, {String? baseUrl}) = _PhotoProgressClient;

  /// Добавить фото прогресса.
  ///
  /// Загружает фото развития растения текущего пользователя (из bearer-токена).
  /// в S3-совместимый бакет и добавляет его в таймлайн фото-прогресса.
  ///
  /// Принимается только `image/*`. Размер ограничен сервером (~5 МБ, лимит.
  /// `app.storage.s3.max-upload-bytes`); превышение → 413. Невалидный тип /.
  /// пустой файл → 400. Анти-спам: не больше одного фото за 24 часа на.
  /// растение → 409. Растение не найдено / чужое → 404.
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [file] - Файл изображения (image/*).
  ///
  /// [caption] - Опциональная подпись к фото (до 500 символов).
  @MultiPart()
  @POST('/api/v1/plants/{id}/photo-progress')
  Future<PhotoProgressItemDto> addPhotoProgress({
    @Path('id') required int id,
    @Part(name: 'file') required File file,
    @Part(name: 'caption') String? caption,
    @Extras() Map<String, dynamic>? extras,
  });

  /// История фото прогресса.
  ///
  /// Возвращает страницу таймлайна фото-прогресса растения в обратном.
  /// хронологическом порядке (свежие сверху), с датами и presigned URL на.
  /// скачивание каждого снимка.
  ///
  /// Пагинация — `limit/offset`. `limit` строго в диапазоне [1, 100].
  /// (вне диапазона → 400). `offset` < 0 нормализуется в 0. Растение не.
  /// найдено / чужое → 404.
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [limit] - Размер страницы. Допустимые значения — [1, 100].
  ///
  /// [offset] - Сдвиг от начала истории. Значения < 0 нормализуются в 0.
  @GET('/api/v1/plants/{id}/photo-progress')
  Future<PhotoProgressHistoryResponse> getPhotoProgressHistory({
    @Path('id') required int id,
    @Query('limit') int? limit = 10,
    @Query('offset') int? offset = 0,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Сравнить два снимка.
  ///
  /// Возвращает пару снимков «до/после» по двум идентификаторам записей.
  /// таймлайна (`from`, `to`). Сервер сам определяет, какой из двух — «до».
  /// (более раннее `takenAt`), а какой — «после». Оба снимка должны.
  /// принадлежать этому растению пользователя.
  ///
  /// Если снимки совпадают, не найдены или не относятся к растению — 404.
  ///
  /// [id] - Идентификатор растения.
  ///
  /// [from] - Идентификатор первого снимка таймлайна.
  ///
  /// [to] - Идентификатор второго снимка таймлайна.
  @GET('/api/v1/plants/{id}/photo-progress/compare')
  Future<PhotoProgressCompareResponse> comparePhotoProgress({
    @Path('id') required int id,
    @Query('from') required int from,
    @Query('to') required int to,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Частота напоминаний о фото.
  ///
  /// Устанавливает частоту пушей «обнови фото» для растения: `OFF` —.
  /// выключено, `P2W` — раз в 2 недели, `P1M` — раз в месяц. Растение не.
  /// найдено / чужое → 404.
  ///
  /// [id] - Идентификатор растения.
  @PATCH('/api/v1/plants/{id}/photo-progress/frequency')
  Future<PhotoProgressFrequencyResponse> setPhotoProgressFrequency({
    @Path('id') required int id,
    @Body() required PhotoProgressFrequencyRequest body,
    @Extras() Map<String, dynamic>? extras,
  });
}
