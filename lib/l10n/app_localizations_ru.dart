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

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileOverline => 'НАСТРОЙКИ';

  @override
  String get profileSectionMore => 'Ещё';

  @override
  String get profileRoomsTitle => 'Дома и места';

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
}
