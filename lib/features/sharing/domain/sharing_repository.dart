import '../../../core/error/result.dart';
import 'sharing_member.dart';

/// Контракт data-слоя фичи «Совместный уход» (экран 26).
///
/// Эндпоинты (scope user, bearer): `GET /sharing`, `POST /sharing/invites`.
/// Все методы возвращают `Future<Result<T>>` и НЕ бросают наружу: доменные
/// ошибки backend (`{error:{code,...}}`) приходят как [ApiError] в `Failure`
/// (MADR-011). Реализация скрыта в data, presentation зависит только от этого
/// интерфейса (MADR-002).
abstract interface class SharingRepository {
  /// Список соухаживающих текущего пользователя (`GET /sharing`).
  ///
  /// Возвращает приглашения, выпущенные текущим пользователем (`sub` из
  /// bearer-токена), со статусом и правом `canLogCare`.
  Future<Result<List<SharingMember>>> getMembers();

  /// Пригласить соухаживающего (`POST /sharing/invites`).
  ///
  /// [plantIds] — минимум одно растение (пустой набор → 400). [inviteeContact]
  /// — @username или телефон, непустой (пустой → 400). Растения должны
  /// принадлежать текущему пользователю — иначе 404. [canLogCare] — дать ли
  /// право отмечать уход (по умолчанию false).
  Future<Result<SharingMember>> invite({
    required List<int> plantIds,
    required String inviteeContact,
    required bool canLogCare,
  });
}
