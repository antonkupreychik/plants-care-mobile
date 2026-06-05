import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';
import '../domain/plant_event_repository.dart';
import 'fake_plant_event_repository_impl.dart';

part 'plant_event_repository_provider.g.dart';

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
@Riverpod(keepAlive: true)
PlantEventRepository plantEventRepository(Ref ref) =>
    FakePlantEventRepositoryImpl(ref.watch(clockProvider));
