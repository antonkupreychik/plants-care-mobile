// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// UI-состояние: выбранная локация-фильтр на Главной. `null` = «Все».
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с Главной фильтр сбрасывается (не залипает на
/// исчезнувшей после рефреша комнате). Фильтрация списка растений по этому id
/// делается в UI из уже загруженного списка (`plant.locationId`), без сети.

@ProviderFor(SelectedLocation)
final selectedLocationProvider = SelectedLocationProvider._();

/// UI-состояние: выбранная локация-фильтр на Главной. `null` = «Все».
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с Главной фильтр сбрасывается (не залипает на
/// исчезнувшей после рефреша комнате). Фильтрация списка растений по этому id
/// делается в UI из уже загруженного списка (`plant.locationId`), без сети.
final class SelectedLocationProvider
    extends $NotifierProvider<SelectedLocation, int?> {
  /// UI-состояние: выбранная локация-фильтр на Главной. `null` = «Все».
  ///
  /// Presentation-only (выбор чипа), не доменные данные. Через codegen —
  /// **autoDispose**: при уходе с Главной фильтр сбрасывается (не залипает на
  /// исчезнувшей после рефреша комнате). Фильтрация списка растений по этому id
  /// делается в UI из уже загруженного списка (`plant.locationId`), без сети.
  SelectedLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLocationHash();

  @$internal
  @override
  SelectedLocation create() => SelectedLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedLocationHash() => r'2822185532f025f5b486910cfdfafdc0cb7a66b5';

/// UI-состояние: выбранная локация-фильтр на Главной. `null` = «Все».
///
/// Presentation-only (выбор чипа), не доменные данные. Через codegen —
/// **autoDispose**: при уходе с Главной фильтр сбрасывается (не залипает на
/// исчезнувшей после рефреша комнате). Фильтрация списка растений по этому id
/// делается в UI из уже загруженного списка (`plant.locationId`), без сети.

abstract class _$SelectedLocation extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
