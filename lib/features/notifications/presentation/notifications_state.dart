import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';
import '../domain/notification_item.dart';

part 'notifications_state.freezed.dart';

/// Накопленное состояние ленты уведомлений (экраны 24 / 32).
///
/// Presentation-state (роль ViewModel): держит ВСЕ подгруженные записи
/// ([items], новые сверху — порядок backend), счётчик непрочитанных
/// ([unreadCount], из ответа backend), флаг подзагрузки ([isLoadingMore]) и
/// ошибку последней подзагрузки ([loadMoreError]). Иммутабелен — мутируется
/// только `NotificationsController`.
///
/// Группировку по дням (`createdAt.toLocal()`) и пустое состояние
/// (`items.isEmpty` → экран 32) делает UI — это контракт для ui-builder.
@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    /// Все загруженные уведомления (накоплены по страницам), порядок backend.
    required List<NotificationItem> items,

    /// Непрочитанных у пользователя (из `NotificationsResponse.unreadCount`).
    /// Источник badge на Home; при `markRead` уменьшается оптимистично.
    required int unreadCount,

    /// Размер последней полученной страницы — по нему [hasMore] решает, есть
    /// ли смысл тянуть дальше (echo пагинации backend не отдаёт).
    required int lastPageSize,

    /// Идёт подзагрузка следующей страницы ([loadMore]). Первичная загрузка
    /// выражается через `AsyncLoading` снаружи, а не этим флагом.
    @Default(false) bool isLoadingMore,

    /// Ошибка последней подзагрузки. Показанный список сохраняется (не уходим в
    /// `AsyncError` всего провайдера) — UI рисует строку «не удалось» + retry.
    /// `null` — ошибки нет.
    ApiError? loadMoreError,
  }) = _NotificationsState;

  const NotificationsState._();

  /// Сдвиг для СЛЕДУЮЩЕЙ страницы (= числу уже загруженных записей).
  int get offset => items.length;

  /// Лента пуста (после первичной загрузки) → пустое состояние (экран 32).
  bool get isEmpty => items.isEmpty;

  /// Есть ли смысл тянуть следующую страницу: последняя страница пришла полной
  /// (размером с запрошенный `limit`). Если меньше — достигли конца ленты.
  bool hasMoreFor(int pageSize) => lastPageSize >= pageSize;
}
