// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер ленты с накоплением страниц, отметкой прочтения (оптимистичной)
/// и счётчиком непрочитанных. Зеркалит `CareHistoryController`.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [markRead] помечает прочитанным оптимистично с
/// откатом при ошибке.

@ProviderFor(NotificationsController)
final notificationsControllerProvider = NotificationsControllerProvider._();

/// Контроллер ленты с накоплением страниц, отметкой прочтения (оптимистичной)
/// и счётчиком непрочитанных. Зеркалит `CareHistoryController`.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [markRead] помечает прочитанным оптимистично с
/// откатом при ошибке.
final class NotificationsControllerProvider
    extends
        $AsyncNotifierProvider<NotificationsController, NotificationsState> {
  /// Контроллер ленты с накоплением страниц, отметкой прочтения (оптимистичной)
  /// и счётчиком непрочитанных. Зеркалит `CareHistoryController`.
  ///
  /// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
  /// следующие и аппендит. [markRead] помечает прочитанным оптимистично с
  /// откатом при ошибке.
  NotificationsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsControllerHash();

  @$internal
  @override
  NotificationsController create() => NotificationsController();
}

String _$notificationsControllerHash() =>
    r'212690dbfe40a3523ec85ea4e0861b56c369b01d';

/// Контроллер ленты с накоплением страниц, отметкой прочтения (оптимистичной)
/// и счётчиком непрочитанных. Зеркалит `CareHistoryController`.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [markRead] помечает прочитанным оптимистично с
/// откатом при ошибке.

abstract class _$NotificationsController
    extends $AsyncNotifier<NotificationsState> {
  FutureOr<NotificationsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<NotificationsState>, NotificationsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NotificationsState>, NotificationsState>,
              AsyncValue<NotificationsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Счётчик непрочитанных для badge 🔔 на Home (01), выведенный из состояния
/// ленты. `0`, пока лента ещё грузится/ошибка (badge просто не показывается).
///
/// Проводку badge в HomeScreen делает ui-builder — здесь только источник.

@ProviderFor(unreadCount)
final unreadCountProvider = UnreadCountProvider._();

/// Счётчик непрочитанных для badge 🔔 на Home (01), выведенный из состояния
/// ленты. `0`, пока лента ещё грузится/ошибка (badge просто не показывается).
///
/// Проводку badge в HomeScreen делает ui-builder — здесь только источник.

final class UnreadCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Счётчик непрочитанных для badge 🔔 на Home (01), выведенный из состояния
  /// ленты. `0`, пока лента ещё грузится/ошибка (badge просто не показывается).
  ///
  /// Проводку badge в HomeScreen делает ui-builder — здесь только источник.
  UnreadCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadCountHash() => r'4d1e91de49dd7c3286764f58be7f735d071986d6';
