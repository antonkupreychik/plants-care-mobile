// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_week_start_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Навигация по неделям экрана «График» (11): хранит понедельник выбранной
/// недели (локальная полночь).
///
/// Старт — понедельник текущей недели, посчитанный из `clockProvider` (в TZ
/// пользователя), а не из `DateTime.now()` напрямую (FLUTTER.md «Время»;
/// тестируется через `FakeClock`). [nextWeek]/[previousWeek] двигают на ±7 дней;
/// жёстких границ листания нет (каждая неделя — отдельный 7-дневный запрос,
/// лимит 60 дней не достигается).
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekStartProvider)` → `DateTime`
/// (понедельник, локальная полночь). Этот же `DateTime` передаётся как ключ
/// в `scheduleWeekProvider(weekStart)`.

@ProviderFor(ScheduleWeekStart)
final scheduleWeekStartProvider = ScheduleWeekStartProvider._();

/// Навигация по неделям экрана «График» (11): хранит понедельник выбранной
/// недели (локальная полночь).
///
/// Старт — понедельник текущей недели, посчитанный из `clockProvider` (в TZ
/// пользователя), а не из `DateTime.now()` напрямую (FLUTTER.md «Время»;
/// тестируется через `FakeClock`). [nextWeek]/[previousWeek] двигают на ±7 дней;
/// жёстких границ листания нет (каждая неделя — отдельный 7-дневный запрос,
/// лимит 60 дней не достигается).
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekStartProvider)` → `DateTime`
/// (понедельник, локальная полночь). Этот же `DateTime` передаётся как ключ
/// в `scheduleWeekProvider(weekStart)`.
final class ScheduleWeekStartProvider
    extends $NotifierProvider<ScheduleWeekStart, DateTime> {
  /// Навигация по неделям экрана «График» (11): хранит понедельник выбранной
  /// недели (локальная полночь).
  ///
  /// Старт — понедельник текущей недели, посчитанный из `clockProvider` (в TZ
  /// пользователя), а не из `DateTime.now()` напрямую (FLUTTER.md «Время»;
  /// тестируется через `FakeClock`). [nextWeek]/[previousWeek] двигают на ±7 дней;
  /// жёстких границ листания нет (каждая неделя — отдельный 7-дневный запрос,
  /// лимит 60 дней не достигается).
  ///
  /// Контракт для ui-builder: `ref.watch(scheduleWeekStartProvider)` → `DateTime`
  /// (понедельник, локальная полночь). Этот же `DateTime` передаётся как ключ
  /// в `scheduleWeekProvider(weekStart)`.
  ScheduleWeekStartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleWeekStartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleWeekStartHash();

  @$internal
  @override
  ScheduleWeekStart create() => ScheduleWeekStart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$scheduleWeekStartHash() => r'8463167d781971d5504067c010a989a6de3d359c';

/// Навигация по неделям экрана «График» (11): хранит понедельник выбранной
/// недели (локальная полночь).
///
/// Старт — понедельник текущей недели, посчитанный из `clockProvider` (в TZ
/// пользователя), а не из `DateTime.now()` напрямую (FLUTTER.md «Время»;
/// тестируется через `FakeClock`). [nextWeek]/[previousWeek] двигают на ±7 дней;
/// жёстких границ листания нет (каждая неделя — отдельный 7-дневный запрос,
/// лимит 60 дней не достигается).
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekStartProvider)` → `DateTime`
/// (понедельник, локальная полночь). Этот же `DateTime` передаётся как ключ
/// в `scheduleWeekProvider(weekStart)`.

abstract class _$ScheduleWeekStart extends $Notifier<DateTime> {
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
