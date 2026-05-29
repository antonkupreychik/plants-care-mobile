// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Derived-состояние верхнего уровня для Home.
///
/// Ключуется **только** на [homePlantsProvider] — первичном контенте сада.
/// Намеренно НЕ смотрим на tasks/locations: иначе полноэкранный скелетон/офлайн
/// «залипал» бы из-за медленной или упавшей вторичной секции, хотя сад уже
/// готов к показу. Состояние вторичных секций отрисовывается посекционно
/// внутри `content`.
///
/// Правила переходов (по `AsyncValue<List<Plant>>` из [homePlantsProvider]):
/// - [coldLoading] — первичная загрузка без данных:
///   `isLoading && !hasValue`;
/// - [offline] — сетевая ошибка без закэшированного значения:
///   `hasError && !hasValue && error is NetworkError`;
/// - [content] — всё остальное: есть данные (в т.ч. рефреш поверх кэша или
///   ошибка при наличии кэша), либо не-сетевая ошибка без данных — её покажет
///   посекционный ErrorState.

@ProviderFor(homeViewState)
final homeViewStateProvider = HomeViewStateProvider._();

/// Derived-состояние верхнего уровня для Home.
///
/// Ключуется **только** на [homePlantsProvider] — первичном контенте сада.
/// Намеренно НЕ смотрим на tasks/locations: иначе полноэкранный скелетон/офлайн
/// «залипал» бы из-за медленной или упавшей вторичной секции, хотя сад уже
/// готов к показу. Состояние вторичных секций отрисовывается посекционно
/// внутри `content`.
///
/// Правила переходов (по `AsyncValue<List<Plant>>` из [homePlantsProvider]):
/// - [coldLoading] — первичная загрузка без данных:
///   `isLoading && !hasValue`;
/// - [offline] — сетевая ошибка без закэшированного значения:
///   `hasError && !hasValue && error is NetworkError`;
/// - [content] — всё остальное: есть данные (в т.ч. рефреш поверх кэша или
///   ошибка при наличии кэша), либо не-сетевая ошибка без данных — её покажет
///   посекционный ErrorState.

final class HomeViewStateProvider
    extends $FunctionalProvider<HomeViewState, HomeViewState, HomeViewState>
    with $Provider<HomeViewState> {
  /// Derived-состояние верхнего уровня для Home.
  ///
  /// Ключуется **только** на [homePlantsProvider] — первичном контенте сада.
  /// Намеренно НЕ смотрим на tasks/locations: иначе полноэкранный скелетон/офлайн
  /// «залипал» бы из-за медленной или упавшей вторичной секции, хотя сад уже
  /// готов к показу. Состояние вторичных секций отрисовывается посекционно
  /// внутри `content`.
  ///
  /// Правила переходов (по `AsyncValue<List<Plant>>` из [homePlantsProvider]):
  /// - [coldLoading] — первичная загрузка без данных:
  ///   `isLoading && !hasValue`;
  /// - [offline] — сетевая ошибка без закэшированного значения:
  ///   `hasError && !hasValue && error is NetworkError`;
  /// - [content] — всё остальное: есть данные (в т.ч. рефреш поверх кэша или
  ///   ошибка при наличии кэша), либо не-сетевая ошибка без данных — её покажет
  ///   посекционный ErrorState.
  HomeViewStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeViewStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeViewStateHash();

  @$internal
  @override
  $ProviderElement<HomeViewState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeViewState create(Ref ref) {
    return homeViewState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeViewState>(value),
    );
  }
}

String _$homeViewStateHash() => r'1587e03ccba57797537392da9e89d951a913bd1b';
