import 'package:dio/dio.dart';

import '../../../core/api/generated/models/sharing_invite_create_request.dart';
import '../../../core/api/generated/plants_care_api.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../../../core/network/auth_scope.dart';
import '../../../core/network/request_extra.dart';
import '../domain/sharing_member.dart';
import '../domain/sharing_repository.dart';
import 'mappers/sharing_member_mapper.dart';

/// Реализация [SharingRepository] поверх сгенерированного API-клиента
/// (MADR-007).
///
/// На каждый запрос проставляет [AuthScope.user] через `authScopeExtra` —
/// заголовок `Authorization` подставит `AuthInterceptor` из текущей
/// `AuthSession` (MADR-006/008). Идентичность здесь НЕ хардкодится.
///
/// Ошибки dio ловит `ErrorInterceptor` и кладёт [ApiError] в
/// `DioException.error`; здесь это разворачивается в `Result.failure`
/// (MADR-011), наружу не бросаем.
class SharingRepositoryImpl implements SharingRepository {
  const SharingRepositoryImpl(this._api);

  final PlantsCareApi _api;

  @override
  Future<Result<List<SharingMember>>> getMembers() async {
    try {
      final response = await _api.sharing.listSharingMembers(
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(
        response.members.map((dto) => dto.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  @override
  Future<Result<SharingMember>> invite({
    required List<int> plantIds,
    required String inviteeContact,
    required bool canLogCare,
  }) async {
    try {
      final dto = await _api.sharing.createSharingInvite(
        body: SharingInviteCreateRequest(
          plantIds: plantIds,
          inviteeContact: inviteeContact,
          canLogCare: canLogCare,
        ),
        extras: authScopeExtra(AuthScope.user),
      );
      return Result.success(dto.toDomain());
    } on DioException catch (e) {
      return Result.failure(_toApiError(e));
    }
  }

  /// `ErrorInterceptor` уже нормализовал ошибку в [ApiError] и положил её в
  /// `DioException.error`. Если там не [ApiError] — безопасный fallback.
  ApiError _toApiError(DioException e) =>
      e.error is ApiError ? e.error! as ApiError : const ApiError.unknown();
}
