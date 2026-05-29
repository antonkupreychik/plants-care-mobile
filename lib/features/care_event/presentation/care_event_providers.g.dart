// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка use case [LogCareEvent] (MADR-004: граф провайдеров = DI).
/// Notifier зовёт use case, а не репозиторий напрямую (MADR-002).

@ProviderFor(logCareEvent)
final logCareEventProvider = LogCareEventProvider._();

/// DI-точка use case [LogCareEvent] (MADR-004: граф провайдеров = DI).
/// Notifier зовёт use case, а не репозиторий напрямую (MADR-002).

final class LogCareEventProvider
    extends $FunctionalProvider<LogCareEvent, LogCareEvent, LogCareEvent>
    with $Provider<LogCareEvent> {
  /// DI-точка use case [LogCareEvent] (MADR-004: граф провайдеров = DI).
  /// Notifier зовёт use case, а не репозиторий напрямую (MADR-002).
  LogCareEventProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logCareEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logCareEventHash();

  @$internal
  @override
  $ProviderElement<LogCareEvent> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogCareEvent create(Ref ref) {
    return logCareEvent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogCareEvent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogCareEvent>(value),
    );
  }
}

String _$logCareEventHash() => r'a79ed8094151b26eb6ef077e00b396a7b18e0212';

/// DI-точка use case [CountPriorCareEvents] — детекция «первого ухода»
/// (экран 33). Notifier зовёт use case, а не репозиторий напрямую (MADR-002).

@ProviderFor(countPriorCareEvents)
final countPriorCareEventsProvider = CountPriorCareEventsProvider._();

/// DI-точка use case [CountPriorCareEvents] — детекция «первого ухода»
/// (экран 33). Notifier зовёт use case, а не репозиторий напрямую (MADR-002).

final class CountPriorCareEventsProvider
    extends
        $FunctionalProvider<
          CountPriorCareEvents,
          CountPriorCareEvents,
          CountPriorCareEvents
        >
    with $Provider<CountPriorCareEvents> {
  /// DI-точка use case [CountPriorCareEvents] — детекция «первого ухода»
  /// (экран 33). Notifier зовёт use case, а не репозиторий напрямую (MADR-002).
  CountPriorCareEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countPriorCareEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countPriorCareEventsHash();

  @$internal
  @override
  $ProviderElement<CountPriorCareEvents> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CountPriorCareEvents create(Ref ref) {
    return countPriorCareEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountPriorCareEvents value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountPriorCareEvents>(value),
    );
  }
}

String _$countPriorCareEventsHash() =>
    r'001dc7962adcb61f95b935708ba4b50680425219';
