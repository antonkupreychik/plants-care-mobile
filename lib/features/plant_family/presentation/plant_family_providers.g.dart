// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_family_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана «Родословная / размножение» (18).
///
/// Контракт для ui-builder:
/// - [plantFamilyProvider] — `AsyncValue<PlantFamily>` (loading / error / data).
///   В `AsyncError` лежит типизированный [ApiError]. Из `data` UI читает
///   `family.parent` (или `null`), `family.children`, `family.hasRelations`.
///   Retry — `ref.invalidate(plantFamilyProvider(plantId))`.
///
/// Один family-провайдер по `plantId` (не агрегат — экран читает ровно одну
/// ручку). При навигации в карточку другого члена семьи и обратно состояние
/// перечитывается автоматически (autoDispose).

@ProviderFor(plantFamily)
final plantFamilyProvider = PlantFamilyFamily._();

/// State-слой экрана «Родословная / размножение» (18).
///
/// Контракт для ui-builder:
/// - [plantFamilyProvider] — `AsyncValue<PlantFamily>` (loading / error / data).
///   В `AsyncError` лежит типизированный [ApiError]. Из `data` UI читает
///   `family.parent` (или `null`), `family.children`, `family.hasRelations`.
///   Retry — `ref.invalidate(plantFamilyProvider(plantId))`.
///
/// Один family-провайдер по `plantId` (не агрегат — экран читает ровно одну
/// ручку). При навигации в карточку другого члена семьи и обратно состояние
/// перечитывается автоматически (autoDispose).

final class PlantFamilyProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlantFamily>,
          PlantFamily,
          FutureOr<PlantFamily>
        >
    with $FutureModifier<PlantFamily>, $FutureProvider<PlantFamily> {
  /// State-слой экрана «Родословная / размножение» (18).
  ///
  /// Контракт для ui-builder:
  /// - [plantFamilyProvider] — `AsyncValue<PlantFamily>` (loading / error / data).
  ///   В `AsyncError` лежит типизированный [ApiError]. Из `data` UI читает
  ///   `family.parent` (или `null`), `family.children`, `family.hasRelations`.
  ///   Retry — `ref.invalidate(plantFamilyProvider(plantId))`.
  ///
  /// Один family-провайдер по `plantId` (не агрегат — экран читает ровно одну
  /// ручку). При навигации в карточку другого члена семьи и обратно состояние
  /// перечитывается автоматически (autoDispose).
  PlantFamilyProvider._({
    required PlantFamilyFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'plantFamilyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$plantFamilyHash();

  @override
  String toString() {
    return r'plantFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PlantFamily> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlantFamily> create(Ref ref) {
    final argument = this.argument as int;
    return plantFamily(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlantFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$plantFamilyHash() => r'7165dded70cc7b9283d249819f8177210864171a';

/// State-слой экрана «Родословная / размножение» (18).
///
/// Контракт для ui-builder:
/// - [plantFamilyProvider] — `AsyncValue<PlantFamily>` (loading / error / data).
///   В `AsyncError` лежит типизированный [ApiError]. Из `data` UI читает
///   `family.parent` (или `null`), `family.children`, `family.hasRelations`.
///   Retry — `ref.invalidate(plantFamilyProvider(plantId))`.
///
/// Один family-провайдер по `plantId` (не агрегат — экран читает ровно одну
/// ручку). При навигации в карточку другого члена семьи и обратно состояние
/// перечитывается автоматически (autoDispose).

final class PlantFamilyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PlantFamily>, int> {
  PlantFamilyFamily._()
    : super(
        retry: null,
        name: r'plantFamilyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// State-слой экрана «Родословная / размножение» (18).
  ///
  /// Контракт для ui-builder:
  /// - [plantFamilyProvider] — `AsyncValue<PlantFamily>` (loading / error / data).
  ///   В `AsyncError` лежит типизированный [ApiError]. Из `data` UI читает
  ///   `family.parent` (или `null`), `family.children`, `family.hasRelations`.
  ///   Retry — `ref.invalidate(plantFamilyProvider(plantId))`.
  ///
  /// Один family-провайдер по `plantId` (не агрегат — экран читает ровно одну
  /// ручку). При навигации в карточку другого члена семьи и обратно состояние
  /// перечитывается автоматически (autoDispose).

  PlantFamilyProvider call(int plantId) =>
      PlantFamilyProvider._(argument: plantId, from: this);

  @override
  String toString() => r'plantFamilyProvider';
}
