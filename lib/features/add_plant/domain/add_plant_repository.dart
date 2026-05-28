import '../../../core/error/result.dart';
import 'species_detail.dart';
import 'species_summary.dart';

/// Контракт data-слоя мастера добавления растения (экран 04).
///
/// Сфокусирован на том, что уникально для фичи: справочник видов (публичный,
/// scope none) и создание растения (scope user). Локации НЕ дублируем здесь —
/// presentation переиспользует `homeLocationsProvider` (`GET /locations`),
/// чтобы не плодить второй вызов клиента локаций и второй кеш.
///
/// Методы возвращают `Future<Result<T>>` и НЕ бросают наружу (MADR-011).
abstract interface class AddPlantRepository {
  /// Поиск видов (`GET /species`, scope none — публичный справочник).
  /// Пустой [query] → топ видов (backend отдаёт постранично без фильтра).
  /// [limit] backend обрезает до 100.
  Future<Result<List<SpeciesSummary>>> searchSpecies({
    String query,
    int limit,
  });

  /// Детали вида (`GET /species/{id}`, scope none) — для описания на превью.
  Future<Result<SpeciesDetail>> getSpeciesDetail(int id);

  /// Создать растение (`POST /plants`, scope user). Возвращает id созданной
  /// записи (`PlantDto.id`), чтобы UI мог инвалидировать сад и навигировать.
  Future<Result<int>> createPlant({
    required String name,
    int? locationId,
    String? notes,
    int? speciesId,
  });
}
