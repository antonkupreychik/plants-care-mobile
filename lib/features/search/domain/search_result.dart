import '../../catalog/domain/species.dart';
import '../../home/domain/plant.dart';
import 'disease.dart';

/// Унифицированный элемент результата поиска (issue #69, экран Search).
///
/// Sealed-иерархия поверх трёх независимых источников: мои растения (клиентская
/// фильтрация), виды (`GET /species`) и болезни/вредители (`GET /diseases`,
/// заглушка до plants-care#225). Каждый раздел грузится и рисуется независимо —
/// этот тип нужен лишь там, где удобно работать с разнородным результатом как с
/// одним списком (например, навигация по тапу). Чистый Dart, без Flutter.
sealed class SearchResult {
  const SearchResult();
}

/// Результат-растение (раздел «Мои растения»).
final class PlantResult extends SearchResult {
  const PlantResult(this.plant);

  final Plant plant;
}

/// Результат-вид (раздел «Виды»).
final class SpeciesResult extends SearchResult {
  const SpeciesResult(this.species);

  final Species species;
}

/// Результат-болезнь (раздел «Болезни и вредители»).
final class DiseaseResult extends SearchResult {
  const DiseaseResult(this.disease);

  final Disease disease;
}
