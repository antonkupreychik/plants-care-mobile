import '../../../core/error/result.dart';
import 'disease.dart';

/// Контракт data-слоя справочника болезней и вредителей (issue #68).
///
/// Чтения публичные (`AuthScope.none` — справочник). Методы возвращают
/// `Future<Result<T>>` и НЕ бросают наружу (MADR-011). Реализации:
/// [FakeDiseaseCatalogRepositoryImpl] (до backend `plants-care#225`) и
/// позже `DiseaseCatalogRepositoryImpl` поверх OpenAPI-клиента.
abstract interface class DiseaseCatalogRepository {
  /// Полный список болезней/вредителей справочника.
  Future<Result<List<Disease>>> getAll();

  /// Поиск по названию или симптомам (подстрока, регистронезависимо).
  ///
  /// Пустой/слишком короткий [query] фильтрацию выполняет вызывающий слой
  /// (см. presentation): здесь просто матчинг подстроки.
  Future<Result<List<Disease>>> search(String query);

  /// Болезнь по идентификатору (для детали).
  Future<Result<Disease>> getById(int id);
}
