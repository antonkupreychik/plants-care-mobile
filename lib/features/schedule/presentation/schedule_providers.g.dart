// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана «График» (11).
///
/// Провайдер-семейство по `weekStart`: каждая неделя грузится и кешируется
/// независимо, поэтому листание назад/вперёд переиспользует уже загруженные
/// недели, а `ref.invalidate(scheduleWeekProvider(weekStart))` обновляет только
/// одну неделю (например, после `POST /care-events`). Текущий `weekStart`
/// поставляет `scheduleWeekStartProvider`.
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekProvider(weekStart))`
/// → `AsyncValue<ScheduleWeek>` (loading / error / data). В `AsyncError` лежит
/// типизированный [ApiError] (см. [_unwrap]) — UI маппит его в текст через
/// `AppLocalizations`.
///
/// `keepAlive: false` (дефолт): неделя без активных слушателей выгружается из
/// кеша, чтобы не держать весь горизонт листания в памяти.

@ProviderFor(scheduleWeek)
final scheduleWeekProvider = ScheduleWeekFamily._();

/// State-слой экрана «График» (11).
///
/// Провайдер-семейство по `weekStart`: каждая неделя грузится и кешируется
/// независимо, поэтому листание назад/вперёд переиспользует уже загруженные
/// недели, а `ref.invalidate(scheduleWeekProvider(weekStart))` обновляет только
/// одну неделю (например, после `POST /care-events`). Текущий `weekStart`
/// поставляет `scheduleWeekStartProvider`.
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekProvider(weekStart))`
/// → `AsyncValue<ScheduleWeek>` (loading / error / data). В `AsyncError` лежит
/// типизированный [ApiError] (см. [_unwrap]) — UI маппит его в текст через
/// `AppLocalizations`.
///
/// `keepAlive: false` (дефолт): неделя без активных слушателей выгружается из
/// кеша, чтобы не держать весь горизонт листания в памяти.

final class ScheduleWeekProvider
    extends
        $FunctionalProvider<
          AsyncValue<ScheduleWeek>,
          ScheduleWeek,
          FutureOr<ScheduleWeek>
        >
    with $FutureModifier<ScheduleWeek>, $FutureProvider<ScheduleWeek> {
  /// State-слой экрана «График» (11).
  ///
  /// Провайдер-семейство по `weekStart`: каждая неделя грузится и кешируется
  /// независимо, поэтому листание назад/вперёд переиспользует уже загруженные
  /// недели, а `ref.invalidate(scheduleWeekProvider(weekStart))` обновляет только
  /// одну неделю (например, после `POST /care-events`). Текущий `weekStart`
  /// поставляет `scheduleWeekStartProvider`.
  ///
  /// Контракт для ui-builder: `ref.watch(scheduleWeekProvider(weekStart))`
  /// → `AsyncValue<ScheduleWeek>` (loading / error / data). В `AsyncError` лежит
  /// типизированный [ApiError] (см. [_unwrap]) — UI маппит его в текст через
  /// `AppLocalizations`.
  ///
  /// `keepAlive: false` (дефолт): неделя без активных слушателей выгружается из
  /// кеша, чтобы не держать весь горизонт листания в памяти.
  ScheduleWeekProvider._({
    required ScheduleWeekFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'scheduleWeekProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$scheduleWeekHash();

  @override
  String toString() {
    return r'scheduleWeekProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ScheduleWeek> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ScheduleWeek> create(Ref ref) {
    final argument = this.argument as DateTime;
    return scheduleWeek(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleWeekProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scheduleWeekHash() => r'7633e3961bc48f09feb3862fc4915b0ccb4d7e46';

/// State-слой экрана «График» (11).
///
/// Провайдер-семейство по `weekStart`: каждая неделя грузится и кешируется
/// независимо, поэтому листание назад/вперёд переиспользует уже загруженные
/// недели, а `ref.invalidate(scheduleWeekProvider(weekStart))` обновляет только
/// одну неделю (например, после `POST /care-events`). Текущий `weekStart`
/// поставляет `scheduleWeekStartProvider`.
///
/// Контракт для ui-builder: `ref.watch(scheduleWeekProvider(weekStart))`
/// → `AsyncValue<ScheduleWeek>` (loading / error / data). В `AsyncError` лежит
/// типизированный [ApiError] (см. [_unwrap]) — UI маппит его в текст через
/// `AppLocalizations`.
///
/// `keepAlive: false` (дефолт): неделя без активных слушателей выгружается из
/// кеша, чтобы не держать весь горизонт листания в памяти.

final class ScheduleWeekFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ScheduleWeek>, DateTime> {
  ScheduleWeekFamily._()
    : super(
        retry: null,
        name: r'scheduleWeekProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State-слой экрана «График» (11).
  ///
  /// Провайдер-семейство по `weekStart`: каждая неделя грузится и кешируется
  /// независимо, поэтому листание назад/вперёд переиспользует уже загруженные
  /// недели, а `ref.invalidate(scheduleWeekProvider(weekStart))` обновляет только
  /// одну неделю (например, после `POST /care-events`). Текущий `weekStart`
  /// поставляет `scheduleWeekStartProvider`.
  ///
  /// Контракт для ui-builder: `ref.watch(scheduleWeekProvider(weekStart))`
  /// → `AsyncValue<ScheduleWeek>` (loading / error / data). В `AsyncError` лежит
  /// типизированный [ApiError] (см. [_unwrap]) — UI маппит его в текст через
  /// `AppLocalizations`.
  ///
  /// `keepAlive: false` (дефолт): неделя без активных слушателей выгружается из
  /// кеша, чтобы не держать весь горизонт листания в памяти.

  ScheduleWeekProvider call(DateTime weekStart) =>
      ScheduleWeekProvider._(argument: weekStart, from: this);

  @override
  String toString() => r'scheduleWeekProvider';
}
