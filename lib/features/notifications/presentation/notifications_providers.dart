import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/notifications_repository_provider.dart';
import '../domain/notification_feed.dart';
import 'notifications_state.dart';

part 'notifications_providers.g.dart';

/// State-слой ленты уведомлений (экраны 24 / 32).
///
/// Контракт для ui-builder:
/// - [notificationsControllerProvider] — `AsyncValue<NotificationsState>`
///   (loading / error / data). В `AsyncError` лежит типизированный [ApiError].
///   Из `data` UI читает `state.items`, `state.unreadCount`, `state.isEmpty`
///   (→ экран 32), `state.isLoadingMore`, `state.loadMoreError`,
///   `state.hasMoreFor(...)`. Методы контроллера: `refresh()`, `loadMore()`,
///   `retryLoadMore()`, `markRead(int id)`.
/// - [unreadCountProvider] — `int` (sync). Источник badge 🔔 на Home (01);
///   `0`, пока лента не загрузилась/ошибка. Проводку badge в HomeScreen делает
///   ui-builder (здесь её НЕ делаем).

/// Размер первичной и последующих страниц. Backend требует `limit ∈ [1, 100]`.
const int _pageSize = 20;

/// Контроллер ленты с накоплением страниц, отметкой прочтения (оптимистичной)
/// и счётчиком непрочитанных. Зеркалит `CareHistoryController`.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [markRead] помечает прочитанным оптимистично с
/// откатом при ошибке.
@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  Future<NotificationsState> build() async {
    final feed = await _fetchPage(offset: 0);
    return NotificationsState(
      items: feed.items,
      unreadCount: feed.unreadCount,
      lastPageSize: feed.items.length,
    );
  }

  /// Перезагрузить ленту с начала (pull-to-refresh). Сбрасывает в
  /// `AsyncLoading` и перечитывает первую страницу.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final feed = await _fetchPage(offset: 0);
      return NotificationsState(
        items: feed.items,
        unreadCount: feed.unreadCount,
        lastPageSize: feed.items.length,
      );
    });
  }

  /// Подгрузить следующую страницу и аппендить к накопленным.
  ///
  /// No-op, если данных ещё нет (идёт первичная загрузка/ошибка), уже грузится
  /// или последняя страница пришла неполной (конец ленты). Ошибку страницы
  /// кладёт в [NotificationsState.loadMoreError] (список сохраняется), а не в
  /// `AsyncError` всего провайдера — как в `CareHistoryController.loadMore`.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        current.isLoadingMore ||
        !current.hasMoreFor(_pageSize)) {
      return;
    }

    state =
        AsyncData(current.copyWith(isLoadingMore: true, loadMoreError: null));

    final result = await ref.read(notificationsRepositoryProvider).getFeed(
          limit: _pageSize,
          offset: current.offset,
        );

    // Нотифаер autoDispose — мог быть утилизирован за время await.
    if (!ref.mounted) return;

    final latest = state.value;
    if (latest == null) return;

    switch (result) {
      case Success(:final value):
        state = AsyncData(
          latest.copyWith(
            items: [...latest.items, ...value.items],
            // Свежий счётчик с backend (он мог измениться между страницами).
            unreadCount: value.unreadCount,
            lastPageSize: value.items.length,
            isLoadingMore: false,
            loadMoreError: null,
          ),
        );
      case Failure(:final error):
        state = AsyncData(
          latest.copyWith(isLoadingMore: false, loadMoreError: error),
        );
    }
  }

  /// Повторяет неудавшуюся дозагрузку (`loadMoreError` → попытка снова).
  Future<void> retryLoadMore() => loadMore();

  /// Отметить уведомление прочитанным оптимистично: сразу `isRead = true` и
  /// `unreadCount--`, затем `POST .../read`. При ошибке — откат к снимку.
  ///
  /// No-op, если данных ещё нет или уведомление уже прочитано (backend
  /// идемпотентен, но лишний запрос/декремент не делаем).
  Future<void> markRead(int id) async {
    final current = state.value;
    if (current == null) return;

    final index = current.items.indexWhere((n) => n.id == id);
    if (index < 0 || current.items[index].isRead) return;

    final snapshot = current;
    final optimistic = _applyRead(current, index);
    state = AsyncData(optimistic);

    final result =
        await ref.read(notificationsRepositoryProvider).markRead(id);

    if (!ref.mounted) return;

    if (result case Failure()) {
      // Откат: возвращаем снимок только если состояние с тех пор не уехало
      // дальше (новая страница/refresh). Если уехало — оставляем как есть,
      // чтобы не затереть более свежие данные.
      final latest = state.value;
      if (latest != null && identical(latest, optimistic)) {
        state = AsyncData(snapshot);
      }
    }
  }

  /// «Прочитать всё» среди уже загруженных непрочитанных: один оптимистичный
  /// переход (все непрочитанные → `isRead`, счётчик к 0), затем `POST .../read`
  /// по каждому параллельно. Если хотя бы один запрос не принят backend —
  /// реконсилируем UI с сервером через [refresh], чтобы лента не разошлась с
  /// бекендом (per-item откат тут не работает: состояние общее для всех).
  ///
  /// No-op, если данных нет или непрочитанных нет (лишних запросов не шлём).
  Future<void> markAllRead() async {
    final current = state.value;
    if (current == null) return;

    final unreadIds = [
      for (final n in current.items)
        if (!n.isRead) n.id,
    ];
    if (unreadIds.isEmpty) return;

    final now = DateTime.now().toUtc();
    final optimistic = current.copyWith(
      items: [
        for (final n in current.items)
          n.isRead ? n : n.copyWith(readAt: now),
      ],
      unreadCount: 0,
    );
    state = AsyncData(optimistic);

    final repo = ref.read(notificationsRepositoryProvider);
    final results = await Future.wait(unreadIds.map(repo.markRead));

    if (!ref.mounted) return;

    if (results.any((r) => r is Failure)) {
      await refresh();
    }
  }

  /// Помечает элемент по индексу прочитанным «сейчас» и декрементит счётчик
  /// (не ниже нуля). Время прочтения локально — фактический момент перезапишет
  /// следующий refresh из backend; для оптимистичного UI этого достаточно.
  NotificationsState _applyRead(NotificationsState s, int index) {
    final item = s.items[index];
    final updated = [...s.items];
    updated[index] = item.copyWith(readAt: DateTime.now().toUtc());
    return s.copyWith(
      items: updated,
      unreadCount: s.unreadCount > 0 ? s.unreadCount - 1 : 0,
    );
  }

  /// Запрос страницы через репозиторий; `Result.failure` пробрасывается как
  /// бросок [ApiError] — Riverpod упакует его в `AsyncError` для ПЕРВИЧНОЙ
  /// загрузки (`build`)/`refresh`. Для дозагрузки ошибки идут в `loadMoreError`.
  Future<NotificationFeed> _fetchPage({required int offset}) async {
    final result = await ref.read(notificationsRepositoryProvider).getFeed(
          limit: _pageSize,
          offset: offset,
        );
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }
}

/// Счётчик непрочитанных для badge 🔔 на Home (01), выведенный из состояния
/// ленты. `0`, пока лента ещё грузится/ошибка (badge просто не показывается).
///
/// Проводку badge в HomeScreen делает ui-builder — здесь только источник.
@riverpod
int unreadCount(Ref ref) {
  final state = ref.watch(notificationsControllerProvider).value;
  return state?.unreadCount ?? 0;
}
