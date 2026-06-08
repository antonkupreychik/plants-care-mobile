// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/photo_upload_response.dart';

part 'photos_client.g.dart';

@RestApi()
abstract class PhotosClient {
  factory PhotosClient(Dio dio, {String? baseUrl}) = _PhotosClient;

  /// Загрузить фото.
  ///
  /// Загружает фото текущего пользователя (из bearer-токена) в S3-совместимый.
  /// бакет и возвращает его `id` и presigned `url` на скачивание.
  ///
  /// Принимается только `image/*`. Размер ограничен сервером (~5 МБ);.
  /// превышение → 413. Невалидный тип / пустой файл → 400.
  ///
  /// [file] - Файл изображения (image/*).
  @MultiPart()
  @POST('/api/v1/photos')
  Future<PhotoUploadResponse> uploadPhoto({
    @Part(name: 'file') required File file,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Получить фото (redirect на presigned URL).
  ///
  /// Возвращает `302 Found` с заголовком `Location`, указывающим на свежий.
  /// presigned URL объекта в бакете. 404, если фото нет, оно чужое или удалено.
  ///
  /// [id] - Идентификатор фото.
  @GET('/api/v1/photos/{id}')
  Future<void> getPhoto({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Удалить фото (soft-delete).
  ///
  /// Помечает фото удалённым (soft-delete). Объект в бакете в этом срезе не.
  /// чистится. Чужое, несуществующее или уже удалённое фото → 404.
  ///
  /// [id] - Идентификатор фото.
  @DELETE('/api/v1/photos/{id}')
  Future<void> deletePhoto({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
