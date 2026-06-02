// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_sign_in_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [SocialSignIn] (MADR-004). client ID резолвятся из
/// [appConfigProvider]; в тестах подменяется через
/// `socialSignInProvider.overrideWith(...)`.

@ProviderFor(socialSignIn)
final socialSignInProvider = SocialSignInProvider._();

/// DI-точка для [SocialSignIn] (MADR-004). client ID резолвятся из
/// [appConfigProvider]; в тестах подменяется через
/// `socialSignInProvider.overrideWith(...)`.

final class SocialSignInProvider
    extends $FunctionalProvider<SocialSignIn, SocialSignIn, SocialSignIn>
    with $Provider<SocialSignIn> {
  /// DI-точка для [SocialSignIn] (MADR-004). client ID резолвятся из
  /// [appConfigProvider]; в тестах подменяется через
  /// `socialSignInProvider.overrideWith(...)`.
  SocialSignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socialSignInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socialSignInHash();

  @$internal
  @override
  $ProviderElement<SocialSignIn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SocialSignIn create(Ref ref) {
    return socialSignIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocialSignIn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SocialSignIn>(value),
    );
  }
}

String _$socialSignInHash() => r'32433fbdaeb9ecef9139de26a1a7030bb285e907';
