// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdui_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [SduiRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `sduiRepositoryProvider.overrideWith(...)`.

@ProviderFor(sduiRepository)
final sduiRepositoryProvider = SduiRepositoryProvider._();

/// DI-точка для [SduiRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `sduiRepositoryProvider.overrideWith(...)`.

final class SduiRepositoryProvider
    extends $FunctionalProvider<SduiRepository, SduiRepository, SduiRepository>
    with $Provider<SduiRepository> {
  /// DI-точка для [SduiRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `sduiRepositoryProvider.overrideWith(...)`.
  SduiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sduiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sduiRepositoryHash();

  @$internal
  @override
  $ProviderElement<SduiRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SduiRepository create(Ref ref) {
    return sduiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SduiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SduiRepository>(value),
    );
  }
}

String _$sduiRepositoryHash() => r'1c9b3a5fa2197cce4294a782558e4c751b7fbd91';
