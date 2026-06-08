import '../../../core/api/generated/models/plant_dto.dart';
import '../domain/archived_plant.dart';

/// Маппер PlantDto (archived) → ArchivedPlant (domain).
///
/// [PlantDto] с `status=archived` несёт `archivedAt`, `gifted`, `note`,
/// `totalCareDays` — все поля заполнены бэкендом. Здесь они конвертируются в
/// форматированные строки для UI без бизнес-логики в presentation (MADR-002).
///
/// Форматирование дат и длительностей делаем на клиенте: бэкенд отдаёт сырые
/// числа (`totalCareDays`) и метку времени (`archivedAt`), а вид «11 месяцев»,
/// «3 года 2 мес.» мы строим здесь — чтобы не тащить логику форматирования в
/// domain или UI-виджет. Тексты, строго говоря, не UI-строки (не через l10n),
/// потому что они данные (контент), а не UI-обвязка (FLUTTER.md: контент с
/// backend — показываем как есть / как следует из данных; l10n — только обвязка
/// и ошибки).
///
/// [speciesName] берём из dto.speciesName (денормализованное поле). Если
/// backend не прислал — пустая строка (UI резолвит иллюстрацию по виду).
///
/// Тест: `test/features/archive/data/archived_plant_mapper_test.dart`.
extension ArchivedPlantMapper on PlantDto {
  /// Конвертирует архивный [PlantDto] в domain [ArchivedPlant].
  ///
  /// Вызывается только когда `archived == true`; для активных растений
  /// поведение не определено (поля выбытия будут null).
  ArchivedPlant toDomain() {
    return ArchivedPlant(
      id: id,
      name: name,
      speciesName: speciesName ?? '',
      livedLabel: _formatLivedLabel(totalCareDays),
      cause: note ?? '',
      archivedDateLabel: _formatArchivedDateLabel(archivedAt),
      gifted: gifted ?? false,
    );
  }
}

/// Форматирует количество дней в человекочитаемую строку.
///
/// Примеры: 0..30 → «1 месяц» (минимум), 335 → «11 месяцев»,
/// 395 → «1 год 1 мес.», 1167 → «3 года 2 мес.»
String _formatLivedLabel(int? totalCareDays) {
  if (totalCareDays == null || totalCareDays <= 0) {
    return '';
  }
  final years = totalCareDays ~/ 365;
  final remainingDays = totalCareDays % 365;
  final months = remainingDays ~/ 30;

  if (years > 0 && months > 0) {
    return '$years ${_pluralYears(years)} $months мес.';
  } else if (years > 0) {
    return '$years ${_pluralYears(years)}';
  } else {
    final m = months < 1 ? 1 : months;
    return '$m ${_pluralMonths(m)}';
  }
}

/// Форматирует [DateTime] архивации в читаемый лейбл «месяц год».
///
/// Пример: `DateTime(2026, 4, 15)` → «апрель 2026».
/// Если дата не задана — пустая строка.
String _formatArchivedDateLabel(DateTime? archivedAt) {
  if (archivedAt == null) return '';
  final months = <int, String>{
    1: 'январь',
    2: 'февраль',
    3: 'март',
    4: 'апрель',
    5: 'май',
    6: 'июнь',
    7: 'июль',
    8: 'август',
    9: 'сентябрь',
    10: 'октябрь',
    11: 'ноябрь',
    12: 'декабрь',
  };
  final monthName = months[archivedAt.month] ?? '';
  return '$monthName ${archivedAt.year}';
}

String _pluralYears(int n) {
  final mod10 = n % 10;
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 14) return 'лет';
  if (mod10 == 1) return 'год';
  if (mod10 >= 2 && mod10 <= 4) return 'года';
  return 'лет';
}

String _pluralMonths(int n) {
  final mod10 = n % 10;
  final mod100 = n % 100;
  if (mod100 >= 11 && mod100 <= 14) return 'месяцев';
  if (mod10 == 1) return 'месяц';
  if (mod10 >= 2 && mod10 <= 4) return 'месяца';
  return 'месяцев';
}
