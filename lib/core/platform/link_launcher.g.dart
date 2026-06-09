// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_launcher.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [LinkLauncher] (MADR-004). В тестах подменяется override'ом.

@ProviderFor(linkLauncher)
final linkLauncherProvider = LinkLauncherProvider._();

/// DI-точка для [LinkLauncher] (MADR-004). В тестах подменяется override'ом.

final class LinkLauncherProvider
    extends $FunctionalProvider<LinkLauncher, LinkLauncher, LinkLauncher>
    with $Provider<LinkLauncher> {
  /// DI-точка для [LinkLauncher] (MADR-004). В тестах подменяется override'ом.
  LinkLauncherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkLauncherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkLauncherHash();

  @$internal
  @override
  $ProviderElement<LinkLauncher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkLauncher create(Ref ref) {
    return linkLauncher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkLauncher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkLauncher>(value),
    );
  }
}

String _$linkLauncherHash() => r'9c9e2357c2946cd0f3e8874e298c7fc560a19732';
