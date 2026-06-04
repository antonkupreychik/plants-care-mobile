// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_plant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер экрана «Редактировать растение». Family по [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editPlantControllerProvider(plantId)` →
///   `AsyncValue<EditPlantState>`.
/// - `build` грузит `GET /plants/{id}` и инициализирует черновик из текущих
///   данных растения. Ошибка загрузки → `AsyncError(ApiError)`.
/// - методы [setName], [setNotes], [setLocation], [setSpecies] — обновляют
///   драфт, не ходят в сеть.
/// - [submit] — отправляет `PUT /plants/{id}`, при успехе инвалидирует
///   провайдеры деталей растения и главного списка, ставит `success`.
///
/// После [submit] с успехом вызывающий экран должен:
/// 1. Поймать `submitStatus == SubmitStatus.success` и вызвать `pop()`.
/// 2. Инвалидация [plantDetailProvider] и [homePlantsProvider] уже сделана
///    контроллером — перезагрузка данных произойдёт автоматически.

@ProviderFor(EditPlantController)
final editPlantControllerProvider = EditPlantControllerFamily._();

/// Контроллер экрана «Редактировать растение». Family по [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editPlantControllerProvider(plantId)` →
///   `AsyncValue<EditPlantState>`.
/// - `build` грузит `GET /plants/{id}` и инициализирует черновик из текущих
///   данных растения. Ошибка загрузки → `AsyncError(ApiError)`.
/// - методы [setName], [setNotes], [setLocation], [setSpecies] — обновляют
///   драфт, не ходят в сеть.
/// - [submit] — отправляет `PUT /plants/{id}`, при успехе инвалидирует
///   провайдеры деталей растения и главного списка, ставит `success`.
///
/// После [submit] с успехом вызывающий экран должен:
/// 1. Поймать `submitStatus == SubmitStatus.success` и вызвать `pop()`.
/// 2. Инвалидация [plantDetailProvider] и [homePlantsProvider] уже сделана
///    контроллером — перезагрузка данных произойдёт автоматически.
final class EditPlantControllerProvider
    extends $AsyncNotifierProvider<EditPlantController, EditPlantState> {
  /// Контроллер экрана «Редактировать растение». Family по [plantId].
  ///
  /// Контракт для ui-builder:
  /// - провайдер `editPlantControllerProvider(plantId)` →
  ///   `AsyncValue<EditPlantState>`.
  /// - `build` грузит `GET /plants/{id}` и инициализирует черновик из текущих
  ///   данных растения. Ошибка загрузки → `AsyncError(ApiError)`.
  /// - методы [setName], [setNotes], [setLocation], [setSpecies] — обновляют
  ///   драфт, не ходят в сеть.
  /// - [submit] — отправляет `PUT /plants/{id}`, при успехе инвалидирует
  ///   провайдеры деталей растения и главного списка, ставит `success`.
  ///
  /// После [submit] с успехом вызывающий экран должен:
  /// 1. Поймать `submitStatus == SubmitStatus.success` и вызвать `pop()`.
  /// 2. Инвалидация [plantDetailProvider] и [homePlantsProvider] уже сделана
  ///    контроллером — перезагрузка данных произойдёт автоматически.
  EditPlantControllerProvider._({
    required EditPlantControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'editPlantControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editPlantControllerHash();

  @override
  String toString() {
    return r'editPlantControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditPlantController create() => EditPlantController();

  @override
  bool operator ==(Object other) {
    return other is EditPlantControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editPlantControllerHash() =>
    r'97c816ac9945f6d2161f1cb4a2af6f06a3beaafe';

/// Контроллер экрана «Редактировать растение». Family по [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editPlantControllerProvider(plantId)` →
///   `AsyncValue<EditPlantState>`.
/// - `build` грузит `GET /plants/{id}` и инициализирует черновик из текущих
///   данных растения. Ошибка загрузки → `AsyncError(ApiError)`.
/// - методы [setName], [setNotes], [setLocation], [setSpecies] — обновляют
///   драфт, не ходят в сеть.
/// - [submit] — отправляет `PUT /plants/{id}`, при успехе инвалидирует
///   провайдеры деталей растения и главного списка, ставит `success`.
///
/// После [submit] с успехом вызывающий экран должен:
/// 1. Поймать `submitStatus == SubmitStatus.success` и вызвать `pop()`.
/// 2. Инвалидация [plantDetailProvider] и [homePlantsProvider] уже сделана
///    контроллером — перезагрузка данных произойдёт автоматически.

final class EditPlantControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EditPlantController,
          AsyncValue<EditPlantState>,
          EditPlantState,
          FutureOr<EditPlantState>,
          int
        > {
  EditPlantControllerFamily._()
    : super(
        retry: null,
        name: r'editPlantControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Контроллер экрана «Редактировать растение». Family по [plantId].
  ///
  /// Контракт для ui-builder:
  /// - провайдер `editPlantControllerProvider(plantId)` →
  ///   `AsyncValue<EditPlantState>`.
  /// - `build` грузит `GET /plants/{id}` и инициализирует черновик из текущих
  ///   данных растения. Ошибка загрузки → `AsyncError(ApiError)`.
  /// - методы [setName], [setNotes], [setLocation], [setSpecies] — обновляют
  ///   драфт, не ходят в сеть.
  /// - [submit] — отправляет `PUT /plants/{id}`, при успехе инвалидирует
  ///   провайдеры деталей растения и главного списка, ставит `success`.
  ///
  /// После [submit] с успехом вызывающий экран должен:
  /// 1. Поймать `submitStatus == SubmitStatus.success` и вызвать `pop()`.
  /// 2. Инвалидация [plantDetailProvider] и [homePlantsProvider] уже сделана
  ///    контроллером — перезагрузка данных произойдёт автоматически.

  EditPlantControllerProvider call(int plantId) =>
      EditPlantControllerProvider._(argument: plantId, from: this);

  @override
  String toString() => r'editPlantControllerProvider';
}

/// Контроллер экрана «Редактировать растение». Family по [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editPlantControllerProvider(plantId)` →
///   `AsyncValue<EditPlantState>`.
/// - `build` грузит `GET /plants/{id}` и инициализирует черновик из текущих
///   данных растения. Ошибка загрузки → `AsyncError(ApiError)`.
/// - методы [setName], [setNotes], [setLocation], [setSpecies] — обновляют
///   драфт, не ходят в сеть.
/// - [submit] — отправляет `PUT /plants/{id}`, при успехе инвалидирует
///   провайдеры деталей растения и главного списка, ставит `success`.
///
/// После [submit] с успехом вызывающий экран должен:
/// 1. Поймать `submitStatus == SubmitStatus.success` и вызвать `pop()`.
/// 2. Инвалидация [plantDetailProvider] и [homePlantsProvider] уже сделана
///    контроллером — перезагрузка данных произойдёт автоматически.

abstract class _$EditPlantController extends $AsyncNotifier<EditPlantState> {
  late final _$args = ref.$arg as int;
  int get plantId => _$args;

  FutureOr<EditPlantState> build(int plantId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EditPlantState>, EditPlantState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EditPlantState>, EditPlantState>,
              AsyncValue<EditPlantState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
