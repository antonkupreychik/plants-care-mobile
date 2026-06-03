// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_schedule_day_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Выбранный день недельного agenda-селектора экрана 11 «График».
///
/// Хранит локальную полночь выбранного дня. Старт — сегодня, если оно попадает
/// в текущую неделю (`clockProvider`, не `DateTime.now()` напрямую — FLUTTER.md
/// «Время»), иначе понедельник недели. Зависит от [scheduleWeekStartProvider]:
/// при листании недели выбор сбрасывается на первый день новой недели (или на
/// «сегодня», если оно туда попало) — иначе селектор показал бы день не из
/// видимой недели.
///
/// Контракт для UI: `ref.watch(selectedScheduleDayProvider)` → `DateTime`
/// (локальная полночь). Этот день — ключ для деривации списка задач дня.

@ProviderFor(SelectedScheduleDay)
final selectedScheduleDayProvider = SelectedScheduleDayProvider._();

/// Выбранный день недельного agenda-селектора экрана 11 «График».
///
/// Хранит локальную полночь выбранного дня. Старт — сегодня, если оно попадает
/// в текущую неделю (`clockProvider`, не `DateTime.now()` напрямую — FLUTTER.md
/// «Время»), иначе понедельник недели. Зависит от [scheduleWeekStartProvider]:
/// при листании недели выбор сбрасывается на первый день новой недели (или на
/// «сегодня», если оно туда попало) — иначе селектор показал бы день не из
/// видимой недели.
///
/// Контракт для UI: `ref.watch(selectedScheduleDayProvider)` → `DateTime`
/// (локальная полночь). Этот день — ключ для деривации списка задач дня.
final class SelectedScheduleDayProvider
    extends $NotifierProvider<SelectedScheduleDay, DateTime> {
  /// Выбранный день недельного agenda-селектора экрана 11 «График».
  ///
  /// Хранит локальную полночь выбранного дня. Старт — сегодня, если оно попадает
  /// в текущую неделю (`clockProvider`, не `DateTime.now()` напрямую — FLUTTER.md
  /// «Время»), иначе понедельник недели. Зависит от [scheduleWeekStartProvider]:
  /// при листании недели выбор сбрасывается на первый день новой недели (или на
  /// «сегодня», если оно туда попало) — иначе селектор показал бы день не из
  /// видимой недели.
  ///
  /// Контракт для UI: `ref.watch(selectedScheduleDayProvider)` → `DateTime`
  /// (локальная полночь). Этот день — ключ для деривации списка задач дня.
  SelectedScheduleDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedScheduleDayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedScheduleDayHash();

  @$internal
  @override
  SelectedScheduleDay create() => SelectedScheduleDay();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedScheduleDayHash() =>
    r'dd3e0b706036076ae93a799e8f5319a758b3fdaf';

/// Выбранный день недельного agenda-селектора экрана 11 «График».
///
/// Хранит локальную полночь выбранного дня. Старт — сегодня, если оно попадает
/// в текущую неделю (`clockProvider`, не `DateTime.now()` напрямую — FLUTTER.md
/// «Время»), иначе понедельник недели. Зависит от [scheduleWeekStartProvider]:
/// при листании недели выбор сбрасывается на первый день новой недели (или на
/// «сегодня», если оно туда попало) — иначе селектор показал бы день не из
/// видимой недели.
///
/// Контракт для UI: `ref.watch(selectedScheduleDayProvider)` → `DateTime`
/// (локальная полночь). Этот день — ключ для деривации списка задач дня.

abstract class _$SelectedScheduleDay extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
