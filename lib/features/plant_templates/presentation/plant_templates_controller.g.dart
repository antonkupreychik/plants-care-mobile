// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_templates_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой фичи «Шаблоны растений».
///
/// Список шаблонов — `AsyncValue<List<PlantTemplate>>` (loading / error / data).
/// UI читает через `ref.watch(plantTemplatesControllerProvider)`.
///
/// Мутации возвращают `Result<T>` (не `void`): UI матчит
/// `Success`/`Failure(:final error)` и рисует SnackBar по типу `ApiError`
/// через `AppLocalizations` (MADR-011/012).
///
/// После успешной мутации список рефетчится автоматически.

@ProviderFor(PlantTemplatesController)
final plantTemplatesControllerProvider = PlantTemplatesControllerProvider._();

/// State-слой фичи «Шаблоны растений».
///
/// Список шаблонов — `AsyncValue<List<PlantTemplate>>` (loading / error / data).
/// UI читает через `ref.watch(plantTemplatesControllerProvider)`.
///
/// Мутации возвращают `Result<T>` (не `void`): UI матчит
/// `Success`/`Failure(:final error)` и рисует SnackBar по типу `ApiError`
/// через `AppLocalizations` (MADR-011/012).
///
/// После успешной мутации список рефетчится автоматически.
final class PlantTemplatesControllerProvider
    extends
        $AsyncNotifierProvider<PlantTemplatesController, List<PlantTemplate>> {
  /// State-слой фичи «Шаблоны растений».
  ///
  /// Список шаблонов — `AsyncValue<List<PlantTemplate>>` (loading / error / data).
  /// UI читает через `ref.watch(plantTemplatesControllerProvider)`.
  ///
  /// Мутации возвращают `Result<T>` (не `void`): UI матчит
  /// `Success`/`Failure(:final error)` и рисует SnackBar по типу `ApiError`
  /// через `AppLocalizations` (MADR-011/012).
  ///
  /// После успешной мутации список рефетчится автоматически.
  PlantTemplatesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantTemplatesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantTemplatesControllerHash();

  @$internal
  @override
  PlantTemplatesController create() => PlantTemplatesController();
}

String _$plantTemplatesControllerHash() =>
    r'f498f46bd7f85c57a265d35a64802714423039d0';

/// State-слой фичи «Шаблоны растений».
///
/// Список шаблонов — `AsyncValue<List<PlantTemplate>>` (loading / error / data).
/// UI читает через `ref.watch(plantTemplatesControllerProvider)`.
///
/// Мутации возвращают `Result<T>` (не `void`): UI матчит
/// `Success`/`Failure(:final error)` и рисует SnackBar по типу `ApiError`
/// через `AppLocalizations` (MADR-011/012).
///
/// После успешной мутации список рефетчится автоматически.

abstract class _$PlantTemplatesController
    extends $AsyncNotifier<List<PlantTemplate>> {
  FutureOr<List<PlantTemplate>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PlantTemplate>>, List<PlantTemplate>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PlantTemplate>>, List<PlantTemplate>>,
              AsyncValue<List<PlantTemplate>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
