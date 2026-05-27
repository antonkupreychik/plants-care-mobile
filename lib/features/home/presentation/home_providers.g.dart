// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана «Главная — Мой сад» (01).
///
/// Три независимых провайдера (today / plants / locations), а не один агрегат:
/// секции грузятся и падают независимо, UI рисует skeleton/ошибку посекционно
/// (например, задачи ещё грузятся, а список растений уже готов). Это проще
/// инвалидировать после `POST /care-events` (инвалидируем только `homeTasks`)
/// и тестировать. Если позже понадобится единый «заголовок саммари» — он
/// собирается из этих трёх на уровне UI/Notifier без перетряхивания data.
///
/// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
/// Задачи на сегодня (`GET /today`). Группировку «утро/вечер» делает UI
/// по `CareTask.dueAt` (в TZ пользователя) — domain интервалы не считает.

@ProviderFor(homeTasks)
final homeTasksProvider = HomeTasksProvider._();

/// State-слой экрана «Главная — Мой сад» (01).
///
/// Три независимых провайдера (today / plants / locations), а не один агрегат:
/// секции грузятся и падают независимо, UI рисует skeleton/ошибку посекционно
/// (например, задачи ещё грузятся, а список растений уже готов). Это проще
/// инвалидировать после `POST /care-events` (инвалидируем только `homeTasks`)
/// и тестировать. Если позже понадобится единый «заголовок саммари» — он
/// собирается из этих трёх на уровне UI/Notifier без перетряхивания data.
///
/// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
/// Задачи на сегодня (`GET /today`). Группировку «утро/вечер» делает UI
/// по `CareTask.dueAt` (в TZ пользователя) — domain интервалы не считает.

final class HomeTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CareTask>>,
          List<CareTask>,
          FutureOr<List<CareTask>>
        >
    with $FutureModifier<List<CareTask>>, $FutureProvider<List<CareTask>> {
  /// State-слой экрана «Главная — Мой сад» (01).
  ///
  /// Три независимых провайдера (today / plants / locations), а не один агрегат:
  /// секции грузятся и падают независимо, UI рисует skeleton/ошибку посекционно
  /// (например, задачи ещё грузятся, а список растений уже готов). Это проще
  /// инвалидировать после `POST /care-events` (инвалидируем только `homeTasks`)
  /// и тестировать. Если позже понадобится единый «заголовок саммари» — он
  /// собирается из этих трёх на уровне UI/Notifier без перетряхивания data.
  ///
  /// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
  /// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
  /// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
  /// Задачи на сегодня (`GET /today`). Группировку «утро/вечер» делает UI
  /// по `CareTask.dueAt` (в TZ пользователя) — domain интервалы не считает.
  HomeTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeTasksHash();

  @$internal
  @override
  $FutureProviderElement<List<CareTask>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CareTask>> create(Ref ref) {
    return homeTasks(ref);
  }
}

String _$homeTasksHash() => r'fa69197de865169d7d06122e98193fc81b91e1a1';

/// Растения пользователя (`GET /plants`).

@ProviderFor(homePlants)
final homePlantsProvider = HomePlantsProvider._();

/// Растения пользователя (`GET /plants`).

final class HomePlantsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Plant>>,
          List<Plant>,
          FutureOr<List<Plant>>
        >
    with $FutureModifier<List<Plant>>, $FutureProvider<List<Plant>> {
  /// Растения пользователя (`GET /plants`).
  HomePlantsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homePlantsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homePlantsHash();

  @$internal
  @override
  $FutureProviderElement<List<Plant>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Plant>> create(Ref ref) {
    return homePlants(ref);
  }
}

String _$homePlantsHash() => r'12eb547fecc7a7fc3ed480e8f8a7869492edc42f';

/// Локации пользователя (`GET /locations`).

@ProviderFor(homeLocations)
final homeLocationsProvider = HomeLocationsProvider._();

/// Локации пользователя (`GET /locations`).

final class HomeLocationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GardenLocation>>,
          List<GardenLocation>,
          FutureOr<List<GardenLocation>>
        >
    with
        $FutureModifier<List<GardenLocation>>,
        $FutureProvider<List<GardenLocation>> {
  /// Локации пользователя (`GET /locations`).
  HomeLocationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLocationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLocationsHash();

  @$internal
  @override
  $FutureProviderElement<List<GardenLocation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GardenLocation>> create(Ref ref) {
    return homeLocations(ref);
  }
}

String _$homeLocationsHash() => r'316ed4c5f5646f2ad7ce4dd1ac6315f17faf8bec';
