// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_event_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [PlantEventRepository] (MADR-004: граф провайдеров = DI).
///
/// Сейчас отдаёт [FakePlantEventRepositoryImpl] (статичный мок, BACKEND #220),
/// как `archiveRepositoryProvider`. Когда backend отдаст эндпоинт и спека
/// регенерирует клиент — здесь подставится реальная dio/codegen-реализация
/// (`ref.watch(plantsCareApiProvider)`). В тестах подменяется через
/// `plantEventRepositoryProvider.overrideWith(...)`.
///
/// `keepAlive`: мок держит события в памяти на процесс, чтобы добавленное в
/// sheet было видно при перечитывании страницы (иначе autoDispose сбрасывал бы
/// in-memory набор).

@ProviderFor(plantEventRepository)
final plantEventRepositoryProvider = PlantEventRepositoryProvider._();

/// DI-точка для [PlantEventRepository] (MADR-004: граф провайдеров = DI).
///
/// Сейчас отдаёт [FakePlantEventRepositoryImpl] (статичный мок, BACKEND #220),
/// как `archiveRepositoryProvider`. Когда backend отдаст эндпоинт и спека
/// регенерирует клиент — здесь подставится реальная dio/codegen-реализация
/// (`ref.watch(plantsCareApiProvider)`). В тестах подменяется через
/// `plantEventRepositoryProvider.overrideWith(...)`.
///
/// `keepAlive`: мок держит события в памяти на процесс, чтобы добавленное в
/// sheet было видно при перечитывании страницы (иначе autoDispose сбрасывал бы
/// in-memory набор).

final class PlantEventRepositoryProvider
    extends
        $FunctionalProvider<
          PlantEventRepository,
          PlantEventRepository,
          PlantEventRepository
        >
    with $Provider<PlantEventRepository> {
  /// DI-точка для [PlantEventRepository] (MADR-004: граф провайдеров = DI).
  ///
  /// Сейчас отдаёт [FakePlantEventRepositoryImpl] (статичный мок, BACKEND #220),
  /// как `archiveRepositoryProvider`. Когда backend отдаст эндпоинт и спека
  /// регенерирует клиент — здесь подставится реальная dio/codegen-реализация
  /// (`ref.watch(plantsCareApiProvider)`). В тестах подменяется через
  /// `plantEventRepositoryProvider.overrideWith(...)`.
  ///
  /// `keepAlive`: мок держит события в памяти на процесс, чтобы добавленное в
  /// sheet было видно при перечитывании страницы (иначе autoDispose сбрасывал бы
  /// in-memory набор).
  PlantEventRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plantEventRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plantEventRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlantEventRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlantEventRepository create(Ref ref) {
    return plantEventRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlantEventRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlantEventRepository>(value),
    );
  }
}

String _$plantEventRepositoryHash() =>
    r'3736b20053fb5bc0d5bcf4015fa4114721789511';
