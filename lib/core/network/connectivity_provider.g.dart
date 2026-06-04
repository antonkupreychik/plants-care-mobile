// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Провайдер статуса сети: `true` — онлайн, `false` — офлайн.
///
/// Реализован через периодический DNS-запрос (`dart:io`) без внешних пакетов.
/// Первое значение эмитируется до первого тика таймера (ранний снапшот при
/// монтировании), затем — каждые [_pollInterval].
///
/// Используется [HomeScreen] через `ref.listen` для авто-рефетча при
/// восстановлении сети (offline → online переход).

@ProviderFor(connectivity)
final connectivityProvider = ConnectivityProvider._();

/// Провайдер статуса сети: `true` — онлайн, `false` — офлайн.
///
/// Реализован через периодический DNS-запрос (`dart:io`) без внешних пакетов.
/// Первое значение эмитируется до первого тика таймера (ранний снапшот при
/// монтировании), затем — каждые [_pollInterval].
///
/// Используется [HomeScreen] через `ref.listen` для авто-рефетча при
/// восстановлении сети (offline → online переход).

final class ConnectivityProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Провайдер статуса сети: `true` — онлайн, `false` — офлайн.
  ///
  /// Реализован через периодический DNS-запрос (`dart:io`) без внешних пакетов.
  /// Первое значение эмитируется до первого тика таймера (ранний снапшот при
  /// монтировании), затем — каждые [_pollInterval].
  ///
  /// Используется [HomeScreen] через `ref.listen` для авто-рефетча при
  /// восстановлении сети (offline → online переход).
  ConnectivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return connectivity(ref);
  }
}

String _$connectivityHash() => r'709eae84f2a502a0f6bdaa900df4956c69106b99';
