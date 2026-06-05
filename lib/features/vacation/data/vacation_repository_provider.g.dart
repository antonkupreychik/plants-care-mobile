// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [VacationRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `vacationRepositoryProvider.overrideWith(...)`.

@ProviderFor(vacationRepository)
final vacationRepositoryProvider = VacationRepositoryProvider._();

/// DI-точка для [VacationRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `vacationRepositoryProvider.overrideWith(...)`.

final class VacationRepositoryProvider
    extends
        $FunctionalProvider<
          VacationRepository,
          VacationRepository,
          VacationRepository
        >
    with $Provider<VacationRepository> {
  /// DI-точка для [VacationRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `vacationRepositoryProvider.overrideWith(...)`.
  VacationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vacationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vacationRepositoryHash();

  @$internal
  @override
  $ProviderElement<VacationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VacationRepository create(Ref ref) {
    return vacationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VacationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VacationRepository>(value),
    );
  }
}

String _$vacationRepositoryHash() =>
    r'2b7f37a5e78942650b84207177eb3fb5da524e2a';
