import 'package:dio/dio.dart';

import '../../../core/api/generated/models/shopping_item_create_request.dart';
import '../../../core/api/generated/models/shopping_item_update_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/shopping_item.dart';
import '../domain/shopping_repository.dart';
import 'mappers/shopping_item_mapper.dart';

/// Реализация [ShoppingRepository] поверх сгенерированного API-клиента
/// (MADR-007), зеркалит `NotificationsRepositoryImpl`. Все эндпоинты помечают
/// [AuthScope.user] — `AuthInterceptor` подставит `Authorization: Bearer` из
/// текущей `AuthSession` (MADR-008); backend резолвит пользователя из `sub`.
/// Идентичность здесь НЕ хардкодится.
///
/// Только сеть, без локального кеша: список короткий и непагинированный,
/// эталонные листовые фичи (`notifications`, `care_history`) тоже без drift
/// (см. отчёт). Ошибки dio `ErrorInterceptor` нормализует в [ApiError] и кладёт
/// в `DioException.error`; здесь разворачиваем в `Result.failure` (MADR-011),
/// наружу не бросаем.
class ShoppingRepositoryImpl implements ShoppingRepository {
  const ShoppingRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<List<ShoppingItem>>> listItems() async {
    try {
      final response = await _api.shopping.listShoppingItems(
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(
        response.items.map((dto) => dto.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<ShoppingItem>> addItem(String title) async {
    try {
      final dto = await _api.shopping.createShoppingItem(
        body: ShoppingItemCreateRequest(title: title),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<ShoppingItem>> setChecked({
    required int id,
    required bool checked,
  }) async {
    try {
      final dto = await _api.shopping.updateShoppingItem(
        id: id,
        body: ShoppingItemUpdateRequest(checked: checked),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<void>> deleteItem(int id) async {
    try {
      await _api.shopping.deleteShoppingItem(
        id: id,
        extras: authScopeExtra(AuthScope.user),
      );
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
