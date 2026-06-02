// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Сконфигурированный [Dio] (MADR-006/008). baseUrl = `{apiUrl}` (пути
/// сгенерированного клиента уже включают `/api/v1`).
///
/// Порядок интерсепторов: Auth (подставляет bearer) → DateQuery (фикс date-only
/// до ухода в сеть) → Refresh (ротация на 401) → Retry (сеть/5xx) → Error
/// (последним — маппинг в [ApiError] уже после исчерпания ретраев и refresh).

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Сконфигурированный [Dio] (MADR-006/008). baseUrl = `{apiUrl}` (пути
/// сгенерированного клиента уже включают `/api/v1`).
///
/// Порядок интерсепторов: Auth (подставляет bearer) → DateQuery (фикс date-only
/// до ухода в сеть) → Refresh (ротация на 401) → Retry (сеть/5xx) → Error
/// (последним — маппинг в [ApiError] уже после исчерпания ретраев и refresh).

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Сконфигурированный [Dio] (MADR-006/008). baseUrl = `{apiUrl}` (пути
  /// сгенерированного клиента уже включают `/api/v1`).
  ///
  /// Порядок интерсепторов: Auth (подставляет bearer) → DateQuery (фикс date-only
  /// до ухода в сеть) → Refresh (ротация на 401) → Retry (сеть/5xx) → Error
  /// (последним — маппинг в [ApiError] уже после исчерпания ретраев и refresh).
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

String _$dioHash() => r'586a9e3fdeff4e92d1035aa9a71f3174730ee79d';
