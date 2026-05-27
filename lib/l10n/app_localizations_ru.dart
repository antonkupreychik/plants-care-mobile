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
  String get homeTodaySeeAll => 'Посмотреть все';

  @override
  String get todayBack => 'Назад';

  @override
  String todayHeroCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сегодня $count заботы в саду',
      many: 'Сегодня $count забот в саду',
      few: 'Сегодня $count заботы в саду',
      one: 'Сегодня $count забота в саду',
      zero: 'Сегодня нет забот в саду',
    );
    return '$_temp0';
  }

  @override
  String todaySummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
      zero: 'Нет задач',
    );
    return '$_temp0';
  }

  @override
  String todaySummaryOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count просрочено',
      many: '$count просрочено',
      few: '$count просрочены',
      one: '$count просрочена',
      zero: 'нет просроченных',
    );
    return '$_temp0';
  }

  @override
  String get todayFilterAll => 'Всё';

  @override
  String get todayFilterWatering => 'Полив';

  @override
  String get todayFilterMisting => 'Опрыскивание';

  @override
  String get todayFilterFertilizing => 'Подкормка';

  @override
  String get todayFilterOverdue => 'Просрочено';

  @override
  String get todayPhaseMorning => 'Утром';

  @override
  String get todayPhaseEvening => 'Вечером';

  @override
  String todaySectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count заботы',
      many: '$count забот',
      few: '$count заботы',
      one: '$count забота',
      zero: 'нет забот',
    );
    return '$_temp0';
  }

  @override
  String get todayOverdueBadge => 'ПРОСРОЧЕНО';

  @override
  String get todayEmptyAll => 'На сегодня задач нет';

  @override
  String get todayEmptyAllHint => 'Можно выдохнуть — все растения политы';

  @override
  String get todayEmptyFilter => 'Нет задач в этой категории';

  @override
  String get todayEmptyFilterHint => 'Попробуйте другой фильтр';

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

  @override
  String get catalogTitle => 'Каталог';

  @override
  String get catalogHeading => 'Каталог растений';

  @override
  String get catalogSearchHint => 'Найти вид…';

  @override
  String get catalogSearchClear => 'Очистить поиск';

  @override
  String catalogCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вида',
      many: '$count видов',
      few: '$count вида',
      one: '$count вид',
      zero: 'Нет видов',
    );
    return '$_temp0';
  }

  @override
  String addPlantStepIndicator(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get addPlantOverline => 'Новое растение';

  @override
  String get addPlantClose => 'Закрыть';

  @override
  String get addPlantBack => 'Назад';

  @override
  String get addPlantNext => 'Далее';

  @override
  String get addPlantSkip => 'Пропустить';

  @override
  String get addPlantSubmit => 'Добавить';

  @override
  String get addPlantSpeciesTitle => 'Какое у тебя растение?';

  @override
  String get addPlantSpeciesSubtitle =>
      'Найдём вид, подберём имя и план ухода. Если не знаешь — пропусти.';

  @override
  String get addPlantSearchHint => 'монстера, фикус, суккулент…';

  @override
  String get addPlantSearchEmpty => 'Ничего не найдено';

  @override
  String get addPlantSearchEmptyHint =>
      'Попробуйте другой запрос или пропустите выбор вида';

  @override
  String get addPlantSkipSpeciesTitle => 'Не знаю, что это';

  @override
  String get addPlantSkipSpeciesHint =>
      'Заведём как «Растение». Позже уточним.';

  @override
  String get addPlantNameTitle => 'Как назовём?';

  @override
  String get addPlantNameSubtitle =>
      'Имя помогает запомнить характер растения.';

  @override
  String get addPlantNameLabel => 'Имя растения';

  @override
  String get addPlantNameHint => 'Например: Моника';

  @override
  String addPlantNameError(int max) {
    return 'Введите имя (до $max символов)';
  }

  @override
  String get addPlantRoomLabel => 'Где живёт';

  @override
  String get addPlantRoomNone => 'Без комнаты';

  @override
  String get addPlantRoomsEmpty => 'Комнат пока нет — растение попадёт в сад';

  @override
  String get addPlantCarePlanTitle => 'План ухода';

  @override
  String get addPlantCarePlanSubtitle =>
      'Рекомендации по виду. Изменить пока нельзя.';

  @override
  String get addPlantCarePlanReadOnly => 'Только просмотр';

  @override
  String addPlantCarePlanEvery(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'каждые $count дня',
      many: 'каждые $count дней',
      few: 'каждые $count дня',
      one: 'каждый день',
    );
    return '$_temp0';
  }

  @override
  String get catalogEmpty => 'Каталог пуст';

  @override
  String get catalogEmptyHint => 'Виды растений появятся здесь позже';

  @override
  String get catalogSearchEmpty => 'Ничего не найдено';

  @override
  String catalogSearchEmptyHint(String query) {
    return 'Попробуйте изменить запрос «$query»';
  }

  @override
  String get catalogLoadMoreError => 'Не удалось загрузить ещё';

  @override
  String get speciesDetailOverline => 'Вид';

  @override
  String get speciesDescriptionTitle => 'Описание';

  @override
  String get speciesCareTitle => 'Уход';

  @override
  String get speciesPropsTitle => 'Условия';

  @override
  String get speciesDifficultyLabel => 'Сложность';

  @override
  String get speciesLightLabel => 'Свет';

  @override
  String get speciesDifficultyEasy => 'Лёгкий уход';

  @override
  String get speciesDifficultyMedium => 'Средний уход';

  @override
  String get speciesDifficultyHard => 'Сложный уход';

  @override
  String get speciesDifficultyUnknown => 'Сложность не указана';

  @override
  String get speciesLightFullSun => 'Прямое солнце';

  @override
  String get speciesLightBrightIndirect => 'Яркий рассеянный';

  @override
  String get speciesLightPartialShade => 'Полутень';

  @override
  String get speciesLightShade => 'Тень';

  @override
  String get speciesLightUnknown => 'Свет не указан';

  @override
  String get speciesCareWatering => 'Полив';

  @override
  String get speciesCareMisting => 'Опрыскивание';

  @override
  String get speciesCareFertilizing => 'Подкормка';

  @override
  String get speciesCareSoilCheck => 'Проверка грунта';

  @override
  String speciesCareEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'каждые $count дня',
      many: 'каждые $count дней',
      few: 'каждые $count дня',
      one: 'каждый $count день',
    );
    return '$_temp0';
  }

  @override
  String get addPlantCarePlanEmpty =>
      'Выберите вид на первом шаге, чтобы увидеть план ухода';

  @override
  String get addPlantCarePlanNone => 'Для этого вида рекомендаций по уходу нет';

  @override
  String get addPlantConfirmTitle => 'Почти готово';

  @override
  String get addPlantConfirmSubtitle =>
      'Проверьте данные и добавьте растение в сад.';

  @override
  String get addPlantSummaryName => 'Имя';

  @override
  String get addPlantSummaryRoom => 'Комната';

  @override
  String get addPlantSummaryCarePlan => 'План ухода';

  @override
  String addPlantSummaryCarePlanCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пункта',
      many: '$count пунктов',
      few: '$count пункта',
      one: '$count пункт',
      zero: 'нет рекомендаций',
    );
    return '$_temp0';
  }

  @override
  String get addPlantNoteLabel => 'Заметка';

  @override
  String get addPlantNoteHint => 'Например: подарок на день рождения';

  @override
  String get addPlantNoteOptional => 'необязательно';

  @override
  String get addPlantSubmitted => 'Растение добавлено';

  @override
  String get careDifficultyEasy => 'Лёгкий уход';

  @override
  String get careDifficultyMedium => 'Средний уход';

  @override
  String get careDifficultyHard => 'Сложный уход';
}
