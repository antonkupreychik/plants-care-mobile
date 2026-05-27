// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_care_event_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер формы отметки ухода (экран 06 sheet) — мутация, не чтение.
///
/// Family по `plantId`: один sheet = одно растение. Держит [CareEventFormState]
/// (выбранный тип, время, заметка, статус отправки). Виджет читает состояние
/// через `ref.watch(logCareEventControllerProvider(plantId))` и зовёт методы;
/// бизнес-логики в виджете нет (MADR-002).
///
/// Время «сейчас» берём из `clockProvider` (UTC), а не `DateTime.now()`
/// (FLUTTER.md «Время»). Backdating: UI может вызвать [setPerformedAt] с
/// прошлой датой (api-contract §7 разрешает).
///
/// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на попытку отправки
/// внутри [submit] и переиспользуется при ретрае той же попытки, чтобы backend
/// дедуплицировал (FLUTTER.md «Идемпотентность»). Новый тап после ошибки —
/// новая попытка с новым clientId.

@ProviderFor(LogCareEventController)
final logCareEventControllerProvider = LogCareEventControllerFamily._();

/// Контроллер формы отметки ухода (экран 06 sheet) — мутация, не чтение.
///
/// Family по `plantId`: один sheet = одно растение. Держит [CareEventFormState]
/// (выбранный тип, время, заметка, статус отправки). Виджет читает состояние
/// через `ref.watch(logCareEventControllerProvider(plantId))` и зовёт методы;
/// бизнес-логики в виджете нет (MADR-002).
///
/// Время «сейчас» берём из `clockProvider` (UTC), а не `DateTime.now()`
/// (FLUTTER.md «Время»). Backdating: UI может вызвать [setPerformedAt] с
/// прошлой датой (api-contract §7 разрешает).
///
/// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на попытку отправки
/// внутри [submit] и переиспользуется при ретрае той же попытки, чтобы backend
/// дедуплицировал (FLUTTER.md «Идемпотентность»). Новый тап после ошибки —
/// новая попытка с новым clientId.
final class LogCareEventControllerProvider
    extends $NotifierProvider<LogCareEventController, CareEventFormState> {
  /// Контроллер формы отметки ухода (экран 06 sheet) — мутация, не чтение.
  ///
  /// Family по `plantId`: один sheet = одно растение. Держит [CareEventFormState]
  /// (выбранный тип, время, заметка, статус отправки). Виджет читает состояние
  /// через `ref.watch(logCareEventControllerProvider(plantId))` и зовёт методы;
  /// бизнес-логики в виджете нет (MADR-002).
  ///
  /// Время «сейчас» берём из `clockProvider` (UTC), а не `DateTime.now()`
  /// (FLUTTER.md «Время»). Backdating: UI может вызвать [setPerformedAt] с
  /// прошлой датой (api-contract §7 разрешает).
  ///
  /// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на попытку отправки
  /// внутри [submit] и переиспользуется при ретрае той же попытки, чтобы backend
  /// дедуплицировал (FLUTTER.md «Идемпотентность»). Новый тап после ошибки —
  /// новая попытка с новым clientId.
  LogCareEventControllerProvider._({
    required LogCareEventControllerFamily super.from,
    required (int, {CareEventKind? presetType}) super.argument,
  }) : super(
         retry: null,
         name: r'logCareEventControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$logCareEventControllerHash();

  @override
  String toString() {
    return r'logCareEventControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LogCareEventController create() => LogCareEventController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CareEventFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CareEventFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LogCareEventControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$logCareEventControllerHash() =>
    r'c70ef7c3a032fd3697ea0a37d52bda2b72616414';

/// Контроллер формы отметки ухода (экран 06 sheet) — мутация, не чтение.
///
/// Family по `plantId`: один sheet = одно растение. Держит [CareEventFormState]
/// (выбранный тип, время, заметка, статус отправки). Виджет читает состояние
/// через `ref.watch(logCareEventControllerProvider(plantId))` и зовёт методы;
/// бизнес-логики в виджете нет (MADR-002).
///
/// Время «сейчас» берём из `clockProvider` (UTC), а не `DateTime.now()`
/// (FLUTTER.md «Время»). Backdating: UI может вызвать [setPerformedAt] с
/// прошлой датой (api-contract §7 разрешает).
///
/// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на попытку отправки
/// внутри [submit] и переиспользуется при ретрае той же попытки, чтобы backend
/// дедуплицировал (FLUTTER.md «Идемпотентность»). Новый тап после ошибки —
/// новая попытка с новым clientId.

final class LogCareEventControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          LogCareEventController,
          CareEventFormState,
          CareEventFormState,
          CareEventFormState,
          (int, {CareEventKind? presetType})
        > {
  LogCareEventControllerFamily._()
    : super(
        retry: null,
        name: r'logCareEventControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Контроллер формы отметки ухода (экран 06 sheet) — мутация, не чтение.
  ///
  /// Family по `plantId`: один sheet = одно растение. Держит [CareEventFormState]
  /// (выбранный тип, время, заметка, статус отправки). Виджет читает состояние
  /// через `ref.watch(logCareEventControllerProvider(plantId))` и зовёт методы;
  /// бизнес-логики в виджете нет (MADR-002).
  ///
  /// Время «сейчас» берём из `clockProvider` (UTC), а не `DateTime.now()`
  /// (FLUTTER.md «Время»). Backdating: UI может вызвать [setPerformedAt] с
  /// прошлой датой (api-contract §7 разрешает).
  ///
  /// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на попытку отправки
  /// внутри [submit] и переиспользуется при ретрае той же попытки, чтобы backend
  /// дедуплицировал (FLUTTER.md «Идемпотентность»). Новый тап после ошибки —
  /// новая попытка с новым clientId.

  LogCareEventControllerProvider call(
    int plantId, {
    CareEventKind? presetType,
  }) => LogCareEventControllerProvider._(
    argument: (plantId, presetType: presetType),
    from: this,
  );

  @override
  String toString() => r'logCareEventControllerProvider';
}

/// Контроллер формы отметки ухода (экран 06 sheet) — мутация, не чтение.
///
/// Family по `plantId`: один sheet = одно растение. Держит [CareEventFormState]
/// (выбранный тип, время, заметка, статус отправки). Виджет читает состояние
/// через `ref.watch(logCareEventControllerProvider(plantId))` и зовёт методы;
/// бизнес-логики в виджете нет (MADR-002).
///
/// Время «сейчас» берём из `clockProvider` (UTC), а не `DateTime.now()`
/// (FLUTTER.md «Время»). Backdating: UI может вызвать [setPerformedAt] с
/// прошлой датой (api-contract §7 разрешает).
///
/// Идемпотентность: `clientId` (UUID) генерируется ОДИН раз на попытку отправки
/// внутри [submit] и переиспользуется при ретрае той же попытки, чтобы backend
/// дедуплицировал (FLUTTER.md «Идемпотентность»). Новый тап после ошибки —
/// новая попытка с новым clientId.

abstract class _$LogCareEventController extends $Notifier<CareEventFormState> {
  late final _$args = ref.$arg as (int, {CareEventKind? presetType});
  int get plantId => _$args.$1;
  CareEventKind? get presetType => _$args.presetType;

  CareEventFormState build(int plantId, {CareEventKind? presetType});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CareEventFormState, CareEventFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CareEventFormState, CareEventFormState>,
              CareEventFormState,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(_$args.$1, presetType: _$args.presetType),
    );
  }
}
