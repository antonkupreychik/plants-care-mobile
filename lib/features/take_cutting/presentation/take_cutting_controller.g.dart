// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'take_cutting_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер мастера «Взять черенок» (экран 18) — держит данные ростка и ведёт
/// сабмит. Family по [parentPlantId] (родитель, от которого берём черенок).
/// autoDispose сбрасывает состояние при закрытии мастера.
///
/// Виджет читает `ref.watch(takeCuttingControllerProvider(parentId))` и зовёт
/// методы; бизнес-логики/валидации в виджете нет (MADR-002). Use case для
/// создания нет (репозиторий тонкий, доменная логика — только валидация имени в
/// [TakeCuttingState]), поэтому [submit] зовёт репозиторий через провайдер
/// напрямую — допустимо, когда отдельного use case не существует.

@ProviderFor(TakeCuttingController)
final takeCuttingControllerProvider = TakeCuttingControllerFamily._();

/// Контроллер мастера «Взять черенок» (экран 18) — держит данные ростка и ведёт
/// сабмит. Family по [parentPlantId] (родитель, от которого берём черенок).
/// autoDispose сбрасывает состояние при закрытии мастера.
///
/// Виджет читает `ref.watch(takeCuttingControllerProvider(parentId))` и зовёт
/// методы; бизнес-логики/валидации в виджете нет (MADR-002). Use case для
/// создания нет (репозиторий тонкий, доменная логика — только валидация имени в
/// [TakeCuttingState]), поэтому [submit] зовёт репозиторий через провайдер
/// напрямую — допустимо, когда отдельного use case не существует.
final class TakeCuttingControllerProvider
    extends $NotifierProvider<TakeCuttingController, TakeCuttingState> {
  /// Контроллер мастера «Взять черенок» (экран 18) — держит данные ростка и ведёт
  /// сабмит. Family по [parentPlantId] (родитель, от которого берём черенок).
  /// autoDispose сбрасывает состояние при закрытии мастера.
  ///
  /// Виджет читает `ref.watch(takeCuttingControllerProvider(parentId))` и зовёт
  /// методы; бизнес-логики/валидации в виджете нет (MADR-002). Use case для
  /// создания нет (репозиторий тонкий, доменная логика — только валидация имени в
  /// [TakeCuttingState]), поэтому [submit] зовёт репозиторий через провайдер
  /// напрямую — допустимо, когда отдельного use case не существует.
  TakeCuttingControllerProvider._({
    required TakeCuttingControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'takeCuttingControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$takeCuttingControllerHash();

  @override
  String toString() {
    return r'takeCuttingControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TakeCuttingController create() => TakeCuttingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TakeCuttingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TakeCuttingState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TakeCuttingControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$takeCuttingControllerHash() =>
    r'247f7dfad43045a73b26c9bcf242b1af80a51067';

/// Контроллер мастера «Взять черенок» (экран 18) — держит данные ростка и ведёт
/// сабмит. Family по [parentPlantId] (родитель, от которого берём черенок).
/// autoDispose сбрасывает состояние при закрытии мастера.
///
/// Виджет читает `ref.watch(takeCuttingControllerProvider(parentId))` и зовёт
/// методы; бизнес-логики/валидации в виджете нет (MADR-002). Use case для
/// создания нет (репозиторий тонкий, доменная логика — только валидация имени в
/// [TakeCuttingState]), поэтому [submit] зовёт репозиторий через провайдер
/// напрямую — допустимо, когда отдельного use case не существует.

final class TakeCuttingControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TakeCuttingController,
          TakeCuttingState,
          TakeCuttingState,
          TakeCuttingState,
          int
        > {
  TakeCuttingControllerFamily._()
    : super(
        retry: null,
        name: r'takeCuttingControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Контроллер мастера «Взять черенок» (экран 18) — держит данные ростка и ведёт
  /// сабмит. Family по [parentPlantId] (родитель, от которого берём черенок).
  /// autoDispose сбрасывает состояние при закрытии мастера.
  ///
  /// Виджет читает `ref.watch(takeCuttingControllerProvider(parentId))` и зовёт
  /// методы; бизнес-логики/валидации в виджете нет (MADR-002). Use case для
  /// создания нет (репозиторий тонкий, доменная логика — только валидация имени в
  /// [TakeCuttingState]), поэтому [submit] зовёт репозиторий через провайдер
  /// напрямую — допустимо, когда отдельного use case не существует.

  TakeCuttingControllerProvider call(int parentPlantId) =>
      TakeCuttingControllerProvider._(argument: parentPlantId, from: this);

  @override
  String toString() => r'takeCuttingControllerProvider';
}

/// Контроллер мастера «Взять черенок» (экран 18) — держит данные ростка и ведёт
/// сабмит. Family по [parentPlantId] (родитель, от которого берём черенок).
/// autoDispose сбрасывает состояние при закрытии мастера.
///
/// Виджет читает `ref.watch(takeCuttingControllerProvider(parentId))` и зовёт
/// методы; бизнес-логики/валидации в виджете нет (MADR-002). Use case для
/// создания нет (репозиторий тонкий, доменная логика — только валидация имени в
/// [TakeCuttingState]), поэтому [submit] зовёт репозиторий через провайдер
/// напрямую — допустимо, когда отдельного use case не существует.

abstract class _$TakeCuttingController extends $Notifier<TakeCuttingState> {
  late final _$args = ref.$arg as int;
  int get parentPlantId => _$args;

  TakeCuttingState build(int parentPlantId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TakeCuttingState, TakeCuttingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TakeCuttingState, TakeCuttingState>,
              TakeCuttingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
