// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер таймлайна истории с накоплением страниц и клиентским фильтром.
///
/// `build` грузит первую страницу (`offset = 0`, `limit = 50`). [loadMore]
/// дотягивает следующие и аппендит. [setFilter] переключает клиентский фильтр
/// по типу (backend параметра типа не имеет — фильтр локальный по загруженным,
/// поэтому при незавершённой пагинации он неполон, см. BACKEND-GAPS G29).

@ProviderFor(CareHistoryController)
final careHistoryControllerProvider = CareHistoryControllerFamily._();

/// Контроллер таймлайна истории с накоплением страниц и клиентским фильтром.
///
/// `build` грузит первую страницу (`offset = 0`, `limit = 50`). [loadMore]
/// дотягивает следующие и аппендит. [setFilter] переключает клиентский фильтр
/// по типу (backend параметра типа не имеет — фильтр локальный по загруженным,
/// поэтому при незавершённой пагинации он неполон, см. BACKEND-GAPS G29).
final class CareHistoryControllerProvider
    extends $AsyncNotifierProvider<CareHistoryController, CareHistoryState> {
  /// Контроллер таймлайна истории с накоплением страниц и клиентским фильтром.
  ///
  /// `build` грузит первую страницу (`offset = 0`, `limit = 50`). [loadMore]
  /// дотягивает следующие и аппендит. [setFilter] переключает клиентский фильтр
  /// по типу (backend параметра типа не имеет — фильтр локальный по загруженным,
  /// поэтому при незавершённой пагинации он неполон, см. BACKEND-GAPS G29).
  CareHistoryControllerProvider._({
    required CareHistoryControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'careHistoryControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$careHistoryControllerHash();

  @override
  String toString() {
    return r'careHistoryControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CareHistoryController create() => CareHistoryController();

  @override
  bool operator ==(Object other) {
    return other is CareHistoryControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$careHistoryControllerHash() =>
    r'3a26c419330062c11192953fa6fc416cfd38f5f9';

/// Контроллер таймлайна истории с накоплением страниц и клиентским фильтром.
///
/// `build` грузит первую страницу (`offset = 0`, `limit = 50`). [loadMore]
/// дотягивает следующие и аппендит. [setFilter] переключает клиентский фильтр
/// по типу (backend параметра типа не имеет — фильтр локальный по загруженным,
/// поэтому при незавершённой пагинации он неполон, см. BACKEND-GAPS G29).

final class CareHistoryControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CareHistoryController,
          AsyncValue<CareHistoryState>,
          CareHistoryState,
          FutureOr<CareHistoryState>,
          int
        > {
  CareHistoryControllerFamily._()
    : super(
        retry: null,
        name: r'careHistoryControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Контроллер таймлайна истории с накоплением страниц и клиентским фильтром.
  ///
  /// `build` грузит первую страницу (`offset = 0`, `limit = 50`). [loadMore]
  /// дотягивает следующие и аппендит. [setFilter] переключает клиентский фильтр
  /// по типу (backend параметра типа не имеет — фильтр локальный по загруженным,
  /// поэтому при незавершённой пагинации он неполон, см. BACKEND-GAPS G29).

  CareHistoryControllerProvider call(int plantId) =>
      CareHistoryControllerProvider._(argument: plantId, from: this);

  @override
  String toString() => r'careHistoryControllerProvider';
}

/// Контроллер таймлайна истории с накоплением страниц и клиентским фильтром.
///
/// `build` грузит первую страницу (`offset = 0`, `limit = 50`). [loadMore]
/// дотягивает следующие и аппендит. [setFilter] переключает клиентский фильтр
/// по типу (backend параметра типа не имеет — фильтр локальный по загруженным,
/// поэтому при незавершённой пагинации он неполон, см. BACKEND-GAPS G29).

abstract class _$CareHistoryController
    extends $AsyncNotifier<CareHistoryState> {
  late final _$args = ref.$arg as int;
  int get plantId => _$args;

  FutureOr<CareHistoryState> build(int plantId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CareHistoryState>, CareHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CareHistoryState>, CareHistoryState>,
              AsyncValue<CareHistoryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Сводка для шапки (всего / вовремя% / стрик), выведенная из накопленного
/// состояния контроллера и стрика. `null`, пока история ещё грузится/ошибка.
///
/// `onTimePercent` считается по ЗАГРУЖЕННЫМ записям (`loadedCount`), не по
/// `total` — серверного агрегата нет (BACKEND-GAPS G29).

@ProviderFor(careHistorySummary)
final careHistorySummaryProvider = CareHistorySummaryFamily._();

/// Сводка для шапки (всего / вовремя% / стрик), выведенная из накопленного
/// состояния контроллера и стрика. `null`, пока история ещё грузится/ошибка.
///
/// `onTimePercent` считается по ЗАГРУЖЕННЫМ записям (`loadedCount`), не по
/// `total` — серверного агрегата нет (BACKEND-GAPS G29).

final class CareHistorySummaryProvider
    extends
        $FunctionalProvider<
          CareHistorySummary?,
          CareHistorySummary?,
          CareHistorySummary?
        >
    with $Provider<CareHistorySummary?> {
  /// Сводка для шапки (всего / вовремя% / стрик), выведенная из накопленного
  /// состояния контроллера и стрика. `null`, пока история ещё грузится/ошибка.
  ///
  /// `onTimePercent` считается по ЗАГРУЖЕННЫМ записям (`loadedCount`), не по
  /// `total` — серверного агрегата нет (BACKEND-GAPS G29).
  CareHistorySummaryProvider._({
    required CareHistorySummaryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'careHistorySummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$careHistorySummaryHash();

  @override
  String toString() {
    return r'careHistorySummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CareHistorySummary?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CareHistorySummary? create(Ref ref) {
    final argument = this.argument as int;
    return careHistorySummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CareHistorySummary? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CareHistorySummary?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CareHistorySummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$careHistorySummaryHash() =>
    r'0065be1a60bc6adcee74248074d35d02376f4a94';

/// Сводка для шапки (всего / вовремя% / стрик), выведенная из накопленного
/// состояния контроллера и стрика. `null`, пока история ещё грузится/ошибка.
///
/// `onTimePercent` считается по ЗАГРУЖЕННЫМ записям (`loadedCount`), не по
/// `total` — серверного агрегата нет (BACKEND-GAPS G29).

final class CareHistorySummaryFamily extends $Family
    with $FunctionalFamilyOverride<CareHistorySummary?, int> {
  CareHistorySummaryFamily._()
    : super(
        retry: null,
        name: r'careHistorySummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Сводка для шапки (всего / вовремя% / стрик), выведенная из накопленного
  /// состояния контроллера и стрика. `null`, пока история ещё грузится/ошибка.
  ///
  /// `onTimePercent` считается по ЗАГРУЖЕННЫМ записям (`loadedCount`), не по
  /// `total` — серверного агрегата нет (BACKEND-GAPS G29).

  CareHistorySummaryProvider call(int plantId) =>
      CareHistorySummaryProvider._(argument: plantId, from: this);

  @override
  String toString() => r'careHistorySummaryProvider';
}

/// Деталь растения (`GET /plants/{id}`, scope user) — имя в шапку и
/// `createdAt` (маркер появления растения в таймлайне).

@ProviderFor(careHistoryPlant)
final careHistoryPlantProvider = CareHistoryPlantFamily._();

/// Деталь растения (`GET /plants/{id}`, scope user) — имя в шапку и
/// `createdAt` (маркер появления растения в таймлайне).

final class CareHistoryPlantProvider
    extends $FunctionalProvider<AsyncValue<Plant>, Plant, FutureOr<Plant>>
    with $FutureModifier<Plant>, $FutureProvider<Plant> {
  /// Деталь растения (`GET /plants/{id}`, scope user) — имя в шапку и
  /// `createdAt` (маркер появления растения в таймлайне).
  CareHistoryPlantProvider._({
    required CareHistoryPlantFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'careHistoryPlantProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$careHistoryPlantHash();

  @override
  String toString() {
    return r'careHistoryPlantProvider'
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
    return careHistoryPlant(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CareHistoryPlantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$careHistoryPlantHash() => r'1beda896c8d3cbdc5ea3573e060ecd70b75d1913';

/// Деталь растения (`GET /plants/{id}`, scope user) — имя в шапку и
/// `createdAt` (маркер появления растения в таймлайне).

final class CareHistoryPlantFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Plant>, int> {
  CareHistoryPlantFamily._()
    : super(
        retry: null,
        name: r'careHistoryPlantProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Деталь растения (`GET /plants/{id}`, scope user) — имя в шапку и
  /// `createdAt` (маркер появления растения в таймлайне).

  CareHistoryPlantProvider call(int plantId) =>
      CareHistoryPlantProvider._(argument: plantId, from: this);

  @override
  String toString() => r'careHistoryPlantProvider';
}

/// Стрик растения (`GET /stats/streak`, scope chat).

@ProviderFor(careHistoryStreak)
final careHistoryStreakProvider = CareHistoryStreakFamily._();

/// Стрик растения (`GET /stats/streak`, scope chat).

final class CareHistoryStreakProvider
    extends $FunctionalProvider<AsyncValue<Streak>, Streak, FutureOr<Streak>>
    with $FutureModifier<Streak>, $FutureProvider<Streak> {
  /// Стрик растения (`GET /stats/streak`, scope chat).
  CareHistoryStreakProvider._({
    required CareHistoryStreakFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'careHistoryStreakProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$careHistoryStreakHash();

  @override
  String toString() {
    return r'careHistoryStreakProvider'
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
    return careHistoryStreak(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CareHistoryStreakProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$careHistoryStreakHash() => r'4c3e3ea6ebc34efebfd5238506fa36b8c4528b7d';

/// Стрик растения (`GET /stats/streak`, scope chat).

final class CareHistoryStreakFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Streak>, int> {
  CareHistoryStreakFamily._()
    : super(
        retry: null,
        name: r'careHistoryStreakProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Стрик растения (`GET /stats/streak`, scope chat).

  CareHistoryStreakProvider call(int plantId) =>
      CareHistoryStreakProvider._(argument: plantId, from: this);

  @override
  String toString() => r'careHistoryStreakProvider';
}
