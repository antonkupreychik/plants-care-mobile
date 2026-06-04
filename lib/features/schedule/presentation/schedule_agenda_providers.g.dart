// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_agenda_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Список задач выбранного дня (для день-селектора и тела agenda).
///
/// Деривация поверх загруженной недели ([scheduleWeekProvider]) и выбранного
/// дня ([selectedScheduleDayProvider]): возвращает задачи именно этого дня
/// (порядок backend, по `dueAt`). Если день вне недели (рассинхрон) — пустой
/// список.

@ProviderFor(selectedDayTasks)
final selectedDayTasksProvider = SelectedDayTasksProvider._();

/// Список задач выбранного дня (для день-селектора и тела agenda).
///
/// Деривация поверх загруженной недели ([scheduleWeekProvider]) и выбранного
/// дня ([selectedScheduleDayProvider]): возвращает задачи именно этого дня
/// (порядок backend, по `dueAt`). Если день вне недели (рассинхрон) — пустой
/// список.

final class SelectedDayTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CareTask>>,
          List<CareTask>,
          FutureOr<List<CareTask>>
        >
    with $FutureModifier<List<CareTask>>, $FutureProvider<List<CareTask>> {
  /// Список задач выбранного дня (для день-селектора и тела agenda).
  ///
  /// Деривация поверх загруженной недели ([scheduleWeekProvider]) и выбранного
  /// дня ([selectedScheduleDayProvider]): возвращает задачи именно этого дня
  /// (порядок backend, по `dueAt`). Если день вне недели (рассинхрон) — пустой
  /// список.
  SelectedDayTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDayTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDayTasksHash();

  @$internal
  @override
  $FutureProviderElement<List<CareTask>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CareTask>> create(Ref ref) {
    return selectedDayTasks(ref);
  }
}

String _$selectedDayTasksHash() => r'02889ef2fedd7a37f90f477ec19fc04cf4298038';

/// Готовое agenda-представление выбранного дня: секции утро/вечер/сделано +
/// счётчики «X из N готово».
///
/// Чистую деривацию делает [buildScheduleDayView] (тестируется отдельно без
/// Riverpod) — провайдер лишь собирает входы: задачи дня, начало сегодняшнего
/// дня (`clockProvider`, не `DateTime.now()`) и множество оптимистично
/// отмеченных задач ([scheduleMarkControllerProvider]).
///
/// Контракт для UI: `AsyncValue<ScheduleDayView>` (loading / error / data).
/// В `AsyncError` — типизированный `ApiError` (проброшен из недельного
/// провайдера), UI маппит его в текст через `AppLocalizations`.

@ProviderFor(scheduleDayView)
final scheduleDayViewProvider = ScheduleDayViewProvider._();

/// Готовое agenda-представление выбранного дня: секции утро/вечер/сделано +
/// счётчики «X из N готово».
///
/// Чистую деривацию делает [buildScheduleDayView] (тестируется отдельно без
/// Riverpod) — провайдер лишь собирает входы: задачи дня, начало сегодняшнего
/// дня (`clockProvider`, не `DateTime.now()`) и множество оптимистично
/// отмеченных задач ([scheduleMarkControllerProvider]).
///
/// Контракт для UI: `AsyncValue<ScheduleDayView>` (loading / error / data).
/// В `AsyncError` — типизированный `ApiError` (проброшен из недельного
/// провайдера), UI маппит его в текст через `AppLocalizations`.

final class ScheduleDayViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ScheduleDayView>,
          ScheduleDayView,
          FutureOr<ScheduleDayView>
        >
    with $FutureModifier<ScheduleDayView>, $FutureProvider<ScheduleDayView> {
  /// Готовое agenda-представление выбранного дня: секции утро/вечер/сделано +
  /// счётчики «X из N готово».
  ///
  /// Чистую деривацию делает [buildScheduleDayView] (тестируется отдельно без
  /// Riverpod) — провайдер лишь собирает входы: задачи дня, начало сегодняшнего
  /// дня (`clockProvider`, не `DateTime.now()`) и множество оптимистично
  /// отмеченных задач ([scheduleMarkControllerProvider]).
  ///
  /// Контракт для UI: `AsyncValue<ScheduleDayView>` (loading / error / data).
  /// В `AsyncError` — типизированный `ApiError` (проброшен из недельного
  /// провайдера), UI маппит его в текст через `AppLocalizations`.
  ScheduleDayViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleDayViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleDayViewHash();

  @$internal
  @override
  $FutureProviderElement<ScheduleDayView> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ScheduleDayView> create(Ref ref) {
    return scheduleDayView(ref);
  }
}

String _$scheduleDayViewHash() => r'fa2a3850ffb6706b873beee6d22747955e9c4409';
