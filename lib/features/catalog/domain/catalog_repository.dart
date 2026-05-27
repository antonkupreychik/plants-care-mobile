import '../../../core/error/result.dart';
import 'species_detail.dart';
import 'species_page.dart';

/// Контракт data-слоя каталога видов (экраны 12/13). Оба чтения публичные
/// (`AuthScope.none`). Методы возвращают `Future<Result<T>>` и НЕ бросают
/// наружу (MADR-011). Реализация — [CatalogRepositoryImpl] в data.
abstract interface class CatalogRepository {
  /// Поиск/список видов (`GET /api/v1/species`, scope none).
  ///
  /// [query] — подстрока по имени/латинскому имени; пустая → без фильтра.
  /// [offset] — сдвиг от начала (должен быть кратен [limit]).
  /// [limit] — размер страницы (backend обрезает до 100).
  Future<Result<SpeciesPage>> searchSpecies({
    required String query,
    required int offset,
    required int limit,
  });

  /// Деталь вида (`GET /api/v1/species/{id}`, scope none).
  Future<Result<SpeciesDetail>> getSpecies(int id);
}
