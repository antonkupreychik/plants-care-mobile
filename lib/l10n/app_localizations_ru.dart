// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get homeOverline => 'МОЙ САД';

  @override
  String get appTitle => 'PlantCare';

  @override
  String get homeSubtitle =>
      'Каркас приложения собран.\nЗдесь скоро вырастет твой сад.';

  @override
  String get buildOk => 'Сборка работает';

  @override
  String get fieldFlavor => 'Flavor';

  @override
  String get fieldApi => 'API';

  @override
  String get fieldDevAuth => 'Dev auth';

  @override
  String get homeGreeting => 'Привет';

  @override
  String get homeSearchTooltip => 'Поиск';

  @override
  String get homeNotificationsTooltip => 'Уведомления';

  @override
  String get homeTodayTitle => 'Сегодня';

  @override
  String homeTodayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count заботы',
      many: '$count забот',
      few: '$count заботы',
      one: '$count забота',
      zero: 'Нет забот',
    );
    return '$_temp0';
  }

  @override
  String get homeTasksEmpty => 'На сегодня забот нет';

  @override
  String get homeTasksEmptyHint => 'Можно выдохнуть — все растения политы';

  @override
  String get homeGardenTitle => 'Мой сад';

  @override
  String homePlantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count растения',
      many: '$count растений',
      few: '$count растения',
      one: '$count растение',
      zero: 'Нет растений',
    );
    return '$_temp0';
  }

  @override
  String get homeLocationAll => 'Все';

  @override
  String get homeGardenEmptyTitle => 'Сад пока пуст';

  @override
  String get homeGardenEmptyHint =>
      'Добавьте первое растение — и здесь появится ваш сад';

  @override
  String get homeAddPlant => 'Добавить растение';

  @override
  String get homeRoomEmpty => 'В этой комнате пока нет растений';

  @override
  String get careActionWatering => 'Полить';

  @override
  String get careActionMisting => 'Опрыскать';

  @override
  String get careActionFertilizing => 'Удобрить';

  @override
  String get careActionSoilCheck => 'Проверить почву';

  @override
  String get careActionUnknown => 'Уход';

  @override
  String get careDueOverdue => 'Просрочено';

  @override
  String get careDueToday => 'Сегодня';

  @override
  String careDueAt(String time) {
    return 'Сегодня в $time';
  }

  @override
  String get navGarden => 'Сад';

  @override
  String get navSchedule => 'График';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navProfile => 'Я';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get retry => 'Повторить';

  @override
  String get errorNetwork =>
      'Нет соединения. Проверьте интернет и попробуйте снова';

  @override
  String get errorNotFound => 'Данные не найдены';

  @override
  String get errorAccessDenied => 'Нет доступа к этим данным';

  @override
  String get errorValidation => 'Проверьте введённые данные';

  @override
  String get errorConflict => 'Данные изменились. Обновите экран';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуйте позже';

  @override
  String get plantCardOverline => 'Карточка';

  @override
  String get plantCardBack => 'Назад';

  @override
  String get plantCardMore => 'Ещё';

  @override
  String plantCardWithMeFor(String duration) {
    return 'Со мной $duration';
  }

  @override
  String plantCardAgeYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count года',
      many: '$count лет',
      few: '$count года',
      one: '$count год',
      zero: 'меньше года',
    );
    return '$_temp0';
  }

  @override
  String plantCardAgeMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count месяца',
      many: '$count месяцев',
      few: '$count месяца',
      one: '$count месяц',
      zero: 'меньше месяца',
    );
    return '$_temp0';
  }

  @override
  String scheduleWeekTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На этой неделе $count заботы в саду',
      many: 'На этой неделе $count забот в саду',
      few: 'На этой неделе $count заботы в саду',
      one: 'На этой неделе $count забота в саду',
      zero: 'На этой неделе сад отдыхает',
    );
    return '$_temp0';
  }

  @override
  String scheduleDayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
      zero: 'Свободно',
    );
    return '$_temp0';
  }

  @override
  String plantCardAgeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
      zero: 'сегодня',
    );
    return '$_temp0';
  }

  @override
  String get plantCardStreakTitle => 'Серия ухода';

  @override
  String plantCardStreakCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня подряд',
      many: '$count дней подряд',
      few: '$count дня подряд',
      one: '$count день подряд',
      zero: 'Серия прервана',
    );
    return '$_temp0';
  }

  @override
  String get plantCardStreakHint => 'Уходов вовремя подряд';

  @override
  String get plantCardStreakEmpty =>
      'Серии пока нет — начните ухаживать вовремя';

  @override
  String get plantCardNotesTitle => 'Заметки';

  @override
  String get plantCardJournalTitle => 'Дневник ухода';

  @override
  String get plantCardJournalEmpty => 'Записей пока нет';

  @override
  String get plantCardJournalEmptyHint =>
      'Отметьте первый уход — и здесь появится история';

  @override
  String get plantCardJournalOnTime => 'вовремя';

  @override
  String get plantCardLogCare => 'Отметить уход';

  @override
  String plantCardHistoryDate(String date, String time) {
    return '$date, $time';
  }

  @override
  String get careDoneWater => 'Полито';

  @override
  String get careDoneSpray => 'Опрыскано';

  @override
  String get careDoneFertilize => 'Удобрено';

  @override
  String get careDoneUnknown => 'Уход выполнен';

  @override
  String get careSheetOverline => 'Отметить уход';

  @override
  String get careSheetTitle => 'Что сделали?';

  @override
  String careSheetTitleFor(String plant) {
    return 'Уход за $plant';
  }

  @override
  String get careSheetClose => 'Закрыть';

  @override
  String get careSheetTypeLabel => 'Тип ухода';

  @override
  String get careKindWater => 'Полить';

  @override
  String get careKindSpray => 'Опрыскать';

  @override
  String get careKindFertilize => 'Удобрить';

  @override
  String get careSheetWhenLabel => 'Когда выполнили';

  @override
  String get careSheetWhenNow => 'Сейчас';

  @override
  String careSheetWhenValue(String date, String time) {
    return '$date, $time';
  }

  @override
  String get careSheetNoteLabel => 'Заметка';

  @override
  String get careSheetNoteHint => 'Например: полил(а) до поддона';

  @override
  String get careSheetNoteOptional => 'необязательно';

  @override
  String get careSheetSubmit => 'Отметить';

  @override
  String get careSheetSubmitted => 'Уход отмечен';

  @override
  String get scheduleIcsTitle => 'Подписаться в календаре';

  @override
  String get scheduleIcsSubtitle => 'Google / Apple Calendar — .ics';

  @override
  String get scheduleToCurrentWeek => 'На текущую неделю';

  @override
  String get schedulePreviousWeek => 'Предыдущая неделя';

  @override
  String get scheduleNextWeek => 'Следующая неделя';
}
