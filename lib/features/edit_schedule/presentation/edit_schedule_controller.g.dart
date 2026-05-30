// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_schedule_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер экрана «Редактирование расписания ухода» (22). Family по
/// [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editScheduleControllerProvider(plantId)` →
///   `AsyncValue<EditScheduleState>`.
/// - `build` грузит `GET /plants/{id}/schedules` и кладёт результат и в
///   `loaded`, и в `draft` (исходно драфт = загруженному, грязи нет). Ошибка
///   загрузки → `AsyncError(ApiError)`.
/// - чтение состояния: `state.draft` (что рисовать), `state.dirtyTypes` /
///   `state.isDirty` (есть ли несохранённое), `state.saving` (идёт сохранение),
///   `state.saveError` (ошибка последнего `save`).
///
/// Стратегия редактирования — «draft + save dirty on Готово»:
/// - методы [toggle] / [setEvery] / [setAmountMl] / [reset] правят ТОЛЬКО
///   `draft`, в сеть не ходят;
/// - [save] PUT'ит только грязные типы (последовательно). При ошибке любого —
///   общий `saveError`, при этом успешно сохранённые типы фиксируются в
///   `loaded` (НЕ откатываются), грязными остаются только непрошедшие.
///   По полному успеху `loaded = draft`, грязь исчезает.

@ProviderFor(EditScheduleController)
final editScheduleControllerProvider = EditScheduleControllerFamily._();

