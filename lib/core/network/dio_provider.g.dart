// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Сконфигурированный [Dio] (MADR-006). baseUrl = `{apiUrl}/api/v1`.
/// Порядок интерсепторов: Auth → Retry (сеть/5xx) → Error (последним, чтобы
/// маппить в [ApiError] уже после исчерпания ретраев).

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Сконфигурированный [Dio] (MADR-006). baseUrl = `{apiUrl}/api/v1`.
/// Порядок интерсепторов: Auth → Retry (сеть/5xx) → Error (последним, чтобы
/// маппить в [ApiError] уже после исчерпания ретраев).

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Сконфигурированный [Dio] (MADR-006). baseUrl = `{apiUrl}/api/v1`.
  /// Порядок интерсепторов: Auth → Retry (сеть/5xx) → Error (последним, чтобы
  /// маппить в [ApiError] уже после исчерпания ретраев).
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'30c1bca7b1698b69e33ed381f334118c0084da73';
