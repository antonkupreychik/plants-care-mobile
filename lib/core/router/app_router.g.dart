// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Роутер приложения (MADR-005).
///
/// `StatefulShellRoute.indexedStack` с тремя branch'ами под общим [AppShell]:
/// Сад (`/home`), График (`/schedule`) и Каталог (`/catalog`). Каждый branch
/// держит свой стек: в саду живут push-маршруты `/home/today` (экран 03
/// «Сегодня»), `/home/add` (экран 04 «Мастер добавления») и `/home/plants/:id`
/// (экран 02 «Карточка растения»), в каталоге —
/// `/catalog/:id` (экран 13 «Деталь вида»), в профиле — `/profile/rooms`
/// (управление комнатами). Detail/drill-in-экраны со своей нижней кнопкой/назад
/// рендерятся на [_rootNavigatorKey] (поверх shell, без плавающего таб-бара).
/// Профиль — branch 3 (`/profile`), таб в нижней навигации активен, см.
/// [AppBottomNav].
///
/// Старт — `/home` (экран «Мой сад»), это фиксирует контракт стартового экрана.
///
/// Группа `/auth/*` — полноэкранные экраны входа ВНЕ табов, на
/// [_rootNavigatorKey] (рядом с shell, top-level). Это РЕАЛЬНЫЙ auth-флоу с
/// router-guard (MADR-008): email magic-link (`/auth/email` → `/auth/verify`)
/// + legacy-превью (07/08/09). [redirect] гейтит всё приложение по
/// [AuthStatusNotifier] (`authStatusProvider`): неавторизованного уводит на
/// `/auth/welcome`, авторизованного из `/auth/*` — на `/home`. Реактивность —
/// через [GoRouter.refreshListenable] на тот же notifier (роутер сам по себе
/// keepAlive и не пересобирается).

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Роутер приложения (MADR-005).
///
/// `StatefulShellRoute.indexedStack` с тремя branch'ами под общим [AppShell]:
/// Сад (`/home`), График (`/schedule`) и Каталог (`/catalog`). Каждый branch
/// держит свой стек: в саду живут push-маршруты `/home/today` (экран 03
/// «Сегодня»), `/home/add` (экран 04 «Мастер добавления») и `/home/plants/:id`
/// (экран 02 «Карточка растения»), в каталоге —
/// `/catalog/:id` (экран 13 «Деталь вида»), в профиле — `/profile/rooms`
/// (управление комнатами). Detail/drill-in-экраны со своей нижней кнопкой/назад
/// рендерятся на [_rootNavigatorKey] (поверх shell, без плавающего таб-бара).
/// Профиль — branch 3 (`/profile`), таб в нижней навигации активен, см.
/// [AppBottomNav].
///
/// Старт — `/home` (экран «Мой сад»), это фиксирует контракт стартового экрана.
///
/// Группа `/auth/*` — полноэкранные экраны входа ВНЕ табов, на
/// [_rootNavigatorKey] (рядом с shell, top-level). Это РЕАЛЬНЫЙ auth-флоу с
/// router-guard (MADR-008): email magic-link (`/auth/email` → `/auth/verify`)
/// + legacy-превью (07/08/09). [redirect] гейтит всё приложение по
/// [AuthStatusNotifier] (`authStatusProvider`): неавторизованного уводит на
/// `/auth/welcome`, авторизованного из `/auth/*` — на `/home`. Реактивность —
/// через [GoRouter.refreshListenable] на тот же notifier (роутер сам по себе
/// keepAlive и не пересобирается).

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Роутер приложения (MADR-005).
  ///
  /// `StatefulShellRoute.indexedStack` с тремя branch'ами под общим [AppShell]:
  /// Сад (`/home`), График (`/schedule`) и Каталог (`/catalog`). Каждый branch
  /// держит свой стек: в саду живут push-маршруты `/home/today` (экран 03
  /// «Сегодня»), `/home/add` (экран 04 «Мастер добавления») и `/home/plants/:id`
  /// (экран 02 «Карточка растения»), в каталоге —
  /// `/catalog/:id` (экран 13 «Деталь вида»), в профиле — `/profile/rooms`
  /// (управление комнатами). Detail/drill-in-экраны со своей нижней кнопкой/назад
  /// рендерятся на [_rootNavigatorKey] (поверх shell, без плавающего таб-бара).
  /// Профиль — branch 3 (`/profile`), таб в нижней навигации активен, см.
  /// [AppBottomNav].
  ///
  /// Старт — `/home` (экран «Мой сад»), это фиксирует контракт стартового экрана.
  ///
  /// Группа `/auth/*` — полноэкранные экраны входа ВНЕ табов, на
  /// [_rootNavigatorKey] (рядом с shell, top-level). Это РЕАЛЬНЫЙ auth-флоу с
  /// router-guard (MADR-008): email magic-link (`/auth/email` → `/auth/verify`)
  /// + legacy-превью (07/08/09). [redirect] гейтит всё приложение по
  /// [AuthStatusNotifier] (`authStatusProvider`): неавторизованного уводит на
  /// `/auth/welcome`, авторизованного из `/auth/*` — на `/home`. Реактивность —
  /// через [GoRouter.refreshListenable] на тот же notifier (роутер сам по себе
  /// keepAlive и не пересобирается).
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'6969b015870871eb09b09b68ec04cb39ed7334c7';