/// Контроллер экрана «Редактирование расписания ухода» (22). Family по
/// [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editScheduleControllerProvider(plantId)` →
///   `AsyncValue<EditScheduleState>`.
/// - `build` грузит `GET /plants/{id}/schedules` и кладёт результат и в
///   `loaded`, и в `draft` (исходно драфт = загруженному, грязи нет). Ошибка
///   загрузки → `AsyncError(ApiError)`.
/// - чтение состояния: `state.draft` (что рисовать), `state.dirtyTypes` /
///   `state.isDirty` (есть ли несохранённое), `state.saving` (идёт сохранение),
///   `state.saveError` (ошибка последнего `save`).
///
/// Стратегия редактирования — «draft + save dirty on Готово»:
/// - методы [toggle] / [setEvery] / [setAmountMl] / [reset] правят ТОЛЬКО
///   `draft`, в сеть не ходят;
/// - [save] PUT'ит только грязные типы (последовательно). При ошибке любого —
///   общий `saveError`, при этом успешно сохранённые типы фиксируются в
///   `loaded` (НЕ откатываются), грязными остаются только непрошедшие.
///   По полному успеху `loaded = draft`, грязь исчезает.
final class EditScheduleControllerProvider
    extends $AsyncNotifierProvider<EditScheduleController, EditScheduleState> {
  /// Контроллер экрана «Редактирование расписания ухода» (22). Family по
  /// [plantId].
  ///
  /// Контракт для ui-builder:
  /// - провайдер `editScheduleControllerProvider(plantId)` →
  ///   `AsyncValue<EditScheduleState>`.
  /// - `build` грузит `GET /plants/{id}/schedules` и кладёт результат и в
  ///   `loaded`, и в `draft` (исходно драфт = загруженному, грязи нет). Ошибка
  ///   загрузки → `AsyncError(ApiError)`.
  /// - чтение состояния: `state.draft` (что рисовать), `state.dirtyTypes` /
  ///   `state.isDirty` (есть ли несохранённое), `state.saving` (идёт сохранение),
  ///   `state.saveError` (ошибка последнего `save`).
  ///
  /// Стратегия редактирования — «draft + save dirty on Готово»:
  /// - методы [toggle] / [setEvery] / [setAmountMl] / [reset] правят ТОЛЬКО
  ///   `draft`, в сеть не ходят;
  /// - [save] PUT'ит только грязные типы (последовательно). При ошибке любого —
  ///   общий `saveError`, при этом успешно сохранённые типы фиксируются в
  ///   `loaded` (НЕ откатываются), грязными остаются только непрошедшие.
  ///   По полному успеху `loaded = draft`, грязь исчезает.
  EditScheduleControllerProvider._({
    required EditScheduleControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'editScheduleControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editScheduleControllerHash();

  @override
  String toString() {
    return r'editScheduleControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditScheduleController create() => EditScheduleController();

  @override
  bool operator ==(Object other) {
    return other is EditScheduleControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editScheduleControllerHash() =>
    r'08212b919975ea70c4092cfd8ff136f92c7b6152';

/// Контроллер экрана «Редактирование расписания ухода» (22). Family по
/// [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editScheduleControllerProvider(plantId)` →
///   `AsyncValue<EditScheduleState>`.
/// - `build` грузит `GET /plants/{id}/schedules` и кладёт результат и в
///   `loaded`, и в `draft` (исходно драфт = загруженному, грязи нет). Ошибка
///   загрузки → `AsyncError(ApiError)`.
/// - чтение состояния: `state.draft` (что рисовать), `state.dirtyTypes` /
///   `state.isDirty` (есть ли несохранённое), `state.saving` (идёт сохранение),
///   `state.saveError` (ошибка последнего `save`).
///
/// Стратегия редактирования — «draft + save dirty on Готово»:
/// - методы [toggle] / [setEvery] / [setAmountMl] / [reset] правят ТОЛЬКО
///   `draft`, в сеть не ходят;
/// - [save] PUT'ит только грязные типы (последовательно). При ошибке любого —
///   общий `saveError`, при этом успешно сохранённые типы фиксируются в
///   `loaded` (НЕ откатываются), грязными остаются только непрошедшие.
///   По полному успеху `loaded = draft`, грязь исчезает.

final class EditScheduleControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EditScheduleController,
          AsyncValue<EditScheduleState>,
          EditScheduleState,
          FutureOr<EditScheduleState>,
          int
        > {
  EditScheduleControllerFamily._()
    : super(
        retry: null,
        name: r'editScheduleControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Контроллер экрана «Редактирование расписания ухода» (22). Family по
  /// [plantId].
  ///
  /// Контракт для ui-builder:
  /// - провайдер `editScheduleControllerProvider(plantId)` →
  ///   `AsyncValue<EditScheduleState>`.
  /// - `build` грузит `GET /plants/{id}/schedules` и кладёт результат и в
  ///   `loaded`, и в `draft` (исходно драфт = загруженному, грязи нет). Ошибка
  ///   загрузки → `AsyncError(ApiError)`.
  /// - чтение состояния: `state.draft` (что рисовать), `state.dirtyTypes` /
  ///   `state.isDirty` (есть ли несохранённое), `state.saving` (идёт сохранение),
  ///   `state.saveError` (ошибка последнего `save`).
  ///
  /// Стратегия редактирования — «draft + save dirty on Готово»:
  /// - методы [toggle] / [setEvery] / [setAmountMl] / [reset] правят ТОЛЬКО
  ///   `draft`, в сеть не ходят;
  /// - [save] PUT'ит только грязные типы (последовательно). При ошибке любого —
  ///   общий `saveError`, при этом успешно сохранённые типы фиксируются в
  ///   `loaded` (НЕ откатываются), грязными остаются только непрошедшие.
  ///   По полному успеху `loaded = draft`, грязь исчезает.

  EditScheduleControllerProvider call(int plantId) =>
      EditScheduleControllerProvider._(argument: plantId, from: this);

  @override
  String toString() => r'editScheduleControllerProvider';
}

/// Контроллер экрана «Редактирование расписания ухода» (22). Family по
/// [plantId].
///
/// Контракт для ui-builder:
/// - провайдер `editScheduleControllerProvider(plantId)` →
///   `AsyncValue<EditScheduleState>`.
/// - `build` грузит `GET /plants/{id}/schedules` и кладёт результат и в
///   `loaded`, и в `draft` (исходно драфт = загруженному, грязи нет). Ошибка
///   загрузки → `AsyncError(ApiError)`.
/// - чтение состояния: `state.draft` (что рисовать), `state.dirtyTypes` /
///   `state.isDirty` (есть ли несохранённое), `state.saving` (идёт сохранение),
///   `state.saveError` (ошибка последнего `save`).
///
/// Стратегия редактирования — «draft + save dirty on Готово»:
/// - методы [toggle] / [setEvery] / [setAmountMl] / [reset] правят ТОЛЬКО
///   `draft`, в сеть не ходят;
/// - [save] PUT'ит только грязные типы (последовательно). При ошибке любого —
///   общий `saveError`, при этом успешно сохранённые типы фиксируются в
///   `loaded` (НЕ откатываются), грязными остаются только непрошедшие.
///   По полному успеху `loaded = draft`, грязь исчезает.

abstract class _$EditScheduleController
    extends $AsyncNotifier<EditScheduleState> {
  late final _$args = ref.$arg as int;
  int get plantId => _$args;

  FutureOr<EditScheduleState> build(int plantId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<EditScheduleState>, EditScheduleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EditScheduleState>, EditScheduleState>,
              AsyncValue<EditScheduleState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
