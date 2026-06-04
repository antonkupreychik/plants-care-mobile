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

/// Список типов ухода, которые включены у данного растения.
///
/// Загружает расписания (`GET /plants/{id}/schedules`) и возвращает только
/// те [CareEventKind], у которых `enabled: true`. [CareEventKind.unknown]
/// (SOIL_CHECK и нераспознанные типы) исключается — REST не принимает.
///
/// При ошибке загрузки деградирует на все три типа, чтобы не блокировать
/// отметку ухода. Пустой enabled-список (все выключены) тоже даёт fallback.

@ProviderFor(enabledCareKinds)
final enabledCareKindsProvider = EnabledCareKindsFamily._();

/// Список типов ухода, которые включены у данного растения.
///
/// Загружает расписания (`GET /plants/{id}/schedules`) и возвращает только
/// те [CareEventKind], у которых `enabled: true`. [CareEventKind.unknown]
/// (SOIL_CHECK и нераспознанные типы) исключается — REST не принимает.
///
/// При ошибке загрузки деградирует на все три типа, чтобы не блокировать
/// отметку ухода. Пустой enabled-список (все выключены) тоже даёт fallback.

final class EnabledCareKindsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CareEventKind>>,
          List<CareEventKind>,
          FutureOr<List<CareEventKind>>
        >
    with
        $FutureModifier<List<CareEventKind>>,
        $FutureProvider<List<CareEventKind>> {
  /// Список типов ухода, которые включены у данного растения.
  ///
  /// Загружает расписания (`GET /plants/{id}/schedules`) и возвращает только
  /// те [CareEventKind], у которых `enabled: true`. [CareEventKind.unknown]
  /// (SOIL_CHECK и нераспознанные типы) исключается — REST не принимает.
  ///
  /// При ошибке загрузки деградирует на все три типа, чтобы не блокировать
  /// отметку ухода. Пустой enabled-список (все выключены) тоже даёт fallback.
  EnabledCareKindsProvider._({
    required EnabledCareKindsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'enabledCareKindsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$enabledCareKindsHash();

  @override
  String toString() {
    return r'enabledCareKindsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CareEventKind>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CareEventKind>> create(Ref ref) {
    final argument = this.argument as int;
    return enabledCareKinds(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EnabledCareKindsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$enabledCareKindsHash() => r'e1123d809ba394d98069f1c2641f64718b92ce92';

/// Список типов ухода, которые включены у данного растения.
///
/// Загружает расписания (`GET /plants/{id}/schedules`) и возвращает только
/// те [CareEventKind], у которых `enabled: true`. [CareEventKind.unknown]
/// (SOIL_CHECK и нераспознанные типы) исключается — REST не принимает.
///
/// При ошибке загрузки деградирует на все три типа, чтобы не блокировать
/// отметку ухода. Пустой enabled-список (все выключены) тоже даёт fallback.

final class EnabledCareKindsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CareEventKind>>, int> {
  EnabledCareKindsFamily._()
    : super(
        retry: null,
        name: r'enabledCareKindsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Список типов ухода, которые включены у данного растения.
  ///
  /// Загружает расписания (`GET /plants/{id}/schedules`) и возвращает только
  /// те [CareEventKind], у которых `enabled: true`. [CareEventKind.unknown]
  /// (SOIL_CHECK и нераспознанные типы) исключается — REST не принимает.
  ///
  /// При ошибке загрузки деградирует на все три типа, чтобы не блокировать
  /// отметку ухода. Пустой enabled-список (все выключены) тоже даёт fallback.

  EnabledCareKindsProvider call(int plantId) =>
      EnabledCareKindsProvider._(argument: plantId, from: this);

  @override
  String toString() => r'enabledCareKindsProvider';
}
