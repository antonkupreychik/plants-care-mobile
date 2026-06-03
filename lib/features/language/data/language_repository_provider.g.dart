// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [LanguageRepository] (MADR-004: граф провайдеров = DI).
///
/// Создаёт [LanguageRepositoryImpl] с [FlutterSecureStorage].
/// В тестах подменяется через `languageRepositoryProvider.overrideWith(...)`.

@ProviderFor(languageRepository)
final languageRepositoryProvider = LanguageRepositoryProvider._();

/// DI-точка для [LanguageRepository] (MADR-004: граф провайдеров = DI).
///
/// Создаёт [LanguageRepositoryImpl] с [FlutterSecureStorage].
/// В тестах подменяется через `languageRepositoryProvider.overrideWith(...)`.

final class LanguageRepositoryProvider
    extends
        $FunctionalProvider<
          LanguageRepository,
          LanguageRepository,
          LanguageRepository
        >
    with $Provider<LanguageRepository> {
  /// DI-точка для [LanguageRepository] (MADR-004: граф провайдеров = DI).
  ///
  /// Создаёт [LanguageRepositoryImpl] с [FlutterSecureStorage].
  /// В тестах подменяется через `languageRepositoryProvider.overrideWith(...)`.
  LanguageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageRepositoryHash();

  @$internal
  @override
  $ProviderElement<LanguageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LanguageRepository create(Ref ref) {
    return languageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LanguageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LanguageRepository>(value),
    );
  }
}

String _$languageRepositoryHash() =>
    r'1de3e745c1c19fc048f10f5a7d34cecb79785a89';
