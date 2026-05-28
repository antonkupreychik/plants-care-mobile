// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана «Архив» (17).
///
/// Один агрегатный провайдер: список архивных растений и ретроспектива грузятся
/// и показываются вместе (в отличие от home, где секции независимы) — это один
/// логический экран без посекционных мутаций.
///
/// Контракт для ui-builder: `ref.watch(archiveViewProvider)` отдаёт
/// `AsyncValue<ArchiveView>`:
/// - loading → skeleton карточек;
/// - error → `AsyncError` с типизированным [ApiError] (репозиторий вернул
///   `Failure`, разворачиваем броском) — UI маппит в текст через
///   `AppLocalizations`;
/// - data → [ArchiveView]; empty-state определяется самим UI по
///   `view.plants.isEmpty` (тогда `view.retrospective == null`).

@ProviderFor(archiveView)
final archiveViewProvider = ArchiveViewProvider._();

/// State-слой экрана «Архив» (17).
///
/// Один агрегатный провайдер: список архивных растений и ретроспектива грузятся
/// и показываются вместе (в отличие от home, где секции независимы) — это один
/// логический экран без посекционных мутаций.
///
/// Контракт для ui-builder: `ref.watch(archiveViewProvider)` отдаёт
/// `AsyncValue<ArchiveView>`:
/// - loading → skeleton карточек;
/// - error → `AsyncError` с типизированным [ApiError] (репозиторий вернул
///   `Failure`, разворачиваем броском) — UI маппит в текст через
///   `AppLocalizations`;
/// - data → [ArchiveView]; empty-state определяется самим UI по
///   `view.plants.isEmpty` (тогда `view.retrospective == null`).

final class ArchiveViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<ArchiveView>,
          ArchiveView,
          FutureOr<ArchiveView>
        >
    with $FutureModifier<ArchiveView>, $FutureProvider<ArchiveView> {
  /// State-слой экрана «Архив» (17).
  ///
  /// Один агрегатный провайдер: список архивных растений и ретроспектива грузятся
  /// и показываются вместе (в отличие от home, где секции независимы) — это один
  /// логический экран без посекционных мутаций.
  ///
  /// Контракт для ui-builder: `ref.watch(archiveViewProvider)` отдаёт
  /// `AsyncValue<ArchiveView>`:
  /// - loading → skeleton карточек;
  /// - error → `AsyncError` с типизированным [ApiError] (репозиторий вернул
  ///   `Failure`, разворачиваем броском) — UI маппит в текст через
  ///   `AppLocalizations`;
  /// - data → [ArchiveView]; empty-state определяется самим UI по
  ///   `view.plants.isEmpty` (тогда `view.retrospective == null`).
  ArchiveViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'archiveViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$archiveViewHash();

  @$internal
  @override
  $FutureProviderElement<ArchiveView> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ArchiveView> create(Ref ref) {
    return archiveView(ref);
  }
}

String _$archiveViewHash() => r'a927504b6ccbacc14b83fdcef2dd13ad1048a58f';
