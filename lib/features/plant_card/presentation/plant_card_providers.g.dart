// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_card_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана «Карточка растения» (02).
///
/// Три независимых family-провайдера (по `plantId`), а не один агрегат: деталь,
/// история и стрик грузятся и падают независимо — UI рисует skeleton/ошибку
/// посекционно (например, стрик дал 404, а деталь и история готовы). Так же
/// устроен экран 01 (`home_providers.dart`), повторяем паттерн 1:1.
///
/// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
///
/// После `POST /care-events` для этого растения инвалидируй
/// `plantHistoryProvider(plantId)` и `plantStreakProvider(plantId)`
/// (README §5 / FLUTTER.md «Правила state»).
/// Деталь растения (`GET /plants/{id}`, scope user).

@ProviderFor(plantDetail)
final plantDetailProvider = PlantDetailFamily._();

/// State-слой экрана «Карточка растения» (02).
///
/// Три независимых family-провайдера (по `plantId`), а не один агрегат: деталь,
/// история и стрик грузятся и падают независимо — UI рисует skeleton/ошибку
/// посекционно (например, стрик дал 404, а деталь и история готовы). Так же
/// устроен экран 01 (`home_providers.dart`), повторяем паттерн 1:1.
///
/// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
///
/// После `POST /care-events` для этого растения инвалидируй
/// `plantHistoryProvider(plantId)` и `plantStreakProvider(plantId)`
/// (README §5 / FLUTTER.md «Правила state»).
/// Деталь растения (`GET /plants/{id}`, scope user).

final class PlantDetailProvider
    extends $FunctionalProvider<AsyncValue<Plant>, Plant, FutureOr<Plant>>
    with $FutureModifier<Plant>, $FutureProvider<Plant> {
  /// State-слой экрана «Карточка растения» (02).
  ///
  /// Три независимых family-провайдера (по `plantId`), а не один агрегат: деталь,
  /// история и стрик грузятся и падают независимо — UI рисует skeleton/ошибку
  /// посекционно (например, стрик дал 404, а деталь и история готовы). Так же
  /// устроен экран 01 (`home_providers.dart`), повторяем паттерн 1:1.
  ///
  /// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
  /// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
  /// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
  ///
  /// После `POST /care-events` для этого растения инвалидируй
  /// `plantHistoryProvider(plantId)` и `plantStreakProvider(plantId)`
  /// (README §5 / FLUTTER.md «Правила state»).
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

/// State-слой экрана «Карточка растения» (02).
///
/// Три независимых family-провайдера (по `plantId`), а не один агрегат: деталь,
/// история и стрик грузятся и падают независимо — UI рисует skeleton/ошибку
/// посекционно (например, стрик дал 404, а деталь и история готовы). Так же
/// устроен экран 01 (`home_providers.dart`), повторяем паттерн 1:1.
///
/// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
/// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
/// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
///
/// После `POST /care-events` для этого растения инвалидируй
/// `plantHistoryProvider(plantId)` и `plantStreakProvider(plantId)`
/// (README §5 / FLUTTER.md «Правила state»).
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

  /// State-слой экрана «Карточка растения» (02).
  ///
  /// Три независимых family-провайдера (по `plantId`), а не один агрегат: деталь,
  /// история и стрик грузятся и падают независимо — UI рисует skeleton/ошибку
  /// посекционно (например, стрик дал 404, а деталь и история готовы). Так же
  /// устроен экран 01 (`home_providers.dart`), повторяем паттерн 1:1.
  ///
  /// Контракт для ui-builder: каждый провайдер отдаёт `AsyncValue<...>`
  /// (loading / error / data). В `AsyncError` лежит типизированный [ApiError]
  /// (см. [_unwrap]) — UI маппит его в текст через `AppLocalizations`.
  ///
  /// После `POST /care-events` для этого растения инвалидируй
  /// `plantHistoryProvider(plantId)` и `plantStreakProvider(plantId)`
  /// (README §5 / FLUTTER.md «Правила state»).
  /// Деталь растения (`GET /plants/{id}`, scope user).

  PlantDetailProvider call(int plantId) =>
      PlantDetailProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantDetailProvider';
}

/// История ухода (`GET /plants/{id}/history?limit=10`, scope chat).
/// Записи приходят отсортированными backend; клиент порядок не меняет.

@ProviderFor(plantHistory)
final plantHistoryProvider = PlantHistoryFamily._();

/// История ухода (`GET /plants/{id}/history?limit=10`, scope chat).
/// Записи приходят отсортированными backend; клиент порядок не меняет.

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
  /// История ухода (`GET /plants/{id}/history?limit=10`, scope chat).
  /// Записи приходят отсортированными backend; клиент порядок не меняет.
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

/// История ухода (`GET /plants/{id}/history?limit=10`, scope chat).
/// Записи приходят отсортированными backend; клиент порядок не меняет.

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

  /// История ухода (`GET /plants/{id}/history?limit=10`, scope chat).
  /// Записи приходят отсортированными backend; клиент порядок не меняет.

  PlantHistoryProvider call(int plantId) =>
      PlantHistoryProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantHistoryProvider';
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
