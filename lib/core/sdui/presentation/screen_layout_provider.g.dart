// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_layout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой SDUI главного экрана (MADR-015).
///
/// Отдаёт `AsyncValue<SduiScreenLayout>` (loading / error / data). В `AsyncError`
/// лежит типизированный `ApiError` (см. [_unwrap]) — UI маппит его в текст через
/// `AppLocalizations`, как остальные home-провайдеры.
///
/// Инвалидируется после успешного действия ухода (см. `ActionRunner`), чтобы
/// сервер пересобрал лейаут (`today_summary`, доступность действий).

@ProviderFor(homeScreenLayout)
final homeScreenLayoutProvider = HomeScreenLayoutProvider._();

/// State-слой SDUI главного экрана (MADR-015).
///
/// Отдаёт `AsyncValue<SduiScreenLayout>` (loading / error / data). В `AsyncError`
/// лежит типизированный `ApiError` (см. [_unwrap]) — UI маппит его в текст через
/// `AppLocalizations`, как остальные home-провайдеры.
///
/// Инвалидируется после успешного действия ухода (см. `ActionRunner`), чтобы
/// сервер пересобрал лейаут (`today_summary`, доступность действий).

final class HomeScreenLayoutProvider
    extends
        $FunctionalProvider<
          AsyncValue<SduiScreenLayout>,
          SduiScreenLayout,
          FutureOr<SduiScreenLayout>
        >
    with $FutureModifier<SduiScreenLayout>, $FutureProvider<SduiScreenLayout> {
  /// State-слой SDUI главного экрана (MADR-015).
  ///
  /// Отдаёт `AsyncValue<SduiScreenLayout>` (loading / error / data). В `AsyncError`
  /// лежит типизированный `ApiError` (см. [_unwrap]) — UI маппит его в текст через
  /// `AppLocalizations`, как остальные home-провайдеры.
  ///
  /// Инвалидируется после успешного действия ухода (см. `ActionRunner`), чтобы
  /// сервер пересобрал лейаут (`today_summary`, доступность действий).
  HomeScreenLayoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeScreenLayoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeScreenLayoutHash();

  @$internal
  @override
  $FutureProviderElement<SduiScreenLayout> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SduiScreenLayout> create(Ref ref) {
    return homeScreenLayout(ref);
  }
}

String _$homeScreenLayoutHash() => r'2aa4626198ddfabda55bbea69b70118252acc13d';
