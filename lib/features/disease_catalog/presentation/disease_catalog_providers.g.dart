// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Committed-строка поиска по справочнику болезней (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Сброс — `setQuery('')`.

@ProviderFor(DiseaseQuery)
final diseaseQueryProvider = DiseaseQueryProvider._();

/// Committed-строка поиска по справочнику болезней (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Сброс — `setQuery('')`.
final class DiseaseQueryProvider
    extends $NotifierProvider<DiseaseQuery, String> {
  /// Committed-строка поиска по справочнику болезней (не сырой ввод).
  ///
  /// Presentation-only UI-состояние (MADR-004). Сброс — `setQuery('')`.
  DiseaseQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diseaseQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diseaseQueryHash();

  @$internal
  @override
  DiseaseQuery create() => DiseaseQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$diseaseQueryHash() => r'828f5f4fc7f90f63dcc46b1cda43fa512d538205';

/// Committed-строка поиска по справочнику болезней (не сырой ввод).
///
/// Presentation-only UI-состояние (MADR-004). Сброс — `setQuery('')`.

abstract class _$DiseaseQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Список болезней под текущей строкой поиска.
///
/// `watch(diseaseQueryProvider)` в [build]: смена строки пересоздаёт провайдер
/// (loading → данные). Пустая строка ИЛИ короче [kDiseaseSearchMinLength] →
/// полный список (`getAll`); иначе — `search(query)`. `Result.failure`
/// пробрасывается броском `ApiError`, Riverpod упакует в `AsyncError`.

@ProviderFor(diseaseList)
final diseaseListProvider = DiseaseListProvider._();

/// Список болезней под текущей строкой поиска.
///
/// `watch(diseaseQueryProvider)` в [build]: смена строки пересоздаёт провайдер
/// (loading → данные). Пустая строка ИЛИ короче [kDiseaseSearchMinLength] →
/// полный список (`getAll`); иначе — `search(query)`. `Result.failure`
/// пробрасывается броском `ApiError`, Riverpod упакует в `AsyncError`.

final class DiseaseListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Disease>>,
          List<Disease>,
          FutureOr<List<Disease>>
        >
    with $FutureModifier<List<Disease>>, $FutureProvider<List<Disease>> {
  /// Список болезней под текущей строкой поиска.
  ///
  /// `watch(diseaseQueryProvider)` в [build]: смена строки пересоздаёт провайдер
  /// (loading → данные). Пустая строка ИЛИ короче [kDiseaseSearchMinLength] →
  /// полный список (`getAll`); иначе — `search(query)`. `Result.failure`
  /// пробрасывается броском `ApiError`, Riverpod упакует в `AsyncError`.
  DiseaseListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diseaseListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diseaseListHash();

  @$internal
  @override
  $FutureProviderElement<List<Disease>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Disease>> create(Ref ref) {
    return diseaseList(ref);
  }
}

String _$diseaseListHash() => r'77482400a02056a9a76fc50479f0d2d12f55c519';

/// Деталь болезни по `id` (family). `AsyncError` несёт типизированный
/// `ApiError` (напр. `notFound`).

@ProviderFor(diseaseDetail)
final diseaseDetailProvider = DiseaseDetailFamily._();

/// Деталь болезни по `id` (family). `AsyncError` несёт типизированный
/// `ApiError` (напр. `notFound`).

final class DiseaseDetailProvider
    extends $FunctionalProvider<AsyncValue<Disease>, Disease, FutureOr<Disease>>
    with $FutureModifier<Disease>, $FutureProvider<Disease> {
  /// Деталь болезни по `id` (family). `AsyncError` несёт типизированный
  /// `ApiError` (напр. `notFound`).
  DiseaseDetailProvider._({
    required DiseaseDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'diseaseDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diseaseDetailHash();

  @override
  String toString() {
    return r'diseaseDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Disease> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Disease> create(Ref ref) {
    final argument = this.argument as int;
    return diseaseDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiseaseDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diseaseDetailHash() => r'bffdeb3c9d2e7cc5af2c29cd535f2878df98f7e6';

/// Деталь болезни по `id` (family). `AsyncError` несёт типизированный
/// `ApiError` (напр. `notFound`).

final class DiseaseDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Disease>, int> {
  DiseaseDetailFamily._()
    : super(
        retry: null,
        name: r'diseaseDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Деталь болезни по `id` (family). `AsyncError` несёт типизированный
  /// `ApiError` (напр. `notFound`).

  DiseaseDetailProvider call(int id) =>
      DiseaseDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'diseaseDetailProvider';
}
