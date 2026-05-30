import '../../../l10n/app_localizations.dart';

/// UI-форматирование уже посчитанного backend момента следующего ухода
/// (`PlantCareSchedule.nextDueAt`) в относительную подпись: просрочено /
/// сегодня / завтра / через N дн.
///
/// Это НЕ доменный расчёт расписаний (FLUTTER.md «Время»): интервал и сам
/// `nextDueAt` считает backend, клиент лишь переводит UTC → локаль и
/// форматирует разницу в днях. Аналог `PlantHero._ageLabel` (UI-формат уже
/// имеющейся даты).
///
/// Проектного готового хелпера «через N дн.» нет: `CareTaskL10n.dueLabel`
/// форматирует «сегодня в HH:mm / просрочено» (для задач Today, без «через N
/// дн.»), `PlantHero._ageLabel` — длительность владения. Поэтому здесь — свой
/// узкий форматтер на готовых l10n-ключах экрана 22.
String? nextDueLabel(
  AppLocalizations l10n,
  DateTime? nextDueAt,
  DateTime nowLocal,
) {
  if (nextDueAt == null) return null;
  final due = nextDueAt.toLocal();
  // Сравниваем по календарным дням (полночь локали), а не по моменту:
  // «через 0 дней» == сегодня, отрицательное == просрочено.
  final dueDay = DateTime(due.year, due.month, due.day);
  final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
  final diffDays = dueDay.difference(today).inDays;

  if (diffDays < 0) return l10n.editScheduleDueOverdue;
  if (diffDays == 0) return l10n.editScheduleDueToday;
  if (diffDays == 1) return l10n.editScheduleDueTomorrow;
  return l10n.editScheduleDueInDays(diffDays);
}
