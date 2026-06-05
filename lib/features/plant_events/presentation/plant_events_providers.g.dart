// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_events_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер ленты событий с накоплением страниц.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [addEvent] оптимистично вставляет событие в начало и
/// перечитывает первую страницу для синхронизации с источником (паттерн
/// `CareHistoryController` + оптимистичное добавление).

@ProviderFor(PlantEventsController)
final plantEventsControllerProvider = PlantEventsControllerFamily._();

/// Контроллер ленты событий с накоплением страниц.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [addEvent] оптимистично вставляет событие в начало и
/// перечитывает первую страницу для синхронизации с источником (паттерн
/// `CareHistoryController` + оптимистичное добавление).
final class PlantEventsControllerProvider
    extends $AsyncNotifierProvider<PlantEventsController, PlantEventsState> {
  /// Контроллер ленты событий с накоплением страниц.
  ///
  /// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
  /// следующие и аппендит. [addEvent] оптимистично вставляет событие в начало и
  /// перечитывает первую страницу для синхронизации с источником (паттерн
  /// `CareHistoryController` + оптимистичное добавление).
  PlantEventsControllerProvider._({
    required PlantEventsControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantEventsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantEventsControllerHash();

  @override
  String toString() {
    return r'plantEventsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlantEventsController create() => PlantEventsController();

  @override
  bool operator ==(Object other) {
    return other is PlantEventsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantEventsControllerHash() =>
    r'8cdbb00042dedc16e84ae0d2afbaa3f3fbf14cb2';

/// Контроллер ленты событий с накоплением страниц.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [addEvent] оптимистично вставляет событие в начало и
/// перечитывает первую страницу для синхронизации с источником (паттерн
/// `CareHistoryController` + оптимистичное добавление).

final class PlantEventsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PlantEventsController,
          AsyncValue<PlantEventsState>,
          PlantEventsState,
          FutureOr<PlantEventsState>,
          int
        > {
  PlantEventsControllerFamily._()
    : super(
        retry: null,
        name: r'plantEventsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Контроллер ленты событий с накоплением страниц.
  ///
  /// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
  /// следующие и аппендит. [addEvent] оптимистично вставляет событие в начало и
  /// перечитывает первую страницу для синхронизации с источником (паттерн
  /// `CareHistoryController` + оптимистичное добавление).

  PlantEventsControllerProvider call(int plantId) =>
      PlantEventsControllerProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantEventsControllerProvider';
}

/// Контроллер ленты событий с накоплением страниц.
///
/// `build` грузит первую страницу (`offset = 0`). [loadMore] дотягивает
/// следующие и аппендит. [addEvent] оптимистично вставляет событие в начало и
/// перечитывает первую страницу для синхронизации с источником (паттерн
/// `CareHistoryController` + оптимистичное добавление).

abstract class _$PlantEventsController
    extends $AsyncNotifier<PlantEventsState> {
  late final _$args = ref.$arg as int;
  int get plantId => _$args;

  FutureOr<PlantEventsState> build(int plantId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlantEventsState>, PlantEventsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlantEventsState>, PlantEventsState>,
              AsyncValue<PlantEventsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Последние события для секции в карточке растения (02). Лёгкий read-only
/// провайдер: грузит первую страницу и отдаёт первые [_recentLimit] событий.

@ProviderFor(recentPlantEvents)
final recentPlantEventsProvider = RecentPlantEventsFamily._();

/// Последние события для секции в карточке растения (02). Лёгкий read-only
/// провайдер: грузит первую страницу и отдаёт первые [_recentLimit] событий.

final class RecentPlantEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlantEvent>>,
          List<PlantEvent>,
          FutureOr<List<PlantEvent>>
        >
    with $FutureModifier<List<PlantEvent>>, $FutureProvider<List<PlantEvent>> {
  /// Последние события для секции в карточке растения (02). Лёгкий read-only
  /// провайдер: грузит первую страницу и отдаёт первые [_recentLimit] событий.
  RecentPlantEventsProvider._({
    required RecentPlantEventsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recentPlantEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recentPlantEventsHash();

  @override
  String toString() {
    return r'recentPlantEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PlantEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlantEvent>> create(Ref ref) {
    final argument = this.argument as int;
    return recentPlantEvents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentPlantEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recentPlantEventsHash() => r'01491262a56e08524add70eb0411d8c6fd2e37d4';

/// Последние события для секции в карточке растения (02). Лёгкий read-only
/// провайдер: грузит первую страницу и отдаёт первые [_recentLimit] событий.

final class RecentPlantEventsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PlantEvent>>, int> {
  RecentPlantEventsFamily._()
    : super(
        retry: null,
        name: r'recentPlantEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Последние события для секции в карточке растения (02). Лёгкий read-only
  /// провайдер: грузит первую страницу и отдаёт первые [_recentLimit] событий.

  RecentPlantEventsProvider call(int plantId) =>
      RecentPlantEventsProvider._(argument: plantId, from: this);

  @override
  String toString() => r'recentPlantEventsProvider';
}
