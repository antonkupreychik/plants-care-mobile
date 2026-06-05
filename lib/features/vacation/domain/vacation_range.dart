import 'package:freezed_annotation/freezed_annotation.dart';

part 'vacation_range.freezed.dart';

/// Максимальная длительность отпуска (включительно), которую принимает backend.
/// Дольше — `POST /api/v1/vacation` отдаёт `400`. Дублируется в UI для
/// предвалидации (не дёргаем сеть заведомо невалидным).
const int kVacationMaxDays = 60;

/// Диапазон дат отпуска (экран 25). Чистые «календарные» даты без времени и
/// таймзоны: [from] и [to] — это год/месяц/день, выбранные пользователем в его
/// локали. На сериализацию в backend уходит `YYYY-MM-DD` (date-only); время и
/// зона отбрасываются (FLUTTER.md «Время»: расчёт `paused_until` — за backend,
/// клиент интервалы не пересчитывает).
///
/// Чистый Dart, иммутабелен.
@freezed
abstract class VacationRange with _$VacationRange {
  const factory VacationRange({
    /// Начало отпуска (включительно), календарная дата.
    required DateTime from,

    /// Конец отпуска (включительно), календарная дата. Должен быть ≥ [from] и
    /// не дальше [kVacationMaxDays] дней от [from].
    required DateTime to,
  }) = _VacationRange;

  const VacationRange._();

  /// Количество дней отпуска (включительно обе границы). Для `from == to` → `1`.
  /// Считается по календарным датам, без учёта времени/зоны.
  int get days => _dateOnly(to).difference(_dateOnly(from)).inDays + 1;

  /// Диапазон валиден для отправки: `to >= from` и длительность в пределах
  /// [kVacationMaxDays]. Невалидный backend всё равно отвергнет (`400`) — это
  /// клиентская предвалидация, чтобы не слать заведомо плохой запрос.
  bool get isValid {
    final d = days;
    return d >= 1 && d <= kVacationMaxDays;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
