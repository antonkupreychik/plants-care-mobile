// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой фичи «Совместный уход» (экран 26).
///
/// Список соухаживающих — `AsyncValue<List<SharingMember>>` (loading / error /
/// data); в `AsyncError` лежит типизированный `ApiError` (репозиторий вернул
/// `Failure`, разворачиваем броском). UI читает через
/// `ref.watch(sharingControllerProvider)`.
///
/// Контракт для ui-builder — [invite] возвращает `Future<Result<SharingMember>>`
/// (НЕ `void`, FLUTTER.md: ошибку не глотаем). UI матчит
/// `Success`/`Failure(:final error)` и рисует баннер/тост по типу `ApiError`
/// через `AppLocalizations`. На успех список рефетчится (новое приглашение
/// появляется со статусом `PENDING`).

@ProviderFor(SharingController)
final sharingControllerProvider = SharingControllerProvider._();

/// State-слой фичи «Совместный уход» (экран 26).
///
/// Список соухаживающих — `AsyncValue<List<SharingMember>>` (loading / error /
/// data); в `AsyncError` лежит типизированный `ApiError` (репозиторий вернул
/// `Failure`, разворачиваем броском). UI читает через
/// `ref.watch(sharingControllerProvider)`.
///
/// Контракт для ui-builder — [invite] возвращает `Future<Result<SharingMember>>`
/// (НЕ `void`, FLUTTER.md: ошибку не глотаем). UI матчит
/// `Success`/`Failure(:final error)` и рисует баннер/тост по типу `ApiError`
/// через `AppLocalizations`. На успех список рефетчится (новое приглашение
/// появляется со статусом `PENDING`).
final class SharingControllerProvider
    extends $AsyncNotifierProvider<SharingController, List<SharingMember>> {
  /// State-слой фичи «Совместный уход» (экран 26).
  ///
  /// Список соухаживающих — `AsyncValue<List<SharingMember>>` (loading / error /
  /// data); в `AsyncError` лежит типизированный `ApiError` (репозиторий вернул
  /// `Failure`, разворачиваем броском). UI читает через
  /// `ref.watch(sharingControllerProvider)`.
  ///
  /// Контракт для ui-builder — [invite] возвращает `Future<Result<SharingMember>>`
  /// (НЕ `void`, FLUTTER.md: ошибку не глотаем). UI матчит
  /// `Success`/`Failure(:final error)` и рисует баннер/тост по типу `ApiError`
  /// через `AppLocalizations`. На успех список рефетчится (новое приглашение
  /// появляется со статусом `PENDING`).
  SharingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharingControllerHash();

  @$internal
  @override
  SharingController create() => SharingController();
}

String _$sharingControllerHash() => r'e00ed22ceda6108c87e0a0d7df874fe29ef82ec9';

/// State-слой фичи «Совместный уход» (экран 26).
///
/// Список соухаживающих — `AsyncValue<List<SharingMember>>` (loading / error /
/// data); в `AsyncError` лежит типизированный `ApiError` (репозиторий вернул
/// `Failure`, разворачиваем броском). UI читает через
/// `ref.watch(sharingControllerProvider)`.
///
/// Контракт для ui-builder — [invite] возвращает `Future<Result<SharingMember>>`
/// (НЕ `void`, FLUTTER.md: ошибку не глотаем). UI матчит
/// `Success`/`Failure(:final error)` и рисует баннер/тост по типу `ApiError`
/// через `AppLocalizations`. На успех список рефетчится (новое приглашение
/// появляется со статусом `PENDING`).

abstract class _$SharingController extends $AsyncNotifier<List<SharingMember>> {
  FutureOr<List<SharingMember>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SharingMember>>, List<SharingMember>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SharingMember>>, List<SharingMember>>,
              AsyncValue<List<SharingMember>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
