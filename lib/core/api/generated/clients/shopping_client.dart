// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/shopping_item_create_request.dart';
import '../models/shopping_item_dto.dart';
import '../models/shopping_item_update_request.dart';
import '../models/shopping_list_response.dart';

part 'shopping_client.g.dart';

@RestApi()
abstract class ShoppingClient {
  factory ShoppingClient(Dio dio, {String? baseUrl}) = _ShoppingClient;

  /// Список покупок пользователя.
  ///
  /// Возвращает все позиции списка покупок текущего пользователя.
  /// (`sub` из bearer-токена). Сначала ещё не купленные, затем купленные.
  /// Без пагинации — список обычно короткий.
  @GET('/api/v1/shopping')
  Future<ShoppingListResponse> listShoppingItems({
    @Extras() Map<String, dynamic>? extras,
  });

  /// Добавить позицию в список покупок.
  ///
  /// Создаёт позицию от имени пользователя. Пустой или слишком длинный текст — 400.
  @POST('/api/v1/shopping')
  Future<ShoppingItemDto> createShoppingItem({
    @Body() required ShoppingItemCreateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Обновить позицию списка покупок.
  ///
  /// PATCH-семантика — обновляются только переданные поля.
  ///
  /// [id] - Идентификатор позиции.
  @PATCH('/api/v1/shopping/{id}')
  Future<ShoppingItemDto> updateShoppingItem({
    @Path('id') required int id,
    @Body() required ShoppingItemUpdateRequest body,
    @Extras() Map<String, dynamic>? extras,
  });

  /// Удалить позицию списка покупок.
  ///
  /// Удаляет позицию, принадлежащую пользователю. Чужая или несуществующая — 404.
  ///
  /// [id] - Идентификатор позиции.
  @DELETE('/api/v1/shopping/{id}')
  Future<void> deleteShoppingItem({
    @Path('id') required int id,
    @Extras() Map<String, dynamic>? extras,
  });
}
