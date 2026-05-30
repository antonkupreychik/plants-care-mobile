// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_care_due_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Read-only список расписаний растения для экрана 33 «Успех первого ухода»
/// (`GET /plants/{id}/schedules`, user-scoped внутри репозитория, G19).
///
/// Лёгкий потребительский провайдер: экран 33 лишь читает расписания ради
/// `nextDueAt` и НЕ редактирует их, поэтому он не тянет `EditScheduleController`
/// с его draft/dirty/save (тот заточен под экран 22). Реюз репозитория —
/// [editScheduleRepositoryProvider], свой код запроса не дублируем.
///
/// Разворачиваем [Result] репозитория (MADR-011) в [AsyncValue]:
/// - `Success` → данные;
/// - `Failure` → пробрасываем в `AsyncError` (экран 33 деградирует мягко: уход
///   уже записан, счётчик просто не показываем).

@ProviderFor(plantSchedules)
final plantSchedulesProvider = PlantSchedulesFamily._();

/// Read-only список расписаний растения для экрана 33 «Успех первого ухода»
/// (`GET /plants/{id}/schedules`, user-scoped внутри репозитория, G19).
///
/// Лёгкий потребительский провайдер: экран 33 лишь читает расписания ради
/// `nextDueAt` и НЕ редактирует их, поэтому он не тянет `EditScheduleController`
/// с его draft/dirty/save (тот заточен под экран 22). Реюз репозитория —
/// [editScheduleRepositoryProvider], свой код запроса не дублируем.
///
/// Разворачиваем [Result] репозитория (MADR-011) в [AsyncValue]:
/// - `Success` → данные;
/// - `Failure` → пробрасываем в `AsyncError` (экран 33 деградирует мягко: уход
///   уже записан, счётчик просто не показываем).

