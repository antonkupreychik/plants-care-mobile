// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_plant_wizard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер мастера добавления растения (экран 04) — держит черновик и ведёт
/// сабмит. Не family: один мастер за раз (autoDispose сбрасывает черновик при
/// закрытии). Виджет читает `ref.watch(addPlantWizardControllerProvider)` и
/// зовёт методы; бизнес-логики/валидации в виджете нет (MADR-002).
///
/// Use case для создания нет (репозиторий тонкий, доменная логика — только
/// валидация имени в [NewPlantDraft]), поэтому [submit] зовёт репозиторий через
/// провайдер напрямую — допустимо, когда отдельного use case не существует.

@ProviderFor(AddPlantWizardController)
final addPlantWizardControllerProvider = AddPlantWizardControllerProvider._();

/// Контроллер мастера добавления растения (экран 04) — держит черновик и ведёт
/// сабмит. Не family: один мастер за раз (autoDispose сбрасывает черновик при
/// закрытии). Виджет читает `ref.watch(addPlantWizardControllerProvider)` и
/// зовёт методы; бизнес-логики/валидации в виджете нет (MADR-002).
///
/// Use case для создания нет (репозиторий тонкий, доменная логика — только
/// валидация имени в [NewPlantDraft]), поэтому [submit] зовёт репозиторий через
/// провайдер напрямую — допустимо, когда отдельного use case не существует.
final class AddPlantWizardControllerProvider
    extends $NotifierProvider<AddPlantWizardController, AddPlantWizardState> {
  /// Контроллер мастера добавления растения (экран 04) — держит черновик и ведёт
  /// сабмит. Не family: один мастер за раз (autoDispose сбрасывает черновик при
  /// закрытии). Виджет читает `ref.watch(addPlantWizardControllerProvider)` и
  /// зовёт методы; бизнес-логики/валидации в виджете нет (MADR-002).
  ///
  /// Use case для создания нет (репозиторий тонкий, доменная логика — только
  /// валидация имени в [NewPlantDraft]), поэтому [submit] зовёт репозиторий через
  /// провайдер напрямую — допустимо, когда отдельного use case не существует.
  AddPlantWizardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addPlantWizardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addPlantWizardControllerHash();

  @$internal
  @override
  AddPlantWizardController create() => AddPlantWizardController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddPlantWizardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddPlantWizardState>(value),
    );
  }
}

String _$addPlantWizardControllerHash() =>
    r'b6df57762d6c3db5d8ea29236b3ba1cb4f3a5682';

/// Контроллер мастера добавления растения (экран 04) — держит черновик и ведёт
/// сабмит. Не family: один мастер за раз (autoDispose сбрасывает черновик при
/// закрытии). Виджет читает `ref.watch(addPlantWizardControllerProvider)` и
/// зовёт методы; бизнес-логики/валидации в виджете нет (MADR-002).
///
/// Use case для создания нет (репозиторий тонкий, доменная логика — только
/// валидация имени в [NewPlantDraft]), поэтому [submit] зовёт репозиторий через
/// провайдер напрямую — допустимо, когда отдельного use case не существует.

abstract class _$AddPlantWizardController
    extends $Notifier<AddPlantWizardState> {
  AddPlantWizardState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AddPlantWizardState, AddPlantWizardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddPlantWizardState, AddPlantWizardState>,
              AddPlantWizardState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
