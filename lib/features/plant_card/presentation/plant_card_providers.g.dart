// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_card_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Деталь растения (`GET /plants/{id}`, scope user).

@ProviderFor(plantDetail)
final plantDetailProvider = PlantDetailFamily._();

/// Деталь растения (`GET /plants/{id}`, scope user).

final class PlantDetailProvider
    extends $FunctionalProvider<AsyncValue<Plant>, Plant, FutureOr<Plant>>
    with $FutureModifier<Plant>, $FutureProvider<Plant> {
  /// Деталь растения (`GET /plants/{id}`, scope user).
  PlantDetailProvider._({
    required PlantDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantDetailHash();

  @override
  String toString() {
    return r'plantDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Plant> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Plant> create(Ref ref) {
    final argument = this.argument as int;
    return plantDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantDetailHash() => r'2de59d8b14b3a8c93690413bd3800049b88adb57';

/// Деталь растения (`GET /plants/{id}`, scope user).

final class PlantDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Plant>, int> {
  PlantDetailFamily._()
    : super(
        retry: null,
        name: r'plantDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Деталь растения (`GET /plants/{id}`, scope user).

  PlantDetailProvider call(int plantId) =>
      PlantDetailProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantDetailProvider';
}

/// История ухода для карточки — первые 5 записей без пагинации.
///
/// Используется для инвалидации после `POST /care-events` (LOG_CARE_EVENT_CONTROLLER)
/// и как запасной провайдер в тестах, не переведённых на [plantCardHistoryProvider].
/// Новый UI использует [plantCardHistoryProvider].

@ProviderFor(plantHistory)
final plantHistoryProvider = PlantHistoryFamily._();

/// История ухода для карточки — первые 5 записей без пагинации.
///
/// Используется для инвалидации после `POST /care-events` (LOG_CARE_EVENT_CONTROLLER)
/// и как запасной провайдер в тестах, не переведённых на [plantCardHistoryProvider].
/// Новый UI использует [plantCardHistoryProvider].

final class PlantHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CareHistoryEntry>>,
          List<CareHistoryEntry>,
          FutureOr<List<CareHistoryEntry>>
        >
    with
        $FutureModifier<List<CareHistoryEntry>>,
        $FutureProvider<List<CareHistoryEntry>> {
  /// История ухода для карточки — первые 5 записей без пагинации.
  ///
  /// Используется для инвалидации после `POST /care-events` (LOG_CARE_EVENT_CONTROLLER)
  /// и как запасной провайдер в тестах, не переведённых на [plantCardHistoryProvider].
  /// Новый UI использует [plantCardHistoryProvider].
  PlantHistoryProvider._({
    required PlantHistoryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantHistoryHash();

  @override
  String toString() {
    return r'plantHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CareHistoryEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CareHistoryEntry>> create(Ref ref) {
    final argument = this.argument as int;
    return plantHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantHistoryHash() => r'cf24cc88ffd54a3b02825d4a4b2ece8b663fea52';

/// История ухода для карточки — первые 5 записей без пагинации.
///
/// Используется для инвалидации после `POST /care-events` (LOG_CARE_EVENT_CONTROLLER)
/// и как запасной провайдер в тестах, не переведённых на [plantCardHistoryProvider].
/// Новый UI использует [plantCardHistoryProvider].

final class PlantHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CareHistoryEntry>>, int> {
  PlantHistoryFamily._()
    : super(
        retry: null,
        name: r'plantHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// История ухода для карточки — первые 5 записей без пагинации.
  ///
  /// Используется для инвалидации после `POST /care-events` (LOG_CARE_EVENT_CONTROLLER)
  /// и как запасной провайдер в тестах, не переведённых на [plantCardHistoryProvider].
  /// Новый UI использует [plantCardHistoryProvider].

  PlantHistoryProvider call(int plantId) =>
      PlantHistoryProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantHistoryProvider';
}

/// Аккумулирующий нотифаер дневника ухода на карточке растения (02).
///
/// `build` грузит первую страницу (limit=5, offset=0). [loadMore] дотягивает
/// следующие 5 и аппендит. [hasMore] = false когда `items.length >= total`.
///
/// После `POST /care-events` инвалидируй этот провайдер (и [plantHistoryProvider])
/// — нотифаер перезагрузится с нуля (первые 5).

@ProviderFor(PlantCardHistory)
final plantCardHistoryProvider = PlantCardHistoryFamily._();

/// Аккумулирующий нотифаер дневника ухода на карточке растения (02).
///
/// `build` грузит первую страницу (limit=5, offset=0). [loadMore] дотягивает
/// следующие 5 и аппендит. [hasMore] = false когда `items.length >= total`.
///
/// После `POST /care-events` инвалидируй этот провайдер (и [plantHistoryProvider])
/// — нотифаер перезагрузится с нуля (первые 5).
final class PlantCardHistoryProvider
    extends $AsyncNotifierProvider<PlantCardHistory, PlantCardHistoryState> {
  /// Аккумулирующий нотифаер дневника ухода на карточке растения (02).
  ///
  /// `build` грузит первую страницу (limit=5, offset=0). [loadMore] дотягивает
  /// следующие 5 и аппендит. [hasMore] = false когда `items.length >= total`.
  ///
  /// После `POST /care-events` инвалидируй этот провайдер (и [plantHistoryProvider])
  /// — нотифаер перезагрузится с нуля (первые 5).
  PlantCardHistoryProvider._({
    required PlantCardHistoryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantCardHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantCardHistoryHash();

  @override
  String toString() {
    return r'plantCardHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlantCardHistory create() => PlantCardHistory();

  @override
  bool operator ==(Object other) {
    return other is PlantCardHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantCardHistoryHash() => r'7edbed8be1b426debe601b970990ce9ad963f137';

/// Аккумулирующий нотифаер дневника ухода на карточке растения (02).
///
/// `build` грузит первую страницу (limit=5, offset=0). [loadMore] дотягивает
/// следующие 5 и аппендит. [hasMore] = false когда `items.length >= total`.
///
/// После `POST /care-events` инвалидируй этот провайдер (и [plantHistoryProvider])
/// — нотифаер перезагрузится с нуля (первые 5).

final class PlantCardHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          PlantCardHistory,
          AsyncValue<PlantCardHistoryState>,
          PlantCardHistoryState,
          FutureOr<PlantCardHistoryState>,
          int
        > {
  PlantCardHistoryFamily._()
    : super(
        retry: null,
        name: r'plantCardHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Аккумулирующий нотифаер дневника ухода на карточке растения (02).
  ///
  /// `build` грузит первую страницу (limit=5, offset=0). [loadMore] дотягивает
  /// следующие 5 и аппендит. [hasMore] = false когда `items.length >= total`.
  ///
  /// После `POST /care-events` инвалидируй этот провайдер (и [plantHistoryProvider])
  /// — нотифаер перезагрузится с нуля (первые 5).

  PlantCardHistoryProvider call(int plantId) =>
      PlantCardHistoryProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantCardHistoryProvider';
}

/// Аккумулирующий нотифаер дневника ухода на карточке растения (02).
///
/// `build` грузит первую страницу (limit=5, offset=0). [loadMore] дотягивает
/// следующие 5 и аппендит. [hasMore] = false когда `items.length >= total`.
///
/// После `POST /care-events` инвалидируй этот провайдер (и [plantHistoryProvider])
/// — нотифаер перезагрузится с нуля (первые 5).

abstract class _$PlantCardHistory
    extends $AsyncNotifier<PlantCardHistoryState> {
  late final _$args = ref.$arg as int;
  int get plantId => _$args;

  FutureOr<PlantCardHistoryState> build(int plantId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<PlantCardHistoryState>, PlantCardHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PlantCardHistoryState>,
                PlantCardHistoryState
              >,
              AsyncValue<PlantCardHistoryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Стрик растения (`GET /stats/streak`, scope chat).

@ProviderFor(plantStreak)
final plantStreakProvider = PlantStreakFamily._();

/// Стрик растения (`GET /stats/streak`, scope chat).

final class PlantStreakProvider
    extends $FunctionalProvider<AsyncValue<Streak>, Streak, FutureOr<Streak>>
    with $FutureModifier<Streak>, $FutureProvider<Streak> {
  /// Стрик растения (`GET /stats/streak`, scope chat).
  PlantStreakProvider._({
    required PlantStreakFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantStreakProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantStreakHash();

  @override
  String toString() {
    return r'plantStreakProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Streak> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Streak> create(Ref ref) {
    final argument = this.argument as int;
    return plantStreak(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantStreakProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantStreakHash() => r'c54334ce59e9a5a570775d42a7c33e0b6a8d198a';

/// Стрик растения (`GET /stats/streak`, scope chat).

final class PlantStreakFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Streak>, int> {
  PlantStreakFamily._()
    : super(
        retry: null,
        name: r'plantStreakProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Стрик растения (`GET /stats/streak`, scope chat).

  PlantStreakProvider call(int plantId) =>
      PlantStreakProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantStreakProvider';
}

/// Health Score растения (`GET /plants/{id}/health`, scope none — публичный).
///
/// Один family-провайдер на `plantId` для ОБОИХ потребителей: бейдж на карточке
/// растения (02) и кольцо на карточках Home-сетки (01, по `plant.id`). Family
/// кэширует по ключу и автодиспозит — два разных провайдера НЕ заводим.

@ProviderFor(plantHealth)
final plantHealthProvider = PlantHealthFamily._();

/// Health Score растения (`GET /plants/{id}/health`, scope none — публичный).
///
/// Один family-провайдер на `plantId` для ОБОИХ потребителей: бейдж на карточке
/// растения (02) и кольцо на карточках Home-сетки (01, по `plant.id`). Family
/// кэширует по ключу и автодиспозит — два разных провайдера НЕ заводим.

final class PlantHealthProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlantHealth>,
          PlantHealth,
          FutureOr<PlantHealth>
        >
    with $FutureModifier<PlantHealth>, $FutureProvider<PlantHealth> {
  /// Health Score растения (`GET /plants/{id}/health`, scope none — публичный).
  ///
  /// Один family-провайдер на `plantId` для ОБОИХ потребителей: бейдж на карточке
  /// растения (02) и кольцо на карточках Home-сетки (01, по `plant.id`). Family
  /// кэширует по ключу и автодиспозит — два разных провайдера НЕ заводим.
  PlantHealthProvider._({
    required PlantHealthFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantHealthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantHealthHash();

  @override
  String toString() {
    return r'plantHealthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PlantHealth> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlantHealth> create(Ref ref) {
    final argument = this.argument as int;
    return plantHealth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantHealthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantHealthHash() => r'92ebf2e4b7f4295bc42d598133f7ca1f9d7bb5b9';

/// Health Score растения (`GET /plants/{id}/health`, scope none — публичный).
///
/// Один family-провайдер на `plantId` для ОБОИХ потребителей: бейдж на карточке
/// растения (02) и кольцо на карточках Home-сетки (01, по `plant.id`). Family
/// кэширует по ключу и автодиспозит — два разных провайдера НЕ заводим.

final class PlantHealthFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PlantHealth>, int> {
  PlantHealthFamily._()
    : super(
        retry: null,
        name: r'plantHealthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Health Score растения (`GET /plants/{id}/health`, scope none — публичный).
  ///
  /// Один family-провайдер на `plantId` для ОБОИХ потребителей: бейдж на карточке
  /// растения (02) и кольцо на карточках Home-сетки (01, по `plant.id`). Family
  /// кэширует по ключу и автодиспозит — два разных провайдера НЕ заводим.

  PlantHealthProvider call(int plantId) =>
      PlantHealthProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantHealthProvider';
}

/// Нотифайер архивации растения (`DELETE /api/v1/plants/{id}`).
///
/// Idle — `AsyncData(null)`, loading — `AsyncLoading`, error — `AsyncError`.
/// После успеха инвалидирует [plantDetailProvider] и [homePlantsProvider],
/// чтобы домашний экран больше не показывал архивное растение.
/// UI должен слушать state и при [AsyncData] навигироваться на '/home'.

@ProviderFor(ArchivePlant)
final archivePlantProvider = ArchivePlantFamily._();

/// Нотифайер архивации растения (`DELETE /api/v1/plants/{id}`).
///
/// Idle — `AsyncData(null)`, loading — `AsyncLoading`, error — `AsyncError`.
/// После успеха инвалидирует [plantDetailProvider] и [homePlantsProvider],
/// чтобы домашний экран больше не показывал архивное растение.
/// UI должен слушать state и при [AsyncData] навигироваться на '/home'.
final class ArchivePlantProvider
    extends $AsyncNotifierProvider<ArchivePlant, void> {
  /// Нотифайер архивации растения (`DELETE /api/v1/plants/{id}`).
  ///
  /// Idle — `AsyncData(null)`, loading — `AsyncLoading`, error — `AsyncError`.
  /// После успеха инвалидирует [plantDetailProvider] и [homePlantsProvider],
  /// чтобы домашний экран больше не показывал архивное растение.
  /// UI должен слушать state и при [AsyncData] навигироваться на '/home'.
  ArchivePlantProvider._({
    required ArchivePlantFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'archivePlantProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$archivePlantHash();

  @override
  String toString() {
    return r'archivePlantProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ArchivePlant create() => ArchivePlant();

  @override
  bool operator ==(Object other) {
    return other is ArchivePlantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$archivePlantHash() => r'4e6692f8c7bed8b8f4533307111a7f0af5c861b2';

/// Нотифайер архивации растения (`DELETE /api/v1/plants/{id}`).
///
/// Idle — `AsyncData(null)`, loading — `AsyncLoading`, error — `AsyncError`.
/// После успеха инвалидирует [plantDetailProvider] и [homePlantsProvider],
/// чтобы домашний экран больше не показывал архивное растение.
/// UI должен слушать state и при [AsyncData] навигироваться на '/home'.

final class ArchivePlantFamily extends $Family
    with
        $ClassFamilyOverride<
          ArchivePlant,
          AsyncValue<void>,
          void,
          FutureOr<void>,
          int
        > {
  ArchivePlantFamily._()
    : super(
        retry: null,
        name: r'archivePlantProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Нотифайер архивации растения (`DELETE /api/v1/plants/{id}`).
  ///
  /// Idle — `AsyncData(null)`, loading — `AsyncLoading`, error — `AsyncError`.
  /// После успеха инвалидирует [plantDetailProvider] и [homePlantsProvider],
  /// чтобы домашний экран больше не показывал архивное растение.
  /// UI должен слушать state и при [AsyncData] навигироваться на '/home'.

  ArchivePlantProvider call(int plantId) =>
      ArchivePlantProvider._(argument: plantId, from: this);

  @override
  String toString() => r'archivePlantProvider';
}

/// Нотифайер архивации растения (`DELETE /api/v1/plants/{id}`).
///
/// Idle — `AsyncData(null)`, loading — `AsyncLoading`, error — `AsyncError`.
/// После успеха инвалидирует [plantDetailProvider] и [homePlantsProvider],
/// чтобы домашний экран больше не показывал архивное растение.
/// UI должен слушать state и при [AsyncData] навигироваться на '/home'.

abstract class _$ArchivePlant extends $AsyncNotifier<void> {
  late final _$args = ref.$arg as int;
  int get plantId => _$args;

  FutureOr<void> build(int plantId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
