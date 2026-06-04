// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [DiagnosisRepository] (MADR-004: граф провайдеров = DI).
///
/// В тестах подменяется через
/// `diagnosisRepositoryProvider.overrideWith(...)`.

@ProviderFor(diagnosisRepository)
final diagnosisRepositoryProvider = DiagnosisRepositoryProvider._();

/// DI-точка для [DiagnosisRepository] (MADR-004: граф провайдеров = DI).
///
/// В тестах подменяется через
/// `diagnosisRepositoryProvider.overrideWith(...)`.

final class DiagnosisRepositoryProvider
    extends
        $FunctionalProvider<
          DiagnosisRepository,
          DiagnosisRepository,
          DiagnosisRepository
        >
    with $Provider<DiagnosisRepository> {
  /// DI-точка для [DiagnosisRepository] (MADR-004: граф провайдеров = DI).
  ///
  /// В тестах подменяется через
  /// `diagnosisRepositoryProvider.overrideWith(...)`.
  DiagnosisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diagnosisRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diagnosisRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiagnosisRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiagnosisRepository create(Ref ref) {
    return diagnosisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiagnosisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiagnosisRepository>(value),
    );
  }
}

String _$diagnosisRepositoryHash() =>
    r'20882d6e2ef87ceb2e11528ceb19fe85d59c0c85';