final class PlantSchedulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlantCareSchedule>>,
          List<PlantCareSchedule>,
          FutureOr<List<PlantCareSchedule>>
        >
    with
        $FutureModifier<List<PlantCareSchedule>>,
        $FutureProvider<List<PlantCareSchedule>> {
  /// Read-only список расписаний растения для экрана 33 «Успех первого ухода»
  /// (`GET /plants/{id}/schedules`, user-scoped внутри репозитория, G19).
  ///
  /// Лёгкий потребительский провайдер: экран 33 лишь читает расписания ради
  /// `nextDueAt` и НЕ редактирует их, поэтому он не тянет `EditScheduleController`
  /// с его draft/dirty/save (тот заточен под экран 22). Реюз репозитория —
  /// [editScheduleRepositoryProvider], свой код запроса не дублируем.
  ///
  /// Разворачиваем [Result] репозитория (MADR-011) в [AsyncValue]:
  /// - `Success` → данные;
  /// - `Failure` → пробрасываем в `AsyncError` (экран 33 деградирует мягко: уход
  ///   уже записан, счётчик просто не показываем).
  PlantSchedulesProvider._({
    required PlantSchedulesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantSchedulesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantSchedulesHash();

  @override
  String toString() {
    return r'plantSchedulesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PlantCareSchedule>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlantCareSchedule>> create(Ref ref) {
    final argument = this.argument as int;
    return plantSchedules(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantSchedulesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantSchedulesHash() => r'e0e87114ca0a44d7a7e0ef2fb41fd6a2394334de';

/// Read-only список расписаний растения для экрана 33 «Успех первого ухода»
/// (`GET /plants/{id}/schedules`, user-scoped внутри репозитория, G19).
///
/// Лёгкий потребительский провайдер: экран 33 лишь читает расписания ради
/// `nextDueAt` и НЕ редактирует их, поэтому он не тянет `EditScheduleController`
/// с его draft/dirty/save (тот заточен под экран 22). Реюз репозитория —
/// [editScheduleRepositoryProvider], свой код запроса не дублируем.
///
/// Разворачиваем [Result] репозитория (MADR-011) в [AsyncValue]:
/// - `Success` → данные;
/// - `Failure` → пробрасываем в `AsyncError` (экран 33 деградирует мягко: уход
///   уже записан, счётчик просто не показываем).

final class PlantSchedulesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PlantCareSchedule>>, int> {
  PlantSchedulesFamily._()
    : super(
        retry: null,
        name: r'plantSchedulesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Read-only список расписаний растения для экрана 33 «Успех первого ухода»
  /// (`GET /plants/{id}/schedules`, user-scoped внутри репозитория, G19).
  ///
  /// Лёгкий потребительский провайдер: экран 33 лишь читает расписания ради
  /// `nextDueAt` и НЕ редактирует их, поэтому он не тянет `EditScheduleController`
  /// с его draft/dirty/save (тот заточен под экран 22). Реюз репозитория —
  /// [editScheduleRepositoryProvider], свой код запроса не дублируем.
  ///
  /// Разворачиваем [Result] репозитория (MADR-011) в [AsyncValue]:
  /// - `Success` → данные;
  /// - `Failure` → пробрасываем в `AsyncError` (экран 33 деградирует мягко: уход
  ///   уже записан, счётчик просто не показываем).

  PlantSchedulesProvider call(int plantId) =>
      PlantSchedulesProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantSchedulesProvider';
}

/// Derived-провайдер для футера экрана 33: момент следующего ухода для
/// записанного типа [kind] растения [plantId].
///
/// `AsyncValue<DateTime?>`:
/// - `loading` — пока грузятся расписания;
/// - `data(null)` — расписания не дают срока (выключено / unknown / нет
///   совпадения / `nextDueAt == null`): UI счётчик НЕ показывает;
/// - `data(dateTime)` — UTC-момент; форматирование «через N дн.» делает UI
///   (`nextDueLabel`, относительно инжектируемого Clock-«сейчас»);
/// - `error` — запрос расписаний упал: UI деградирует мягко (счётчик скрыт).

@ProviderFor(nextCareDue)
final nextCareDueProvider = NextCareDueFamily._();

/// Derived-провайдер для футера экрана 33: момент следующего ухода для
/// записанного типа [kind] растения [plantId].
///
/// `AsyncValue<DateTime?>`:
/// - `loading` — пока грузятся расписания;
/// - `data(null)` — расписания не дают срока (выключено / unknown / нет
///   совпадения / `nextDueAt == null`): UI счётчик НЕ показывает;
/// - `data(dateTime)` — UTC-момент; форматирование «через N дн.» делает UI
///   (`nextDueLabel`, относительно инжектируемого Clock-«сейчас»);
/// - `error` — запрос расписаний упал: UI деградирует мягко (счётчик скрыт).

final class NextCareDueProvider
    extends
        $FunctionalProvider<
          AsyncValue<DateTime?>,
          DateTime?,
          FutureOr<DateTime?>
        >
    with $FutureModifier<DateTime?>, $FutureProvider<DateTime?> {
  /// Derived-провайдер для футера экрана 33: момент следующего ухода для
  /// записанного типа [kind] растения [plantId].
  ///
  /// `AsyncValue<DateTime?>`:
  /// - `loading` — пока грузятся расписания;
  /// - `data(null)` — расписания не дают срока (выключено / unknown / нет
  ///   совпадения / `nextDueAt == null`): UI счётчик НЕ показывает;
  /// - `data(dateTime)` — UTC-момент; форматирование «через N дн.» делает UI
  ///   (`nextDueLabel`, относительно инжектируемого Clock-«сейчас»);
  /// - `error` — запрос расписаний упал: UI деградирует мягко (счётчик скрыт).
  NextCareDueProvider._({
    required NextCareDueFamily super.from,
    required ({int plantId, CareEventKind kind}) super.argument,
  }) : super(
         retry: null,
         name: r'nextCareDueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$nextCareDueHash();

  @override
  String toString() {
    return r'nextCareDueProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DateTime?> create(Ref ref) {
    final argument = this.argument as ({int plantId, CareEventKind kind});
    return nextCareDue(ref, plantId: argument.plantId, kind: argument.kind);
  }

  @override
  bool operator ==(Object other) {
    return other is NextCareDueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nextCareDueHash() => r'0496dc72d8855df978a76bffe07d61afabb462c6';

/// Derived-провайдер для футера экрана 33: момент следующего ухода для
/// записанного типа [kind] растения [plantId].
///
/// `AsyncValue<DateTime?>`:
/// - `loading` — пока грузятся расписания;
/// - `data(null)` — расписания не дают срока (выключено / unknown / нет
///   совпадения / `nextDueAt == null`): UI счётчик НЕ показывает;
/// - `data(dateTime)` — UTC-момент; форматирование «через N дн.» делает UI
///   (`nextDueLabel`, относительно инжектируемого Clock-«сейчас»);
/// - `error` — запрос расписаний упал: UI деградирует мягко (счётчик скрыт).

final class NextCareDueFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<DateTime?>,
          ({int plantId, CareEventKind kind})
        > {
  NextCareDueFamily._()
    : super(
        retry: null,
        name: r'nextCareDueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Derived-провайдер для футера экрана 33: момент следующего ухода для
  /// записанного типа [kind] растения [plantId].
  ///
  /// `AsyncValue<DateTime?>`:
  /// - `loading` — пока грузятся расписания;
  /// - `data(null)` — расписания не дают срока (выключено / unknown / нет
  ///   совпадения / `nextDueAt == null`): UI счётчик НЕ показывает;
  /// - `data(dateTime)` — UTC-момент; форматирование «через N дн.» делает UI
  ///   (`nextDueLabel`, относительно инжектируемого Clock-«сейчас»);
  /// - `error` — запрос расписаний упал: UI деградирует мягко (счётчик скрыт).

  NextCareDueProvider call({
    required int plantId,
    required CareEventKind kind,
  }) => NextCareDueProvider._(
    argument: (plantId: plantId, kind: kind),
    from: this,
  );

  @override
  String toString() => r'nextCareDueProvider';
}
