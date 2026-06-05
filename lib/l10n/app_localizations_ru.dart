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
  String get searchScreenHint => 'Искать растения, виды, болезни…';

  @override
  String get searchMinCharsHint => 'Введите минимум 2 символа';

  @override
  String get searchEmptyResult => 'Ничего не найдено';

  @override
  String get searchSectionPlants => 'Мои растения';

  @override
  String get searchSectionSpecies => 'Виды';

  @override
  String get searchSectionDiseases => 'Болезни и вредители';

  @override
  String get searchShowAll => 'Показать все';

  @override
  String get searchBack => 'Назад';

  @override
  String get homeNotificationsTooltip => 'Уведомления';

  @override
  String get homeProfileTooltip => 'Профиль';

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
  String homeTodayProgressBadge(int percent) {
    return '$percent%';
  }

  @override
  String homeTodayProgressSemantic(int percent) {
    return '$percent% выполнено';
  }

  @override
  String homeTodayProgressBarSemantic(int done, int total) {
    return 'Прогресс: $done из $total задач выполнено';
  }

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
  String todayProgress(int done, int total) {
    return '$done из $total выполнено';
  }

  @override
  String todayProgressRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось $count заботы',
      many: 'Осталось $count забот',
      few: 'Осталось $count заботы',
      one: 'Осталась $count забота',
      zero: 'Все заботы закрыты',
    );
    return '$_temp0';
  }

  @override
  String todayProgressOverdue(int count) {
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
  String todayDoneTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count выполнено сегодня',
      many: '$count выполнено сегодня',
      few: '$count выполнено сегодня',
      one: '$count выполнено сегодня',
      zero: 'Ничего не выполнено',
    );
    return '$_temp0';
  }

  @override
  String todayDoneSubtitle(String plant, String action, String time) {
    return '$plant · $action в $time';
  }

  @override
  String get todayDoneExpand => 'Показать выполненные';

  @override
  String get todayDoneCollapse => 'Скрыть выполненные';

  @override
  String careDonePast(String action, String time) {
    return '$action в $time';
  }

  @override
  String get careActionDoneWatering => 'Полито';

  @override
  String get careActionDoneMisting => 'Опрыскано';

  @override
  String get careActionDoneFertilizing => 'Удобрено';

  @override
  String get careActionDoneSoilCheck => 'Проверено';

  @override
  String get careActionDoneUnknown => 'Сделано';

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
  String get homeGardenSeeAll => 'Все';

  @override
  String get homeLocationAll => 'Все';

  @override
  String get homeAddPlant => 'Добавить растение';

  @override
  String get homeRoomEmpty => 'В этой комнате пока нет растений';

  @override
  String get homeGardenEmptyEyebrow => 'Сад пока пуст';

  @override
  String get homeGardenEmptyHeading => 'Заведём первое растение?';

  @override
  String get homeGardenEmptySubtitle =>
      'Я подберу расписание ухода и буду напоминать — так, как ты любишь.';

  @override
  String get homeRecognizeByPhoto => 'Распознать по фото';

  @override
  String get homeStarterIdeasTitle => 'Идеи на старт';

  @override
  String get homeStarterMonstera => 'Монстера';

  @override
  String get homeStarterMonsteraHint => 'легко';

  @override
  String get homeStarterSucculent => 'Суккулент';

  @override
  String get homeStarterSucculentHint => 'забыть можно';

  @override
  String get homeStarterPothos => 'Эпипремнум';

  @override
  String get homeStarterPothosHint => 'для новичка';

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
  String get errorUnauthorized => 'Сессия истекла. Войдите снова';

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
  String get scheduleWeekTasksPrefix => 'На этой неделе ';

  @override
  String scheduleWeekTasksSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' заботы в саду',
      many: ' забот в саду',
      few: ' заботы в саду',
      one: ' забота в саду',
    );
    return '$_temp0';
  }

  @override
  String get scheduleWeekRestTitle => 'На этой неделе сад отдыхает';

  @override
  String scheduleFreeDaysSubtitle(String days) {
    return '$days — свободные дни 🌳';
  }

  @override
  String get scheduleDayFree => 'Свободный день 🌿';

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
  String get scheduleTitle => 'График ухода';

  @override
  String get scheduleDayLoadHint => '—';

  @override
  String scheduleDayProgress(int done, int total) {
    return '$done из $total готово';
  }

  @override
  String get schedulePhaseMorning => 'Утро';

  @override
  String get schedulePhaseEvening => 'Вечер';

  @override
  String get schedulePhaseDone => 'Сделано';

  @override
  String get schedulePhaseMorningTime => '9:00';

  @override
  String get schedulePhaseEveningTime => '19:00';

  @override
  String get scheduleOverdueSubtitle => 'Просрочено · со вчера';

  @override
  String scheduleTaskSubtitle(String action, String species) {
    return '$action · $species';
  }

  @override
  String get scheduleDayEmpty => 'На этот день забот нет 🌿';

  @override
  String get scheduleMarkDone => 'Отметить выполненным';

  @override
  String get scheduleMarkError =>
      'Не удалось отметить уход. Попробуйте ещё раз.';

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
  String get plantCardJournalEmptyBubble => 'Жду первого ухода…';

  @override
  String get plantCardJournalWaterNow => 'Полить сейчас';

  @override
  String get plantCardJournalOnTime => 'вовремя';

  @override
  String get plantCardLogCare => 'Отметить уход';

  @override
  String plantCardHistoryDate(String date, String time) {
    return '$date, $time';
  }

  @override
  String healthBadgeLabel(int score) {
    return 'HEALTH $score';
  }

  @override
  String get healthScoreUnknown => 'HEALTH —';

  @override
  String healthSemanticScore(int score) {
    return 'Здоровье растения: $score из 100';
  }

  @override
  String get healthSemanticUnknown => 'Здоровье растения: недостаточно данных';

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
  String get careSheetWaterAmountLabel => 'Объём воды';

  @override
  String careSheetWaterAmountValue(int amount) {
    return '$amount мл';
  }

  @override
  String get careSheetWaterAmountNotSet => 'Не указан';

  @override
  String get careSheetSoilDryLabel => 'Грунт был сухой';

  @override
  String get careSheetFertilizerNameLabel => 'Название удобрения';

  @override
  String get careSheetFertilizerNameHint => 'Например: Кемира Люкс';

  @override
  String get careSheetWaterSubmit => 'Полито';

  @override
  String get careSheetSpraySubmit => 'Опрыскано';

  @override
  String get careSheetFertilizeSubmit => 'Подкормлено';

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
  String get catalogHeadingLead => 'Каталог ';

  @override
  String get catalogHeadingAccent => 'растений';

  @override
  String get catalogBadgePopular => 'HIT';

  @override
  String get catalogBadgeToxic => '⚠ ТОКСИЧНО · 🐈';

  @override
  String get catalogFilterAll => 'Все';

  @override
  String get catalogFilterBeginner => 'Для новичка';

  @override
  String get catalogFilterPetSafe => 'Безопасно для котов 🐈';

  @override
  String get catalogFilterFlowering => 'Цветущие';

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
      'Рекомендации по виду. Измените интервалы, если нужно.';

  @override
  String get addPlantCarePlanReadOnly =>
      'После создания расписание можно настроить под себя';

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
  String speciesWateringEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'раз в $count дн.',
      many: 'раз в $count дн.',
      few: 'раз в $count дн.',
      one: 'раз в $count дн.',
    );
    return '$_temp0';
  }

  @override
  String get speciesFactDifficulty => 'Сложность';

  @override
  String get speciesFactLight => 'Свет';

  @override
  String get speciesFactWatering => 'Полив';

  @override
  String get speciesToxicTitle => 'Токсично для кошек, собак и детей';

  @override
  String get speciesToxicSubtitle =>
      'Сок листьев раздражает слизистую. Держите повыше.';

  @override
  String get speciesLightTitle => 'Свет';

  @override
  String get speciesLightStepShade => 'Тень';

  @override
  String get speciesLightStepPartial => 'Полутень';

  @override
  String get speciesLightStepIndirect => 'Рассеянный';

  @override
  String get speciesLightStepDirect => 'Прямое';

  @override
  String get speciesAddToGarden => 'Добавить в мой сад';

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
  String get addPlantSubmitGarden => 'Добавить в сад';

  @override
  String get addPlantRecognizeBadge => 'ФОТО';

  @override
  String get addPlantRecognizeHint => 'Сфотографируй — определим по листу';

  @override
  String get addPlantRecognizeUnavailable =>
      'Распознавание по фото скоро появится';

  @override
  String get addPlantCategoryPopular => 'Популярное';

  @override
  String get addPlantCategoryBeginner => 'Для новичка';

  @override
  String get addPlantCategoryFlowering => 'Цветущие';

  @override
  String get addPlantCategoryLowWater => 'Без полива';

  @override
  String get addPlantNewRoom => 'Добавить своё помещение';

  @override
  String get addPlantPhotoTitle => 'Сделай портрет';

  @override
  String get addPlantPhotoOverline => 'Последний штрих';

  @override
  String get addPlantPhotoSubtitle =>
      'Фото поможет узнать растение и отслеживать его рост.';

  @override
  String get addPlantPhotoPlaceholder => 'Пока используется иллюстрация';

  @override
  String get addPlantPhotoCamera => 'Камера';

  @override
  String get addPlantPhotoGallery => 'Из галереи';

  @override
  String get addPlantPhotoUnavailable => 'Загрузка фото скоро появится';

  @override
  String get addPlantWindowLabel => 'Куда смотрит окно';

  @override
  String get addPlantWindowOptional => 'необязательно';

  @override
  String get addPlantWindowSouth => 'Юг';

  @override
  String get addPlantWindowSouthHint => 'много солнца';

  @override
  String get addPlantWindowEast => 'Восток';

  @override
  String get addPlantWindowEastHint => 'мягкое утро';

  @override
  String get addPlantWindowWest => 'Запад';

  @override
  String get addPlantWindowWestHint => 'тёплый вечер';

  @override
  String get addPlantWindowNorth => 'Север';

  @override
  String get addPlantWindowNorthHint => 'мало света';

  @override
  String get careDifficultyEasy => 'Лёгкий уход';

  @override
  String get careDifficultyMedium => 'Средний уход';

  @override
  String get careDifficultyHard => 'Сложный уход';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileOverline => 'НАСТРОЙКИ';

  @override
  String get profileSectionMore => 'Ещё';

  @override
  String get profileAnonymous => 'Пользователь';

  @override
  String profileMemberSince(String date) {
    return 'С нами с $date';
  }

  @override
  String get profileStatPlants => 'Растения';

  @override
  String get profileStatCareEvents => 'Уходов';

  @override
  String get profileSectionReferences => 'Справочники';

  @override
  String get profileDiseasesTitle => 'Болезни и вредители';

  @override
  String get profileCatalogTitle => 'Каталог видов';

  @override
  String get profileSearchTitle => 'Поиск';

  @override
  String get profileRoomsTitle => 'Дома и места';

  @override
  String get profileSignOut => 'Выйти';

  @override
  String get profileSignOutConfirmTitle => 'Выйти из аккаунта?';

  @override
  String get profileSignOutConfirmMessage =>
      'Вы вернётесь к экрану входа. Чтобы снова открыть свой сад, понадобится войти по почте.';

  @override
  String get profileSignOutConfirmCancel => 'Отмена';

  @override
  String get profileSignOutConfirmAction => 'Выйти';

  @override
  String get roomsTitle => 'Дома и места';

  @override
  String get roomsOverline => 'МОИ КОМНАТЫ';

  @override
  String get roomsBack => 'Назад';

  @override
  String roomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count комнаты',
      many: '$count комнат',
      few: '$count комнаты',
      one: '$count комната',
      zero: 'Нет комнат',
    );
    return '$_temp0';
  }

  @override
  String get roomsDefaultBadge => 'По умолчанию';

  @override
  String get roomsAdd => 'Добавить комнату';

  @override
  String get roomsEditAction => 'Изменить';

  @override
  String get roomsDeleteAction => 'Удалить';

  @override
  String get roomsEmptyTitle => 'Комнат пока нет';

  @override
  String get roomsEmptyHint =>
      'Добавьте комнату, чтобы группировать растения по местам';

  @override
  String get roomSheetCreateOverline => 'Новая комната';

  @override
  String get roomSheetEditOverline => 'Комната';

  @override
  String get roomSheetCreateTitle => 'Добавить комнату';

  @override
  String get roomSheetEditTitle => 'Изменить комнату';

  @override
  String get roomSheetClose => 'Закрыть';

  @override
  String get roomSheetNameLabel => 'Название';

  @override
  String get roomSheetNameHint => 'Например: Гостиная';

  @override
  String roomSheetNameError(int max) {
    return 'Введите название (до $max символов)';
  }

  @override
  String get roomSheetEmojiLabel => 'Эмодзи';

  @override
  String get roomSheetEmojiHint => '🪴';

  @override
  String get roomSheetEmojiOptional => 'необязательно';

  @override
  String get roomSheetCreateSubmit => 'Добавить';

  @override
  String get roomSheetEditSubmit => 'Сохранить';

  @override
  String get roomCreated => 'Комната добавлена';

  @override
  String get roomUpdated => 'Комната обновлена';

  @override
  String get roomDeleted => 'Комната удалена';

  @override
  String get roomDeleteConfirmTitle => 'Удалить комнату?';

  @override
  String roomDeleteConfirmMessage(String name) {
    return 'Комната «$name» будет удалена.';
  }

  @override
  String get roomDeleteConfirmCancel => 'Отмена';

  @override
  String get roomDeleteConfirmDelete => 'Удалить';

  @override
  String get roomMoveOverline => 'Перенос растений';

  @override
  String get roomMoveTitle => 'Куда перенести растения?';

  @override
  String roomMoveSubtitle(String name) {
    return 'В комнате «$name» есть растения. Выберите, куда их перенести перед удалением.';
  }

  @override
  String get roomMoveClose => 'Закрыть';

  @override
  String get profileAuthPreviewTitle => 'Экраны входа (превью)';

  @override
  String get authBack => 'Назад';

  @override
  String get authBrand => 'PlantCare';

  @override
  String get authLocale => 'RU';

  @override
  String get authWelcomeOverline => 'Дневник для растений';

  @override
  String get authWelcomeTitle => 'Растения, о которых не забывают';

  @override
  String get authWelcomeSubtitle =>
      'Напоминания о поливе, опрыскивании и подкормке. Прямо как от заботливой бабушки — но цифровой.';

  @override
  String get authContinueGoogle => 'Продолжить через Google';

  @override
  String get authContinueApple => 'Продолжить через Apple';

  @override
  String get authSocialError => 'Не удалось войти. Попробуйте ещё раз.';

  @override
  String get authContinueTelegram => 'Продолжить через Telegram';

  @override
  String get authOr => 'или';

  @override
  String get authContinueGuest => 'Зайти как гость';

  @override
  String get authTerms =>
      'Нажимая «Продолжить», вы соглашаетесь с условиями и политикой конфиденциальности.';

  @override
  String get authCodeStepIndicator => 'Шаг 2 из 2';

  @override
  String get authCodeOverline => 'Telegram · подтверждение';

  @override
  String get authCodeTitle => 'Введите код из чата с ботом';

  @override
  String authCodeSubtitle(String bot) {
    return 'Мы написали вам в $bot. Откройте Telegram и скопируйте 6-значный код.';
  }

  @override
  String get authCodeBot => '@PlantCareBot';

  @override
  String authResendIn(String seconds) {
    return 'Отправить новый код через $seconds';
  }

  @override
  String get authResend => 'Отправить код повторно';

  @override
  String get authKeypadBackspace => 'Удалить цифру';

  @override
  String authKeypadDigit(String digit) {
    return 'Цифра $digit';
  }

  @override
  String get authContinue => 'Продолжить';

  @override
  String get authWelcomeBackOverline => 'Аккаунт привязан · Telegram';

  @override
  String get authWelcomeBackName => 'Алина';

  @override
  String authWelcomeBackTitle(String name) {
    return 'Привет, $name';
  }

  @override
  String get authWelcomeBackSubtitle =>
      'Тут будет жить ваш сад. Добавим первое растение — и научимся его понимать.';

  @override
  String get authChipReminders => 'Напоминания';

  @override
  String get authChipJournal => 'Дневник';

  @override
  String get authChipCalendar => 'Календарь';

  @override
  String get authAddFirstPlant => 'Добавить первое растение';

  @override
  String get authGoHome => 'Я просто посмотрю';

  @override
  String get authEmailTitle => 'Вход по почте';

  @override
  String get authEmailSubtitle =>
      'Введите адрес — пришлём ссылку для входа. Пароль не нужен.';

  @override
  String get authEmailLabel => 'Электронная почта';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authEmailInvalid => 'Проверьте адрес почты';

  @override
  String get authSendLink => 'Получить ссылку';

  @override
  String get authLinkSentTitle => 'Проверьте почту';

  @override
  String get authLinkSentSubtitle =>
      'Мы отправили ссылку для входа. Откройте её на этом устройстве.';

  @override
  String get authVerifying => 'Проверяем ссылку…';

  @override
  String get authVerifyError =>
      'Ссылка недействительна или устарела. Запросите новую.';

  @override
  String get authVerifyRetry => 'Вернуться ко входу';

  @override
  String get authDevTokenLabel => 'Dev: вставить токен';

  @override
  String get profileArchiveTitle => 'Архив';

  @override
  String get archiveBack => 'Назад';

  @override
  String archiveEyebrow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count растения',
      many: '$count растений',
      few: '$count растения',
      one: '$count растение',
      zero: 'нет растений',
    );
    return 'Архив · $_temp0';
  }

  @override
  String get archiveHeadingLead => 'В ';

  @override
  String get archiveHeadingAccent => 'памяти';

  @override
  String get archiveSubtitle =>
      'Растения, с которыми пути разошлись. Их история — здесь, а не в корзине.';

  @override
  String get archiveLivedPrefixGifted => 'Прожил рядом ·';

  @override
  String get archiveLivedPrefix => 'Прожило рядом ·';

  @override
  String get archiveOpenDiary => 'Открыть дневник';

  @override
  String get archiveRemember => 'Вспомнить';

  @override
  String get archiveRetrospectiveLabel => 'Ретроспектива';

  @override
  String archiveRetrospectiveText(String avg) {
    return 'Растения живут с тобой в среднем $avg';
  }

  @override
  String get archiveRetrospectiveHint =>
      'Это нормально. Каждое — память и опыт.';

  @override
  String get archiveEmpty => 'Архив пуст';

  @override
  String get archiveEmptyHint =>
      'Здесь появятся растения, с которыми ваши пути разойдутся.';

  @override
  String weatherHumidity(int humidity) {
    return 'Влажность $humidity%';
  }

  @override
  String get weatherAdviceDeferOk => 'Влажно — полив можно отложить';

  @override
  String get weatherAdviceDoNotDefer => 'Сухо — не пропускай полив';

  @override
  String weatherSemanticsWithAdvice(int humidity, String advice) {
    return 'Погода: влажность $humidity%, $advice';
  }

  @override
  String weatherSemanticsHumidityOnly(int humidity) {
    return 'Погода: влажность $humidity%';
  }

  @override
  String get homeLoadingCaption => 'Собираю твой сад…';

  @override
  String get offlineBannerTitle => 'Нет связи с садом';

  @override
  String get offlineBannerStatus => 'офлайн';

  @override
  String get offlineTitleLead => 'Сад на минутку ';

  @override
  String get offlineTitleAccent => 'вне зоны';

  @override
  String get offlineMessage =>
      'Не получается достучаться до сервера. Проверь интернет — твои растения никуда не денутся.';

  @override
  String get firstCareSuccessEyebrow => 'Готово';

  @override
  String firstCareSuccessTitleWater(String plant) {
    return '$plant напоена';
  }

  @override
  String firstCareSuccessTitleSpray(String plant) {
    return '$plant опрыскана';
  }

  @override
  String firstCareSuccessTitleFertilize(String plant) {
    return '$plant удобрена';
  }

  @override
  String firstCareSuccessTitleGeneric(String plant) {
    return '$plant — уход отмечен';
  }

  @override
  String get firstCareSuccessVerbWater => 'напоена';

  @override
  String get firstCareSuccessVerbSpray => 'опрыскана';

  @override
  String get firstCareSuccessVerbFertilize => 'удобрена';

  @override
  String get firstCareSuccessBubble => '«Спасибо! Ты мой лучший садовник 🌿»';

  @override
  String get firstCareSuccessFallbackPlantName => 'Растение';

  @override
  String get firstCareSuccessStreakDayOne => 'День 1 🔥';

  @override
  String get firstCareSuccessNextHint =>
      'Я напомню, когда придёт время следующего ухода.';

  @override
  String get firstCareSuccessNextPrefixWater => 'Следующий полив — ';

  @override
  String get firstCareSuccessNextPrefixSpray => 'Следующее опрыскивание — ';

  @override
  String get firstCareSuccessNextPrefixFertilize => 'Следующая подкормка — ';

  @override
  String get firstCareSuccessNextSuffix => ', напомню сама';

  @override
  String get firstCareSuccessCta => 'Отлично';

  @override
  String get careHistoryOverline => 'Дневник ухода';

  @override
  String get careHistoryViewAll => 'Всё';

  @override
  String get careHistorySummaryTotalLabel => 'забот\nвсего';

  @override
  String careHistorySummaryTotalValue(int count) {
    return '$count';
  }

  @override
  String get careHistorySummaryOnTimeLabel => 'вовремя';

  @override
  String careHistorySummaryOnTimeValue(int percent) {
    return '$percent%';
  }

  @override
  String get careHistorySummaryStreakLabel => 'дней\nстрик';

  @override
  String careHistorySummaryStreakValue(int count) {
    return '$count';
  }

  @override
  String get careHistoryFilterAll => 'Всё';

  @override
  String careHistoryEntryDate(String dow, String day, String time) {
    return '$dow $day · $time';
  }

  @override
  String get careHistoryOnTime => 'ВОВРЕМЯ';

  @override
  String get careHistoryLate => 'С ОПОЗДАНИЕМ';

  @override
  String careHistoryPlantCreated(String name, String date) {
    return '$name появилась у тебя · $date';
  }

  @override
  String get careHistoryLoadMore => 'Показать ещё';

  @override
  String get careHistoryLoadMoreError => 'Не удалось дозагрузить историю';

  @override
  String get careHistoryEmptyTitle => 'История';

  @override
  String get careHistoryEmptyTitleAccent => 'только начинается';

  @override
  String get careHistoryEmptyBubble =>
      'Я только переехал к тебе. Отметь первый уход — и начнём вести историю вместе.';

  @override
  String careHistoryEmptyAuthor(String name) {
    return '— $name';
  }

  @override
  String get careHistoryEmptyCta => 'Отметить первый уход';

  @override
  String get profileReportTitle => 'Месячный отчёт';

  @override
  String get reportShare => 'Поделиться';

  @override
  String get reportBack => 'Назад';

  @override
  String get reportPrevMonth => 'Предыдущий месяц';

  @override
  String get reportNextMonth => 'Следующий месяц';

  @override
  String reportOverline(String month) {
    return 'Отчёт · $month';
  }

  @override
  String get reportTitleGreat => 'Месяц прошёл отлично';

  @override
  String get reportTitleGood => 'Хороший месяц';

  @override
  String get reportTitleNeutral => 'Итоги месяца';

  @override
  String reportSubtitleStreak(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak дня',
      many: '$streak дней',
      few: '$streak дня',
      one: '$streak день',
    );
    return 'Стрик $_temp0 заботы подряд. Так держать.';
  }

  @override
  String get reportSubtitleNoStreak =>
      'Понемногу складывается твоя история заботы.';

  @override
  String get reportStatStreak => 'дней\nподряд';

  @override
  String get reportStatDone => 'забот\nвыполнено';

  @override
  String get reportStatOnTime => 'вовремя';

  @override
  String get reportStatOverdue => 'пропусков';

  @override
  String get reportNoData => '—';

  @override
  String reportPercent(int value) {
    return '$value%';
  }

  @override
  String get reportByTypeLabel => 'По типам заботы';

  @override
  String get reportTrendLabel => 'По неделям';

  @override
  String reportTrendWeekDone(int done) {
    String _temp0 = intl.Intl.pluralLogic(
      done,
      locale: localeName,
      other: '$done заботы',
      many: '$done забот',
      few: '$done заботы',
      one: '$done забота',
    );
    return '$_temp0';
  }

  @override
  String reportWeekLabel(String number) {
    return 'Нед. $number';
  }

  @override
  String get reportShareCta => 'Поделиться отчётом';

  @override
  String reportShareTextHeader(String month) {
    return '🌿 Мой отчёт за $month';
  }

  @override
  String reportShareTextCares(int count) {
    return 'Обработано уходов: $count';
  }

  @override
  String reportShareTextOnTime(int pct) {
    return 'Вовремя: $pct%';
  }

  @override
  String get reportShareTextAppCredit => 'Plants Care App';

  @override
  String get reportEmptyTitle => 'Пока пусто';

  @override
  String get reportEmptyBody =>
      'За этот месяц ещё нет заботы. Отметь первый уход — и здесь появятся твои итоги.';

  @override
  String editScheduleOverline(String plant) {
    return 'Расписание · $plant';
  }

  @override
  String get editScheduleTitle => 'Как часто заботиться?';

  @override
  String get editScheduleSubtitle => 'Интервалы влияют на напоминания и стрик';

  @override
  String get editScheduleDone => 'Готово';

  @override
  String get editScheduleBack => 'Назад';

  @override
  String get editScheduleNextCare => 'Следующий уход';

  @override
  String get editScheduleDisabled => 'Выключено';

  @override
  String get editScheduleEvery => 'Каждые';

  @override
  String get editScheduleWaterAmount => 'Объём воды';

  @override
  String editScheduleDaysUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дн.',
      many: '$count дн.',
      few: '$count дн.',
      one: '$count дн.',
    );
    return '$_temp0';
  }

  @override
  String editScheduleMlUnit(int count) {
    return '$count мл';
  }

  @override
  String get editScheduleAmountUnset => '—';

  @override
  String get editScheduleDueToday => 'сегодня';

  @override
  String get editScheduleDueTomorrow => 'завтра';

  @override
  String get editScheduleDueOverdue => 'просрочено';

  @override
  String editScheduleDueInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'через $count дн.',
      many: 'через $count дн.',
      few: 'через $count дн.',
      one: 'через $count дн.',
    );
    return '$_temp0';
  }

  @override
  String get editScheduleResetTitle => 'Сбросить к рекомендованным';

  @override
  String get editScheduleResetSubtitle =>
      'Интервалы из каталога для вашего вида';

  @override
  String get editScheduleNote =>
      '«Летом я пью чаще — можешь поставить полив раз в 5 дней, а зимой вернуть на 9.»';

  @override
  String get editScheduleEmptyTitle => 'Расписаний пока нет';

  @override
  String get editScheduleEmptyBody =>
      'Для этого растения ещё не настроены интервалы ухода.';

  @override
  String get editScheduleSaveError =>
      'Не удалось сохранить расписание. Попробуй ещё раз.';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String notificationsHeroCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новых от твоего сада',
      many: '$count новых от твоего сада',
      few: '$count новых от твоего сада',
      one: '$count новое от твоего сада',
      zero: 'Пока тихо в твоём саду',
    );
    return '$_temp0';
  }

  @override
  String get notificationsMarkAllRead => 'Прочитать';

  @override
  String get notificationsGroupToday => 'Сегодня';

  @override
  String get notificationsGroupYesterday => 'Вчера';

  @override
  String notificationsTimeAt(String time) {
    return 'в $time';
  }

  @override
  String get notificationsLoadMoreError => 'Не удалось дозагрузить уведомления';

  @override
  String get notificationsUnreadSemantic => 'непрочитано';

  @override
  String get notificationsTypeCare => 'Уход';

  @override
  String get notificationsTypeAlert => 'Тревога';

  @override
  String get notificationsTypeAward => 'Достижение';

  @override
  String get notificationsTypeReport => 'Отчёт';

  @override
  String get notificationsTypeSystem => 'Системное';

  @override
  String get notificationsEmptyTitleLead => 'Пока ';

  @override
  String get notificationsEmptyTitleAccent => 'тихо';

  @override
  String get notificationsEmptyMessage =>
      'Все растения довольны — ни одной заботы не пропущено. Загляну сюда, когда кому-то понадобится внимание.';

  @override
  String get notificationsEmptyChip => 'Сад в порядке';

  @override
  String notificationsBadgeTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Уведомления: $count непрочитанных',
      many: 'Уведомления: $count непрочитанных',
      few: 'Уведомления: $count непрочитанных',
      one: 'Уведомления: $count непрочитанное',
      zero: 'Уведомления',
    );
    return '$_temp0';
  }

  @override
  String get plantCardScheduleTitle => 'Расписание ухода';

  @override
  String get plantCardScheduleEdit => 'Изменить';

  @override
  String get profileNotificationsTitle => 'Уведомления и время';

  @override
  String get quietHoursBack => 'Назад';

  @override
  String get quietHoursOverline => 'Уведомления и время';

  @override
  String get quietHoursTitleLead => 'Тихие ';

  @override
  String get quietHoursTitleAccent => 'часы';

  @override
  String get quietHoursSubtitle =>
      'Ночью растения подождут до утра — не разбудят пушем.';

  @override
  String quietHoursRingCount(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours часа тишины',
      many: '$hours часов тишины',
      few: '$hours часа тишины',
      one: '$hours час тишины',
    );
    return '$_temp0';
  }

  @override
  String get quietHoursLegendOn => 'Напоминания идут';

  @override
  String get quietHoursLegendQuiet => 'Тишина';

  @override
  String get quietHoursStartLabel => 'Засыпаю в';

  @override
  String get quietHoursEndLabel => 'Просыпаюсь в';

  @override
  String get quietHoursParamsSection => 'Параметры';

  @override
  String get quietHoursTimezoneTitle => 'Таймзона';

  @override
  String quietHoursTimezoneValue(String city, String gmt) {
    return '$city · $gmt';
  }

  @override
  String get quietHoursDndTitle => 'Не беспокоить ночью';

  @override
  String get quietHoursDndSubtitle => 'Перенести просроченное на утро';

  @override
  String get quietHoursDigestTitle => 'Утренний дайджест';

  @override
  String get quietHoursDigestSubtitle => 'Все заботы дня одним сообщением';

  @override
  String get quietHoursDigestTime => '9:00';

  @override
  String get quietHoursSoon => 'Скоро';

  @override
  String get quietHoursQuote =>
      '«Если меня надо полить в 3 ночи — напомню в 8 утра. Спи спокойно.»';

  @override
  String get quietHoursSaveError => 'Не удалось сохранить. Попробуй ещё раз.';

  @override
  String get timePickerStartOverline => 'Тихие часы начинаются';

  @override
  String get timePickerEndOverline => 'Тихие часы заканчиваются';

  @override
  String get timePickerStartTitle => 'Засыпаю в';

  @override
  String get timePickerEndTitle => 'Просыпаюсь в';

  @override
  String get timePickerDone => 'Готово';

  @override
  String get timezoneBack => 'Назад';

  @override
  String get timezoneOverline => 'Таймзона';

  @override
  String get timezoneTitleLead => 'Когда у тебя ';

  @override
  String get timezoneTitleAccent => 'утро';

  @override
  String get timezoneTitleTail => '?';

  @override
  String get timezoneSearchHint => 'Город или регион…';

  @override
  String get timezoneSectionRussia => 'Россия';

  @override
  String get timezoneEmpty => 'Ничего не найдено';

  @override
  String get timezoneSelectedHint => 'Выбрано';

  @override
  String get profileShoppingTitle => 'Список покупок';

  @override
  String get shoppingTitle => 'Список покупок';

  @override
  String shoppingHeroSummary(int total, int bought) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total позиций · $bought куплено',
      many: '$total позиций · $bought куплено',
      few: '$total позиции · $bought куплено',
      one: '$total позиция · $bought куплено',
      zero: 'Список пуст',
    );
    return '$_temp0';
  }

  @override
  String get shoppingAddItem => 'Добавить позицию';

  @override
  String get shoppingAddSheetOverline => 'Список покупок';

  @override
  String get shoppingAddSheetTitle => 'Новая позиция';

  @override
  String get shoppingAddSheetLabel => 'Что купить';

  @override
  String get shoppingAddSheetHint => 'Например, грунт для суккулентов';

  @override
  String get shoppingAddSheetSubmit => 'Добавить';

  @override
  String get shoppingItemDelete => 'Удалить позицию';

  @override
  String get shoppingItemToggle => 'Отметить купленным';

  @override
  String get shoppingItemDeleted => 'Позиция удалена';

  @override
  String get shoppingEmptyTitleLead => 'Список ';

  @override
  String get shoppingEmptyTitleAccent => 'пуст';

  @override
  String get shoppingEmptyMessage =>
      'Здесь будут вещи для твоих растений — грунт, горшки, удобрения. Добавь первую позицию.';

  @override
  String get diagnosisRetry => 'Повторить';

  @override
  String get diagnosisBadgeWarning => '⚠ Что‑то не так';

  @override
  String get diagnosisHealthyTitle => 'Всё в порядке';

  @override
  String get diagnosisHealthyMessage =>
      'Растение здорово — проблем не обнаружено';

  @override
  String get diagnosisTitleIssues => 'Проблемы';

  @override
  String get diagnosisSeverityHigh => 'Критично';

  @override
  String get diagnosisSeverityMedium => 'Умеренно';

  @override
  String get diagnosisSeverityLow => 'Незначительно';

  @override
  String get diagnosisSeverityUnknown => '—';

  @override
  String get diagnosisTitleRecommendations => 'Рекомендации';

  @override
  String get diagnosisErrorMessage => 'Не удалось загрузить диагноз';

  @override
  String catalogSearchEmptyTitle(String query) {
    return 'Не нашли «$query»';
  }

  @override
  String get catalogSearchEmptyMessage =>
      'Возможно, опечатка. Попробуй иначе или загляни в популярное.';

  @override
  String get catalogSuggestionsTitle => 'Может, ты искал(а)';

  @override
  String get catalogNotInCatalogTitle => 'Нет в каталоге?';

  @override
  String get catalogNotInCatalogHint =>
      'Заведи растение вручную — расписание настроишь сам(а).';

  @override
  String get catalogNotInCatalogAdd => 'Добавить';

  @override
  String get languageScreenTitle => 'Язык / Language';

  @override
  String get languageBack => 'Назад';

  @override
  String get languageScreenTitleLead => 'Язык ';

  @override
  String get languageScreenTitleAccent => 'приложения';

  @override
  String get languageScreenSubtitle =>
      'Реплики растений тоже переведём — характер сохранится';

  @override
  String get languageScreenHint =>
      'Дату и время форматируем по выбранному языку.';

  @override
  String get editPlantTitle => 'Редактировать';

  @override
  String get editPlantSave => 'Сохранить';

  @override
  String get editPlantNameLabel => 'Название';

  @override
  String get editPlantNotesLabel => 'Заметки';

  @override
  String get editPlantLocationLabel => 'Комната';

  @override
  String get editPlantSpeciesLabel => 'Вид';

  @override
  String get editPlantSpeciesNone => 'Без вида';

  @override
  String get editPlantSuccessSnackbar => 'Изменения сохранены';

  @override
  String get diseaseCatalogTitle => 'Болезни и вредители';

  @override
  String get diseaseCatalogSearchHint => 'Поиск по названию или симптому';

  @override
  String get diseaseCatalogSearchClear => 'Очистить поиск';

  @override
  String get diseaseCatalogEmpty => 'Болезни не найдены';

  @override
  String get diseaseDetailSymptomsTitle => 'Симптомы';

  @override
  String get diseaseDetailTreatmentTitle => 'Лечение';

  @override
  String get diseaseDetailPreventionTitle => 'Профилактика';

  @override
  String get plantCardMenuEdit => 'Редактировать';

  @override
  String get archivePlantMenuLabel => 'В архив';

  @override
  String get archivePlantConfirmTitle => 'Отправить в архив?';

  @override
  String get archivePlantConfirmBody =>
      'Растение переместится в архив. Вернуть его в список можно будет из экрана «Архив».';

  @override
  String get archivePlantConfirmAction => 'Архивировать';

  @override
  String get archivePlantSuccess => 'Растение перемещено в архив';

  @override
  String get cancel => 'Отмена';
}
