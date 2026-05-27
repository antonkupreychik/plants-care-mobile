import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ru')];

  /// Надзаголовок-капс над приветствием на главном экране
  ///
  /// In ru, this message translates to:
  /// **'МОЙ САД'**
  String get homeOverline;

  /// Название приложения (hero-заголовок)
  ///
  /// In ru, this message translates to:
  /// **'PlantCare'**
  String get appTitle;

  /// Подпись под названием на экране-заглушке каркаса
  ///
  /// In ru, this message translates to:
  /// **'Каркас приложения собран.\nЗдесь скоро вырастет твой сад.'**
  String get homeSubtitle;

  /// Заголовок диагностической карточки сборки
  ///
  /// In ru, this message translates to:
  /// **'Сборка работает'**
  String get buildOk;

  /// Метка строки: окружение сборки (dev/prod)
  ///
  /// In ru, this message translates to:
  /// **'Flavor'**
  String get fieldFlavor;

  /// Метка строки: базовый URL API
  ///
  /// In ru, this message translates to:
  /// **'API'**
  String get fieldApi;

  /// Метка строки: dev-заголовки идентификации (chat/user)
  ///
  /// In ru, this message translates to:
  /// **'Dev auth'**
  String get fieldDevAuth;

  /// Приветствие в шапке главного экрана
  ///
  /// In ru, this message translates to:
  /// **'Привет'**
  String get homeGreeting;

  /// Подсказка для иконки поиска в шапке
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get homeSearchTooltip;

  /// Подсказка для иконки уведомлений в шапке
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get homeNotificationsTooltip;

  /// Надзаголовок карточки задач на сегодня
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get homeTodayTitle;

  /// Количество задач ухода на сегодня
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Нет забот} one{{count} забота} few{{count} заботы} many{{count} забот} other{{count} заботы}}'**
  String homeTodayTasksCount(int count);

  /// Пустое состояние секции задач на сегодня
  ///
  /// In ru, this message translates to:
  /// **'На сегодня забот нет'**
  String get homeTasksEmpty;

  /// Подпись к пустому состоянию задач на сегодня
  ///
  /// In ru, this message translates to:
  /// **'Можно выдохнуть — все растения политы'**
  String get homeTasksEmptyHint;

  /// Семантика/подсказка: открыть полный экран задач на сегодня
  ///
  /// In ru, this message translates to:
  /// **'Посмотреть все'**
  String get homeTodaySeeAll;

  /// Семантика кнопки возврата в шапке экрана «Сегодня»
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get todayBack;

  /// Крупный serif-заголовок экрана «Сегодня» с числом задач
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Сегодня нет забот в саду} one{Сегодня {count} забота в саду} few{Сегодня {count} заботы в саду} many{Сегодня {count} забот в саду} other{Сегодня {count} заботы в саду}}'**
  String todayHeroCount(int count);

  /// Сводка экрана «Сегодня»: всего задач
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Нет задач} one{{count} задача} few{{count} задачи} many{{count} задач} other{{count} задачи}}'**
  String todaySummary(int count);

  /// Сводка экрана «Сегодня»: сколько просрочено
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{нет просроченных} one{{count} просрочена} few{{count} просрочены} many{{count} просрочено} other{{count} просрочено}}'**
  String todaySummaryOverdue(int count);

  /// Фильтр-пилюля: все задачи
  ///
  /// In ru, this message translates to:
  /// **'Всё'**
  String get todayFilterAll;

  /// Фильтр-пилюля: полив
  ///
  /// In ru, this message translates to:
  /// **'Полив'**
  String get todayFilterWatering;

  /// Фильтр-пилюля: опрыскивание
  ///
  /// In ru, this message translates to:
  /// **'Опрыскивание'**
  String get todayFilterMisting;

  /// Фильтр-пилюля: подкормка
  ///
  /// In ru, this message translates to:
  /// **'Подкормка'**
  String get todayFilterFertilizing;

  /// Фильтр-пилюля: просроченные
  ///
  /// In ru, this message translates to:
  /// **'Просрочено'**
  String get todayFilterOverdue;

  /// Заголовок секции задач: утро
  ///
  /// In ru, this message translates to:
  /// **'Утром'**
  String get todayPhaseMorning;

  /// Заголовок секции задач: вечер
  ///
  /// In ru, this message translates to:
  /// **'Вечером'**
  String get todayPhaseEvening;

  /// Счётчик задач в заголовке секции фазы (утро/вечер)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{нет забот} one{{count} забота} few{{count} заботы} many{{count} забот} other{{count} заботы}}'**
  String todaySectionCount(int count);

  /// Бейдж на карточке задачи: задача просрочена
  ///
  /// In ru, this message translates to:
  /// **'ПРОСРОЧЕНО'**
  String get todayOverdueBadge;

  /// Пустое состояние экрана «Сегодня» при фильтре «Всё»
  ///
  /// In ru, this message translates to:
  /// **'На сегодня задач нет'**
  String get todayEmptyAll;

  /// Подпись к пустому состоянию при фильтре «Всё»
  ///
  /// In ru, this message translates to:
  /// **'Можно выдохнуть — все растения политы'**
  String get todayEmptyAllHint;

  /// Пустое состояние экрана «Сегодня» при активном фильтре
  ///
  /// In ru, this message translates to:
  /// **'Нет задач в этой категории'**
  String get todayEmptyFilter;

  /// Подсказка к пустому состоянию при активном фильтре
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте другой фильтр'**
  String get todayEmptyFilterHint;

  /// Заголовок секции с растениями пользователя
  ///
  /// In ru, this message translates to:
  /// **'Мой сад'**
  String get homeGardenTitle;

  /// Количество растений в саду
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Нет растений} one{{count} растение} few{{count} растения} many{{count} растений} other{{count} растения}}'**
  String homePlantsCount(int count);

  /// Чип «все локации» в фильтре комнат
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get homeLocationAll;

  /// Заголовок пустого состояния списка растений
  ///
  /// In ru, this message translates to:
  /// **'Сад пока пуст'**
  String get homeGardenEmptyTitle;

  /// Подпись к пустому состоянию списка растений
  ///
  /// In ru, this message translates to:
  /// **'Добавьте первое растение — и здесь появится ваш сад'**
  String get homeGardenEmptyHint;

  /// Подпись кнопки добавления растения (FAB / пустое состояние)
  ///
  /// In ru, this message translates to:
  /// **'Добавить растение'**
  String get homeAddPlant;

  /// Подсказка: в выбранной комнате нет растений
  ///
  /// In ru, this message translates to:
  /// **'В этой комнате пока нет растений'**
  String get homeRoomEmpty;

  /// Действие ухода: полив
  ///
  /// In ru, this message translates to:
  /// **'Полить'**
  String get careActionWatering;

  /// Действие ухода: опрыскивание
  ///
  /// In ru, this message translates to:
  /// **'Опрыскать'**
  String get careActionMisting;

  /// Действие ухода: подкормка
  ///
  /// In ru, this message translates to:
  /// **'Удобрить'**
  String get careActionFertilizing;

  /// Действие ухода: проверка почвы
  ///
  /// In ru, this message translates to:
  /// **'Проверить почву'**
  String get careActionSoilCheck;

  /// Действие ухода: нераспознанный тип
  ///
  /// In ru, this message translates to:
  /// **'Уход'**
  String get careActionUnknown;

  /// Метка времени задачи: просрочена
  ///
  /// In ru, this message translates to:
  /// **'Просрочено'**
  String get careDueOverdue;

  /// Метка времени задачи: сегодня (без точного времени)
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get careDueToday;

  /// Метка времени задачи с точным временем
  ///
  /// In ru, this message translates to:
  /// **'Сегодня в {time}'**
  String careDueAt(String time);

  /// Вкладка нижней навигации: сад
  ///
  /// In ru, this message translates to:
  /// **'Сад'**
  String get navGarden;

  /// Вкладка нижней навигации: график
  ///
  /// In ru, this message translates to:
  /// **'График'**
  String get navSchedule;

  /// Вкладка нижней навигации: каталог
  ///
  /// In ru, this message translates to:
  /// **'Каталог'**
  String get navCatalog;

  /// Вкладка нижней навигации: профиль
  ///
  /// In ru, this message translates to:
  /// **'Я'**
  String get navProfile;

  /// Сообщение-заглушка для ещё не реализованных действий
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get comingSoon;

  /// Кнопка повтора загрузки после ошибки
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// Текст сетевой ошибки
  ///
  /// In ru, this message translates to:
  /// **'Нет соединения. Проверьте интернет и попробуйте снова'**
  String get errorNetwork;

  /// Текст ошибки 404
  ///
  /// In ru, this message translates to:
  /// **'Данные не найдены'**
  String get errorNotFound;

  /// Текст ошибки 403
  ///
  /// In ru, this message translates to:
  /// **'Нет доступа к этим данным'**
  String get errorAccessDenied;

  /// Текст ошибки валидации
  ///
  /// In ru, this message translates to:
  /// **'Проверьте введённые данные'**
  String get errorValidation;

  /// Текст ошибки конфликта
  ///
  /// In ru, this message translates to:
  /// **'Данные изменились. Обновите экран'**
  String get errorConflict;

  /// Текст общей/неизвестной ошибки
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так. Попробуйте позже'**
  String get errorGeneric;

  /// Надзаголовок-капс в шапке экрана карточки растения
  ///
  /// In ru, this message translates to:
  /// **'Карточка'**
  String get plantCardOverline;

  /// Подпись/семантика кнопки возврата в шапке карточки
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get plantCardBack;

  /// Подпись/семантика кнопки меню «ещё» в шапке карточки
  ///
  /// In ru, this message translates to:
  /// **'Ещё'**
  String get plantCardMore;

  /// Подпись «со мной …» с длительностью владения растением
  ///
  /// In ru, this message translates to:
  /// **'Со мной {duration}'**
  String plantCardWithMeFor(String duration);

  /// Количество лет владения растением
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{меньше года} one{{count} год} few{{count} года} many{{count} лет} other{{count} года}}'**
  String plantCardAgeYears(int count);

  /// Количество месяцев владения растением
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{меньше месяца} one{{count} месяц} few{{count} месяца} many{{count} месяцев} other{{count} месяца}}'**
  String plantCardAgeMonths(int count);

  /// Hero-заголовок экрана «График»: сумма задач за неделю (0 — свободная неделя)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{На этой неделе сад отдыхает} one{На этой неделе {count} забота в саду} few{На этой неделе {count} заботы в саду} many{На этой неделе {count} забот в саду} other{На этой неделе {count} заботы в саду}}'**
  String scheduleWeekTasksCount(int count);

  /// Счётчик задач дня в строке недели (0 — свободный день)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Свободно} one{{count} задача} few{{count} задачи} many{{count} задач} other{{count} задачи}}'**
  String scheduleDayTasksCount(int count);

  /// Количество дней владения растением
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{сегодня} one{{count} день} few{{count} дня} many{{count} дней} other{{count} дня}}'**
  String plantCardAgeDays(int count);

  /// Надзаголовок секции стрика
  ///
  /// In ru, this message translates to:
  /// **'Серия ухода'**
  String get plantCardStreakTitle;

  /// Длина серии ухода «в срок»
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Серия прервана} one{{count} день подряд} few{{count} дня подряд} many{{count} дней подряд} other{{count} дня подряд}}'**
  String plantCardStreakCount(int count);

  /// Подпись под счётчиком серии ухода
  ///
  /// In ru, this message translates to:
  /// **'Уходов вовремя подряд'**
  String get plantCardStreakHint;

  /// Пустое состояние стрика (count = 0)
  ///
  /// In ru, this message translates to:
  /// **'Серии пока нет — начните ухаживать вовремя'**
  String get plantCardStreakEmpty;

  /// Заголовок секции заметок о растении
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get plantCardNotesTitle;

  /// Заголовок секции истории ухода
  ///
  /// In ru, this message translates to:
  /// **'Дневник ухода'**
  String get plantCardJournalTitle;

  /// Заголовок пустого состояния истории ухода
  ///
  /// In ru, this message translates to:
  /// **'Записей пока нет'**
  String get plantCardJournalEmpty;

  /// Подпись к пустому состоянию истории ухода
  ///
  /// In ru, this message translates to:
  /// **'Отметьте первый уход — и здесь появится история'**
  String get plantCardJournalEmptyHint;

  /// Бейдж записи истории: уход выполнен в срок
  ///
  /// In ru, this message translates to:
  /// **'вовремя'**
  String get plantCardJournalOnTime;

  /// Основная кнопка действия на карточке растения
  ///
  /// In ru, this message translates to:
  /// **'Отметить уход'**
  String get plantCardLogCare;

  /// Дата и время записи истории ухода (локальная TZ)
  ///
  /// In ru, this message translates to:
  /// **'{date}, {time}'**
  String plantCardHistoryDate(String date, String time);

  /// Запись истории: выполнен полив
  ///
  /// In ru, this message translates to:
  /// **'Полито'**
  String get careDoneWater;

  /// Запись истории: выполнено опрыскивание
  ///
  /// In ru, this message translates to:
  /// **'Опрыскано'**
  String get careDoneSpray;

  /// Запись истории: выполнена подкормка
  ///
  /// In ru, this message translates to:
  /// **'Удобрено'**
  String get careDoneFertilize;

  /// Запись истории: нераспознанный тип ухода
  ///
  /// In ru, this message translates to:
  /// **'Уход выполнен'**
  String get careDoneUnknown;

  /// Надзаголовок-капс в шапке sheet отметки ухода
  ///
  /// In ru, this message translates to:
  /// **'Отметить уход'**
  String get careSheetOverline;

  /// Заголовок sheet отметки ухода (без имени растения)
  ///
  /// In ru, this message translates to:
  /// **'Что сделали?'**
  String get careSheetTitle;

  /// Заголовок sheet отметки ухода с именем растения
  ///
  /// In ru, this message translates to:
  /// **'Уход за {plant}'**
  String careSheetTitleFor(String plant);

  /// Подпись/семантика кнопки закрытия sheet ухода
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get careSheetClose;

  /// Метка группы выбора типа ухода
  ///
  /// In ru, this message translates to:
  /// **'Тип ухода'**
  String get careSheetTypeLabel;

  /// Тип ухода (выбор в sheet): полив
  ///
  /// In ru, this message translates to:
  /// **'Полить'**
  String get careKindWater;

  /// Тип ухода (выбор в sheet): опрыскивание
  ///
  /// In ru, this message translates to:
  /// **'Опрыскать'**
  String get careKindSpray;

  /// Тип ухода (выбор в sheet): подкормка
  ///
  /// In ru, this message translates to:
  /// **'Удобрить'**
  String get careKindFertilize;

  /// Метка строки выбора даты/времени выполнения ухода
  ///
  /// In ru, this message translates to:
  /// **'Когда выполнили'**
  String get careSheetWhenLabel;

  /// Подпись «сейчас» для момента выполнения ухода по умолчанию
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get careSheetWhenNow;

  /// Выбранный момент выполнения ухода (локальная TZ)
  ///
  /// In ru, this message translates to:
  /// **'{date}, {time}'**
  String careSheetWhenValue(String date, String time);

  /// Метка необязательного поля заметки в sheet ухода
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get careSheetNoteLabel;

  /// Подсказка-плейсхолдер для поля заметки
  ///
  /// In ru, this message translates to:
  /// **'Например: полил(а) до поддона'**
  String get careSheetNoteHint;

  /// Подпись: поле заметки необязательно
  ///
  /// In ru, this message translates to:
  /// **'необязательно'**
  String get careSheetNoteOptional;

  /// Кнопка подтверждения отметки ухода
  ///
  /// In ru, this message translates to:
  /// **'Отметить'**
  String get careSheetSubmit;

  /// Снэкбар-подтверждение после успешной отметки ухода
  ///
  /// In ru, this message translates to:
  /// **'Уход отмечен'**
  String get careSheetSubmitted;

  /// Заголовок карточки экспорта расписания в календарь (.ics)
  ///
  /// In ru, this message translates to:
  /// **'Подписаться в календаре'**
  String get scheduleIcsTitle;

  /// Подзаголовок карточки экспорта расписания (.ics)
  ///
  /// In ru, this message translates to:
  /// **'Google / Apple Calendar — .ics'**
  String get scheduleIcsSubtitle;

  /// Подпись (a11y) кнопки сброса на текущую неделю
  ///
  /// In ru, this message translates to:
  /// **'На текущую неделю'**
  String get scheduleToCurrentWeek;

  /// Tooltip/label кнопки листания на предыдущую неделю
  ///
  /// In ru, this message translates to:
  /// **'Предыдущая неделя'**
  String get schedulePreviousWeek;

  /// Tooltip/label кнопки листания на следующую неделю
  ///
  /// In ru, this message translates to:
  /// **'Следующая неделя'**
  String get scheduleNextWeek;

  /// Надзаголовок-капс в шапке экрана каталога видов
  ///
  /// In ru, this message translates to:
  /// **'Каталог'**
  String get catalogTitle;

  /// Серифный заголовок экрана каталога видов
  ///
  /// In ru, this message translates to:
  /// **'Каталог растений'**
  String get catalogHeading;

  /// Плейсхолдер поля поиска по каталогу видов
  ///
  /// In ru, this message translates to:
  /// **'Найти вид…'**
  String get catalogSearchHint;

  /// Подсказка/семантика кнопки очистки поля поиска
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get catalogSearchClear;

  /// Количество видов в каталоге под текущим фильтром
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Нет видов} one{{count} вид} few{{count} вида} many{{count} видов} other{{count} вида}}'**
  String catalogCount(int count);

  /// Индикатор текущего шага мастера добавления растения
  ///
  /// In ru, this message translates to:
  /// **'Шаг {current} из {total}'**
  String addPlantStepIndicator(int current, int total);

  /// Надзаголовок-капс в шапке мастера добавления растения
  ///
  /// In ru, this message translates to:
  /// **'Новое растение'**
  String get addPlantOverline;

  /// Подпись/семантика кнопки закрытия мастера
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get addPlantClose;

  /// Подпись/семантика кнопки возврата на предыдущий шаг
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get addPlantBack;

  /// Кнопка перехода к следующему шагу мастера
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get addPlantNext;

  /// Кнопка пропуска шага выбора вида (вид необязателен)
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get addPlantSkip;

  /// Кнопка завершения мастера: создать растение
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get addPlantSubmit;

  /// Заголовок шага выбора вида
  ///
  /// In ru, this message translates to:
  /// **'Какое у тебя растение?'**
  String get addPlantSpeciesTitle;

  /// Подпись под заголовком шага выбора вида
  ///
  /// In ru, this message translates to:
  /// **'Найдём вид, подберём имя и план ухода. Если не знаешь — пропусти.'**
  String get addPlantSpeciesSubtitle;

  /// Плейсхолдер поля поиска вида
  ///
  /// In ru, this message translates to:
  /// **'монстера, фикус, суккулент…'**
  String get addPlantSearchHint;

  /// Пустой результат поиска вида
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get addPlantSearchEmpty;

  /// Подсказка к пустому результату поиска вида
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте другой запрос или пропустите выбор вида'**
  String get addPlantSearchEmptyHint;

  /// Заголовок строки «создать без выбора вида»
  ///
  /// In ru, this message translates to:
  /// **'Не знаю, что это'**
  String get addPlantSkipSpeciesTitle;

  /// Подсказка к строке «создать без выбора вида»
  ///
  /// In ru, this message translates to:
  /// **'Заведём как «Растение». Позже уточним.'**
  String get addPlantSkipSpeciesHint;

  /// Заголовок шага ввода имени и комнаты
  ///
  /// In ru, this message translates to:
  /// **'Как назовём?'**
  String get addPlantNameTitle;

  /// Подпись под заголовком шага имени
  ///
  /// In ru, this message translates to:
  /// **'Имя помогает запомнить характер растения.'**
  String get addPlantNameSubtitle;

  /// Метка поля ввода имени растения
  ///
  /// In ru, this message translates to:
  /// **'Имя растения'**
  String get addPlantNameLabel;

  /// Плейсхолдер поля имени растения
  ///
  /// In ru, this message translates to:
  /// **'Например: Моника'**
  String get addPlantNameHint;

  /// Ошибка валидации имени: пусто или слишком длинное
  ///
  /// In ru, this message translates to:
  /// **'Введите имя (до {max} символов)'**
  String addPlantNameError(int max);

  /// Метка группы выбора комнаты
  ///
  /// In ru, this message translates to:
  /// **'Где живёт'**
  String get addPlantRoomLabel;

  /// Чип «не выбирать комнату»
  ///
  /// In ru, this message translates to:
  /// **'Без комнаты'**
  String get addPlantRoomNone;

  /// Подсказка, когда у пользователя нет комнат
  ///
  /// In ru, this message translates to:
  /// **'Комнат пока нет — растение попадёт в сад'**
  String get addPlantRoomsEmpty;

  /// Заголовок шага превью плана ухода
  ///
  /// In ru, this message translates to:
  /// **'План ухода'**
  String get addPlantCarePlanTitle;

  /// Подпись под заголовком шага плана ухода (read-only)
  ///
  /// In ru, this message translates to:
  /// **'Рекомендации по виду. Изменить пока нельзя.'**
  String get addPlantCarePlanSubtitle;

  /// Бейдж-пометка на шаге плана ухода: план редактировать нельзя
  ///
  /// In ru, this message translates to:
  /// **'Только просмотр'**
  String get addPlantCarePlanReadOnly;

  /// Интервал пункта плана ухода: каждые N дней
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{каждый день} few{каждые {count} дня} many{каждые {count} дней} other{каждые {count} дня}}'**
  String addPlantCarePlanEvery(int count);

  /// Пустое состояние каталога без поискового запроса
  ///
  /// In ru, this message translates to:
  /// **'Каталог пуст'**
  String get catalogEmpty;

  /// Подпись к пустому состоянию каталога без запроса
  ///
  /// In ru, this message translates to:
  /// **'Виды растений появятся здесь позже'**
  String get catalogEmptyHint;

  /// Пустое состояние поиска по каталогу (нет результатов)
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get catalogSearchEmpty;

  /// Подсказка к пустому результату поиска с текстом запроса
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте изменить запрос «{query}»'**
  String catalogSearchEmptyHint(String query);

  /// Текст компактной плашки ошибки дозагрузки страницы списка
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить ещё'**
  String get catalogLoadMoreError;

  /// Надзаголовок-капс в шапке экрана детали вида
  ///
  /// In ru, this message translates to:
  /// **'Вид'**
  String get speciesDetailOverline;

  /// Заголовок секции описания вида
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get speciesDescriptionTitle;

  /// Заголовок секции рекомендаций по уходу за видом
  ///
  /// In ru, this message translates to:
  /// **'Уход'**
  String get speciesCareTitle;

  /// Заголовок секции условий содержания (сложность, свет)
  ///
  /// In ru, this message translates to:
  /// **'Условия'**
  String get speciesPropsTitle;

  /// Метка свойства: сложность ухода
  ///
  /// In ru, this message translates to:
  /// **'Сложность'**
  String get speciesDifficultyLabel;

  /// Метка свойства: предпочтение освещённости
  ///
  /// In ru, this message translates to:
  /// **'Свет'**
  String get speciesLightLabel;

  /// Сложность ухода: лёгкая
  ///
  /// In ru, this message translates to:
  /// **'Лёгкий уход'**
  String get speciesDifficultyEasy;

  /// Сложность ухода: средняя
  ///
  /// In ru, this message translates to:
  /// **'Средний уход'**
  String get speciesDifficultyMedium;

  /// Сложность ухода: высокая
  ///
  /// In ru, this message translates to:
  /// **'Сложный уход'**
  String get speciesDifficultyHard;

  /// Сложность ухода: неизвестна
  ///
  /// In ru, this message translates to:
  /// **'Сложность не указана'**
  String get speciesDifficultyUnknown;

  /// Освещённость: прямое яркое солнце
  ///
  /// In ru, this message translates to:
  /// **'Прямое солнце'**
  String get speciesLightFullSun;

  /// Освещённость: яркий рассеянный свет
  ///
  /// In ru, this message translates to:
  /// **'Яркий рассеянный'**
  String get speciesLightBrightIndirect;

  /// Освещённость: полутень
  ///
  /// In ru, this message translates to:
  /// **'Полутень'**
  String get speciesLightPartialShade;

  /// Освещённость: тень / низкая освещённость
  ///
  /// In ru, this message translates to:
  /// **'Тень'**
  String get speciesLightShade;

  /// Освещённость: неизвестна
  ///
  /// In ru, this message translates to:
  /// **'Свет не указан'**
  String get speciesLightUnknown;

  /// Метка интервала ухода: полив
  ///
  /// In ru, this message translates to:
  /// **'Полив'**
  String get speciesCareWatering;

  /// Метка интервала ухода: опрыскивание
  ///
  /// In ru, this message translates to:
  /// **'Опрыскивание'**
  String get speciesCareMisting;

  /// Метка интервала ухода: подкормка
  ///
  /// In ru, this message translates to:
  /// **'Подкормка'**
  String get speciesCareFertilizing;

  /// Метка интервала ухода: проверка грунта
  ///
  /// In ru, this message translates to:
  /// **'Проверка грунта'**
  String get speciesCareSoilCheck;

  /// Интервал ухода в днях («каждые N дней»)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{каждый {count} день} few{каждые {count} дня} many{каждые {count} дней} other{каждые {count} дня}}'**
  String speciesCareEveryDays(int count);

  /// Подсказка на шаге плана ухода, когда вид не выбран
  ///
  /// In ru, this message translates to:
  /// **'Выберите вид на первом шаге, чтобы увидеть план ухода'**
  String get addPlantCarePlanEmpty;

  /// Подсказка, когда у выбранного вида нет интервалов ухода
  ///
  /// In ru, this message translates to:
  /// **'Для этого вида рекомендаций по уходу нет'**
  String get addPlantCarePlanNone;

  /// Заголовок шага подтверждения
  ///
  /// In ru, this message translates to:
  /// **'Почти готово'**
  String get addPlantConfirmTitle;

  /// Подпись под заголовком шага подтверждения
  ///
  /// In ru, this message translates to:
  /// **'Проверьте данные и добавьте растение в сад.'**
  String get addPlantConfirmSubtitle;

  /// Метка строки саммари: имя растения
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get addPlantSummaryName;

  /// Метка строки саммари: комната
  ///
  /// In ru, this message translates to:
  /// **'Комната'**
  String get addPlantSummaryRoom;

  /// Метка строки саммари: план ухода
  ///
  /// In ru, this message translates to:
  /// **'План ухода'**
  String get addPlantSummaryCarePlan;

  /// Краткое описание плана ухода в саммари: число пунктов
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{нет рекомендаций} one{{count} пункт} few{{count} пункта} many{{count} пунктов} other{{count} пункта}}'**
  String addPlantSummaryCarePlanCount(int count);

  /// Метка необязательного поля заметки на шаге подтверждения
  ///
  /// In ru, this message translates to:
  /// **'Заметка'**
  String get addPlantNoteLabel;

  /// Плейсхолдер поля заметки
  ///
  /// In ru, this message translates to:
  /// **'Например: подарок на день рождения'**
  String get addPlantNoteHint;

  /// Подпись: поле заметки необязательно
  ///
  /// In ru, this message translates to:
  /// **'необязательно'**
  String get addPlantNoteOptional;

  /// Снэкбар-подтверждение после успешного создания растения
  ///
  /// In ru, this message translates to:
  /// **'Растение добавлено'**
  String get addPlantSubmitted;

  /// Уровень сложности ухода за видом: лёгкий
  ///
  /// In ru, this message translates to:
  /// **'Лёгкий уход'**
  String get careDifficultyEasy;

  /// Уровень сложности ухода за видом: средний
  ///
  /// In ru, this message translates to:
  /// **'Средний уход'**
  String get careDifficultyMedium;

  /// Уровень сложности ухода за видом: сложный
  ///
  /// In ru, this message translates to:
  /// **'Сложный уход'**
  String get careDifficultyHard;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
