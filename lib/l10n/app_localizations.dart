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

  /// Плейсхолдер поля унифицированного поиска (экран Search)
  ///
  /// In ru, this message translates to:
  /// **'Искать растения, виды, болезни…'**
  String get searchScreenHint;

  /// Подсказка пустого состояния, пока введено меньше 2 символов
  ///
  /// In ru, this message translates to:
  /// **'Введите минимум 2 символа'**
  String get searchMinCharsHint;

  /// Все секции поиска пусты при достаточной длине запроса
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get searchEmptyResult;

  /// Заголовок секции результатов-растений
  ///
  /// In ru, this message translates to:
  /// **'Мои растения'**
  String get searchSectionPlants;

  /// Заголовок секции результатов-видов
  ///
  /// In ru, this message translates to:
  /// **'Виды'**
  String get searchSectionSpecies;

  /// Заголовок секции результатов-болезней
  ///
  /// In ru, this message translates to:
  /// **'Болезни и вредители'**
  String get searchSectionDiseases;

  /// Кнопка перехода к полному списку раздела поиска
  ///
  /// In ru, this message translates to:
  /// **'Показать все'**
  String get searchShowAll;

  /// Подпись кнопки возврата с экрана поиска
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get searchBack;

  /// Подсказка для иконки уведомлений в шапке
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get homeNotificationsTooltip;

  /// Подсказка для иконки профиля в упрощённой шапке (пустой сад)
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get homeProfileTooltip;

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

  /// Бейдж выполнения в правом верхнем углу карточки «Сегодня»: «N%»
  ///
  /// In ru, this message translates to:
  /// **'{percent}%'**
  String homeTodayProgressBadge(int percent);

  /// Semantics-метка бейджа прогресса карточки «Сегодня»
  ///
  /// In ru, this message translates to:
  /// **'{percent}% выполнено'**
  String homeTodayProgressSemantic(int percent);

  /// Semantics-метка прогресс-бара карточки «Сегодня»
  ///
  /// In ru, this message translates to:
  /// **'Прогресс: {done} из {total} задач выполнено'**
  String homeTodayProgressBarSemantic(int done, int total);

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

  /// Прогресс-карточка экрана «Сегодня»: сколько задач выполнено из общего числа
  ///
  /// In ru, this message translates to:
  /// **'{done} из {total} выполнено'**
  String todayProgress(int done, int total);

  /// Подпись прогресс-карточки: сколько забот ещё осталось
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Все заботы закрыты} one{Осталась {count} забота} few{Осталось {count} заботы} many{Осталось {count} забот} other{Осталось {count} заботы}}'**
  String todayProgressRemaining(int count);

  /// Хвост подписи прогресс-карточки: сколько просрочено
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{нет просроченных} one{{count} просрочена} few{{count} просрочены} many{{count} просрочено} other{{count} просрочено}}'**
  String todayProgressOverdue(int count);

  /// Заголовок свёрнутой секции «Выполнено» на экране «Сегодня»
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Ничего не выполнено} one{{count} выполнено сегодня} few{{count} выполнено сегодня} many{{count} выполнено сегодня} other{{count} выполнено сегодня}}'**
  String todayDoneTitle(int count);

  /// Свёрнутая секция «Выполнено»: что и когда сделано (например «Колючка · полит в 7:42»)
  ///
  /// In ru, this message translates to:
  /// **'{plant} · {action} в {time}'**
  String todayDoneSubtitle(String plant, String action, String time);

  /// Семантика/подсказка: раскрыть свёрнутую секцию «Выполнено»
  ///
  /// In ru, this message translates to:
  /// **'Показать выполненные'**
  String get todayDoneExpand;

  /// Семантика/подсказка: свернуть секцию «Выполнено»
  ///
  /// In ru, this message translates to:
  /// **'Скрыть выполненные'**
  String get todayDoneCollapse;

  /// Подпись на карточке выполненной задачи: действие в прошедшем времени + время (например «Полито в 7:42»)
  ///
  /// In ru, this message translates to:
  /// **'{action} в {time}'**
  String careDonePast(String action, String time);

  /// Действие полива в прошедшем времени (для секции «Выполнено»)
  ///
  /// In ru, this message translates to:
  /// **'Полито'**
  String get careActionDoneWatering;

  /// Действие опрыскивания в прошедшем времени
  ///
  /// In ru, this message translates to:
  /// **'Опрыскано'**
  String get careActionDoneMisting;

  /// Действие подкормки в прошедшем времени
  ///
  /// In ru, this message translates to:
  /// **'Удобрено'**
  String get careActionDoneFertilizing;

  /// Проверка почвы в прошедшем времени
  ///
  /// In ru, this message translates to:
  /// **'Проверено'**
  String get careActionDoneSoilCheck;

  /// Нейтральное «сделано» для нераспознанного типа ухода
  ///
  /// In ru, this message translates to:
  /// **'Сделано'**
  String get careActionDoneUnknown;

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

  /// Аффорданс «Все →» в заголовке секции «Мой сад» — сброс фильтра локации
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get homeGardenSeeAll;

  /// Чип «все локации» в фильтре комнат
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get homeLocationAll;

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

  /// Надзаголовок (eyebrow, uppercase) карточки пустого сада, экран 10
  ///
  /// In ru, this message translates to:
  /// **'Сад пока пуст'**
  String get homeGardenEmptyEyebrow;

  /// Серифный заголовок карточки пустого сада, экран 10
  ///
  /// In ru, this message translates to:
  /// **'Заведём первое растение?'**
  String get homeGardenEmptyHeading;

  /// Подпись под заголовком карточки пустого сада, экран 10
  ///
  /// In ru, this message translates to:
  /// **'Я подберу расписание ухода и буду напоминать — так, как ты любишь.'**
  String get homeGardenEmptySubtitle;

  /// Вторичная кнопка карточки пустого сада: распознавание растения по фото (coming soon)
  ///
  /// In ru, this message translates to:
  /// **'Распознать по фото'**
  String get homeRecognizeByPhoto;

  /// Надзаголовок (eyebrow, uppercase) блока стартовых видов под карточкой пустого сада, экран 10
  ///
  /// In ru, this message translates to:
  /// **'Идеи на старт'**
  String get homeStarterIdeasTitle;

  /// Название стартового вида: монстера
  ///
  /// In ru, this message translates to:
  /// **'Монстера'**
  String get homeStarterMonstera;

  /// Подпись стартового вида монстера: уровень сложности
  ///
  /// In ru, this message translates to:
  /// **'легко'**
  String get homeStarterMonsteraHint;

  /// Название стартового вида: суккулент
  ///
  /// In ru, this message translates to:
  /// **'Суккулент'**
  String get homeStarterSucculent;

  /// Подпись стартового вида суккулент: уровень сложности
  ///
  /// In ru, this message translates to:
  /// **'забыть можно'**
  String get homeStarterSucculentHint;

  /// Название стартового вида: эпипремнум (потос)
  ///
  /// In ru, this message translates to:
  /// **'Эпипремнум'**
  String get homeStarterPothos;

  /// Подпись стартового вида эпипремнум: уровень сложности
  ///
  /// In ru, this message translates to:
  /// **'для новичка'**
  String get homeStarterPothosHint;

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

  /// Текст ошибки 401 — токен недействителен, нужен повторный вход
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла. Войдите снова'**
  String get errorUnauthorized;

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

  /// Префикс hero-заголовка «График» перед выделенным числом задач (count > 0)
  ///
  /// In ru, this message translates to:
  /// **'На этой неделе '**
  String get scheduleWeekTasksPrefix;

  /// Суффикс hero-заголовка «График» после выделенного числа задач (count > 0)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{ забота в саду} few{ заботы в саду} many{ забот в саду} other{ заботы в саду}}'**
  String scheduleWeekTasksSuffix(int count);

  /// Hero-заголовок «График» когда задач на неделе нет (count = 0)
  ///
  /// In ru, this message translates to:
  /// **'На этой неделе сад отдыхает'**
  String get scheduleWeekRestTitle;

  /// Subtitle под hero-заголовком «График»: перечисление дней без задач
  ///
  /// In ru, this message translates to:
  /// **'{days} — свободные дни 🌳'**
  String scheduleFreeDaysSubtitle(String days);

  /// Заглушка дня без задач на экране «График» (serif italic 15px)
  ///
  /// In ru, this message translates to:
  /// **'Свободный день 🌿'**
  String get scheduleDayFree;

  /// Счётчик задач дня в строке недели (0 — свободный день)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Свободно} one{{count} задача} few{{count} задачи} many{{count} задач} other{{count} задачи}}'**
  String scheduleDayTasksCount(int count);

  /// Заголовок экрана 11 «График» (agenda)
  ///
  /// In ru, this message translates to:
  /// **'График ухода'**
  String get scheduleTitle;

  /// Символ нулевой нагрузки в день-селекторе (0 задач)
  ///
  /// In ru, this message translates to:
  /// **'—'**
  String get scheduleDayLoadHint;

  /// Подзаголовок выбранного дня: сколько задач отмечено из общего числа
  ///
  /// In ru, this message translates to:
  /// **'{done} из {total} готово'**
  String scheduleDayProgress(int done, int total);

  /// Заголовок утренней секции agenda
  ///
  /// In ru, this message translates to:
  /// **'Утро'**
  String get schedulePhaseMorning;

  /// Заголовок вечерней секции agenda
  ///
  /// In ru, this message translates to:
  /// **'Вечер'**
  String get schedulePhaseEvening;

  /// Заголовок секции выполненных задач agenda
  ///
  /// In ru, this message translates to:
  /// **'Сделано'**
  String get schedulePhaseDone;

  /// Условное время утренней секции agenda
  ///
  /// In ru, this message translates to:
  /// **'9:00'**
  String get schedulePhaseMorningTime;

  /// Условное время вечерней секции agenda
  ///
  /// In ru, this message translates to:
  /// **'19:00'**
  String get schedulePhaseEveningTime;

  /// Подпись просроченной задачи в строке agenda
  ///
  /// In ru, this message translates to:
  /// **'Просрочено · со вчера'**
  String get scheduleOverdueSubtitle;

  /// Подпись строки задачи: действие и вид растения
  ///
  /// In ru, this message translates to:
  /// **'{action} · {species}'**
  String scheduleTaskSubtitle(String action, String species);

  /// Заглушка дня без задач на экране 11 «График»
  ///
  /// In ru, this message translates to:
  /// **'На этот день забот нет 🌿'**
  String get scheduleDayEmpty;

  /// Подпись кнопки-чека (semantics) для отметки ухода
  ///
  /// In ru, this message translates to:
  /// **'Отметить выполненным'**
  String get scheduleMarkDone;

  /// Баннер ошибки при неудачной оптимистичной отметке ухода
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отметить уход. Попробуйте ещё раз.'**
  String get scheduleMarkError;

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

  /// Реплика растения в speech-bubble пустого дневника (экран 31), голос от первого лица
  ///
  /// In ru, this message translates to:
  /// **'Жду первого ухода…'**
  String get plantCardJournalEmptyBubble;

  /// CTA-кнопка пустого дневника (экран 31): открывает sheet полива
  ///
  /// In ru, this message translates to:
  /// **'Полить сейчас'**
  String get plantCardJournalWaterNow;

  /// Бейдж записи истории: уход выполнен в срок
  ///
  /// In ru, this message translates to:
  /// **'вовремя'**
  String get plantCardJournalOnTime;

  /// Кнопка дозагрузки следующих 5 записей дневника на карточке растения
  ///
  /// In ru, this message translates to:
  /// **'Показать ещё'**
  String get plantCardJournalLoadMore;

  /// Кнопка перехода в полный дневник (экран 21), когда все записи дозагружены и их больше 5
  ///
  /// In ru, this message translates to:
  /// **'Открыть полный дневник'**
  String get plantCardJournalOpenFull;

  /// Компактная плашка ошибки дозагрузки дневника на карточке растения
  ///
  /// In ru, this message translates to:
  /// **'Не удалось дозагрузить'**
  String get plantCardJournalLoadMoreError;

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

  /// Бейдж индекса здоровья растения (G1): «HEALTH {score}»
  ///
  /// In ru, this message translates to:
  /// **'HEALTH {score}'**
  String healthBadgeLabel(int score);

  /// Бейдж здоровья в нейтральном состоянии: данных недостаточно
  ///
  /// In ru, this message translates to:
  /// **'HEALTH —'**
  String get healthScoreUnknown;

  /// Semantics-метка кольца/бейджа здоровья с достоверным score
  ///
  /// In ru, this message translates to:
  /// **'Здоровье растения: {score} из 100'**
  String healthSemanticScore(int score);

  /// Semantics-метка кольца/бейджа здоровья при недостатке данных
  ///
  /// In ru, this message translates to:
  /// **'Здоровье растения: недостаточно данных'**
  String get healthSemanticUnknown;

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

  /// Метка слайдера объёма воды (WATER, экран 06)
  ///
  /// In ru, this message translates to:
  /// **'Объём воды'**
  String get careSheetWaterAmountLabel;

  /// Значение объёма воды с единицей мл
  ///
  /// In ru, this message translates to:
  /// **'{amount} мл'**
  String careSheetWaterAmountValue(int amount);

  /// Подпись когда объём воды не выбран (слайдер в 0)
  ///
  /// In ru, this message translates to:
  /// **'Не указан'**
  String get careSheetWaterAmountNotSet;

  /// Тоггл «грунт был сухой» (WATER, экран 06)
  ///
  /// In ru, this message translates to:
  /// **'Грунт был сухой'**
  String get careSheetSoilDryLabel;

  /// Метка поля названия удобрения (FERTILIZE, экран 06b)
  ///
  /// In ru, this message translates to:
  /// **'Название удобрения'**
  String get careSheetFertilizerNameLabel;

  /// Плейсхолдер поля названия удобрения
  ///
  /// In ru, this message translates to:
  /// **'Например: Кемира Люкс'**
  String get careSheetFertilizerNameHint;

  /// Кнопка подтверждения полива (WATER)
  ///
  /// In ru, this message translates to:
  /// **'Полито'**
  String get careSheetWaterSubmit;

  /// Кнопка подтверждения опрыскивания (SPRAY)
  ///
  /// In ru, this message translates to:
  /// **'Опрыскано'**
  String get careSheetSpraySubmit;

  /// Кнопка подтверждения подкормки (FERTILIZE)
  ///
  /// In ru, this message translates to:
  /// **'Подкормлено'**
  String get careSheetFertilizeSubmit;

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

  /// Серифный заголовок каталога, обычная часть (перед акцентом)
  ///
  /// In ru, this message translates to:
  /// **'Каталог '**
  String get catalogHeadingLead;

  /// Серифный заголовок каталога, акцентная часть (primary, italic)
  ///
  /// In ru, this message translates to:
  /// **'растений'**
  String get catalogHeadingAccent;

  /// Бейдж популярного вида рядом с именем в списке каталога
  ///
  /// In ru, this message translates to:
  /// **'HIT'**
  String get catalogBadgePopular;

  /// Бейдж токсичности вида (для кошек) в мета-строке каталога
  ///
  /// In ru, this message translates to:
  /// **'⚠ ТОКСИЧНО · 🐈'**
  String get catalogBadgeToxic;

  /// Чип-фильтр каталога «Все виды» (активен по умолчанию)
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get catalogFilterAll;

  /// Чип-фильтр каталога «Для новичка»
  ///
  /// In ru, this message translates to:
  /// **'Для новичка'**
  String get catalogFilterBeginner;

  /// Чип-фильтр каталога «Безопасно для котов»
  ///
  /// In ru, this message translates to:
  /// **'Безопасно для котов 🐈'**
  String get catalogFilterPetSafe;

  /// Чип-фильтр каталога «Цветущие»
  ///
  /// In ru, this message translates to:
  /// **'Цветущие'**
  String get catalogFilterFlowering;

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

  /// Подпись под заголовком шага плана ухода
  ///
  /// In ru, this message translates to:
  /// **'Рекомендации по виду. Измените интервалы, если нужно.'**
  String get addPlantCarePlanSubtitle;

  /// Информационная подсказка на шаге плана ухода
  ///
  /// In ru, this message translates to:
  /// **'После создания расписание можно настроить под себя'**
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

  /// Компактный интервал полива в фактах-сетке («раз в N дн.»)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{раз в {count} дн.} few{раз в {count} дн.} many{раз в {count} дн.} other{раз в {count} дн.}}'**
  String speciesWateringEveryDays(int count);

  /// Подпись факта «Сложность» в сетке фактов вида
  ///
  /// In ru, this message translates to:
  /// **'Сложность'**
  String get speciesFactDifficulty;

  /// Подпись факта «Свет» в сетке фактов вида
  ///
  /// In ru, this message translates to:
  /// **'Свет'**
  String get speciesFactLight;

  /// Подпись факта «Полив» в сетке фактов вида
  ///
  /// In ru, this message translates to:
  /// **'Полив'**
  String get speciesFactWatering;

  /// Заголовок баннера токсичности вида
  ///
  /// In ru, this message translates to:
  /// **'Токсично для кошек, собак и детей'**
  String get speciesToxicTitle;

  /// Пояснение в баннере токсичности вида
  ///
  /// In ru, this message translates to:
  /// **'Сок листьев раздражает слизистую. Держите повыше.'**
  String get speciesToxicSubtitle;

  /// Заголовок секции шкалы света на карточке вида
  ///
  /// In ru, this message translates to:
  /// **'Свет'**
  String get speciesLightTitle;

  /// Ступень шкалы света: тень
  ///
  /// In ru, this message translates to:
  /// **'Тень'**
  String get speciesLightStepShade;

  /// Ступень шкалы света: полутень
  ///
  /// In ru, this message translates to:
  /// **'Полутень'**
  String get speciesLightStepPartial;

  /// Ступень шкалы света: рассеянный
  ///
  /// In ru, this message translates to:
  /// **'Рассеянный'**
  String get speciesLightStepIndirect;

  /// Ступень шкалы света: прямое солнце
  ///
  /// In ru, this message translates to:
  /// **'Прямое'**
  String get speciesLightStepDirect;

  /// Кнопка добавления вида в сад на карточке вида
  ///
  /// In ru, this message translates to:
  /// **'Добавить в мой сад'**
  String get speciesAddToGarden;

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

  /// CTA финального шага: создать растение и добавить в сад
  ///
  /// In ru, this message translates to:
  /// **'Добавить в сад'**
  String get addPlantSubmitGarden;

  /// Бейдж внутри поля поиска вида: распознать по фото (заглушка)
  ///
  /// In ru, this message translates to:
  /// **'ФОТО'**
  String get addPlantRecognizeBadge;

  /// Подсказка-заглушка распознавания вида по фото на шаге выбора вида
  ///
  /// In ru, this message translates to:
  /// **'Сфотографируй — определим по листу'**
  String get addPlantRecognizeHint;

  /// Снэкбар: функция распознавания по фото ещё не готова
  ///
  /// In ru, this message translates to:
  /// **'Распознавание по фото скоро появится'**
  String get addPlantRecognizeUnavailable;

  /// Чип категории видов: популярные
  ///
  /// In ru, this message translates to:
  /// **'Популярное'**
  String get addPlantCategoryPopular;

  /// Чип категории видов: для новичка
  ///
  /// In ru, this message translates to:
  /// **'Для новичка'**
  String get addPlantCategoryBeginner;

  /// Чип категории видов: цветущие
  ///
  /// In ru, this message translates to:
  /// **'Цветущие'**
  String get addPlantCategoryFlowering;

  /// Чип категории видов: суккуленты и редкий полив
  ///
  /// In ru, this message translates to:
  /// **'Без полива'**
  String get addPlantCategoryLowWater;

  /// CTA на шаге имя+комната: создать новую комнату
  ///
  /// In ru, this message translates to:
  /// **'Добавить своё помещение'**
  String get addPlantNewRoom;

  /// Заголовок шага фото + сторона окна
  ///
  /// In ru, this message translates to:
  /// **'Сделай портрет'**
  String get addPlantPhotoTitle;

  /// Надзаголовок шага фото + сторона окна
  ///
  /// In ru, this message translates to:
  /// **'Последний штрих'**
  String get addPlantPhotoOverline;

  /// Подпись под заголовком шага фото + сторона окна
  ///
  /// In ru, this message translates to:
  /// **'Фото поможет узнать растение и отслеживать его рост.'**
  String get addPlantPhotoSubtitle;

  /// Подпись плейсхолдера фото: реальная загрузка ещё не готова
  ///
  /// In ru, this message translates to:
  /// **'Пока используется иллюстрация'**
  String get addPlantPhotoPlaceholder;

  /// Кнопка-заглушка: снять фото камерой
  ///
  /// In ru, this message translates to:
  /// **'Камера'**
  String get addPlantPhotoCamera;

  /// Кнопка-заглушка: выбрать фото из галереи
  ///
  /// In ru, this message translates to:
  /// **'Из галереи'**
  String get addPlantPhotoGallery;

  /// Снэкбар: загрузка фото ещё не готова
  ///
  /// In ru, this message translates to:
  /// **'Загрузка фото скоро появится'**
  String get addPlantPhotoUnavailable;

  /// Заголовок секции выбора стороны окна
  ///
  /// In ru, this message translates to:
  /// **'Куда смотрит окно'**
  String get addPlantWindowLabel;

  /// Подпись: выбор стороны окна необязателен
  ///
  /// In ru, this message translates to:
  /// **'необязательно'**
  String get addPlantWindowOptional;

  /// Сторона окна: юг
  ///
  /// In ru, this message translates to:
  /// **'Юг'**
  String get addPlantWindowSouth;

  /// Подпись стороны окна: юг
  ///
  /// In ru, this message translates to:
  /// **'много солнца'**
  String get addPlantWindowSouthHint;

  /// Сторона окна: восток
  ///
  /// In ru, this message translates to:
  /// **'Восток'**
  String get addPlantWindowEast;

  /// Подпись стороны окна: восток
  ///
  /// In ru, this message translates to:
  /// **'мягкое утро'**
  String get addPlantWindowEastHint;

  /// Сторона окна: запад
  ///
  /// In ru, this message translates to:
  /// **'Запад'**
  String get addPlantWindowWest;

  /// Подпись стороны окна: запад
  ///
  /// In ru, this message translates to:
  /// **'тёплый вечер'**
  String get addPlantWindowWestHint;

  /// Сторона окна: север
  ///
  /// In ru, this message translates to:
  /// **'Север'**
  String get addPlantWindowNorth;

  /// Подпись стороны окна: север
  ///
  /// In ru, this message translates to:
  /// **'мало света'**
  String get addPlantWindowNorthHint;

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

  /// Серифный заголовок экрана профиля
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profileTitle;

  /// Надзаголовок-капс над заголовком экрана профиля
  ///
  /// In ru, this message translates to:
  /// **'НАСТРОЙКИ'**
  String get profileOverline;

  /// Заголовок секции дополнительных настроек на экране профиля
  ///
  /// In ru, this message translates to:
  /// **'Ещё'**
  String get profileSectionMore;

  /// Имя в шапке профиля, когда у пользователя нет имени (анонимный)
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get profileAnonymous;

  /// Подпись в шапке профиля: дата регистрации (формат MMM yyyy)
  ///
  /// In ru, this message translates to:
  /// **'С нами с {date}'**
  String profileMemberSince(String date);

  /// Подпись счётчика статистики: число растений
  ///
  /// In ru, this message translates to:
  /// **'Растения'**
  String get profileStatPlants;

  /// Подпись счётчика статистики: число уходов за всё время
  ///
  /// In ru, this message translates to:
  /// **'Уходов'**
  String get profileStatCareEvents;

  /// Заголовок секции справочников на экране профиля
  ///
  /// In ru, this message translates to:
  /// **'Справочники'**
  String get profileSectionReferences;

  /// Строка справочников: переход к каталогу болезней и вредителей
  ///
  /// In ru, this message translates to:
  /// **'Болезни и вредители'**
  String get profileDiseasesTitle;

  /// Строка справочников: переход на таб каталога видов
  ///
  /// In ru, this message translates to:
  /// **'Каталог видов'**
  String get profileCatalogTitle;

  /// Строка настроек: переход к экрану поиска
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get profileSearchTitle;

  /// Строка настроек: переход к управлению комнатами
  ///
  /// In ru, this message translates to:
  /// **'Дома и места'**
  String get profileRoomsTitle;

  /// Строка настроек: выход из аккаунта (деструктивное действие)
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get profileSignOut;

  /// Заголовок диалога подтверждения выхода
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта?'**
  String get profileSignOutConfirmTitle;

  /// Текст диалога подтверждения выхода
  ///
  /// In ru, this message translates to:
  /// **'Вы вернётесь к экрану входа. Чтобы снова открыть свой сад, понадобится войти по почте.'**
  String get profileSignOutConfirmMessage;

  /// Кнопка отмены в диалоге выхода
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get profileSignOutConfirmCancel;

  /// Кнопка подтверждения выхода в диалоге
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get profileSignOutConfirmAction;

  /// Серифный заголовок экрана управления комнатами
  ///
  /// In ru, this message translates to:
  /// **'Дома и места'**
  String get roomsTitle;

  /// Надзаголовок-капс в шапке экрана управления комнатами
  ///
  /// In ru, this message translates to:
  /// **'МОИ КОМНАТЫ'**
  String get roomsOverline;

  /// Семантика/подпись кнопки возврата в шапке экрана комнат
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get roomsBack;

  /// Количество комнат под заголовком экрана
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Нет комнат} one{{count} комната} few{{count} комнаты} many{{count} комнат} other{{count} комнаты}}'**
  String roomsCount(int count);

  /// Пометка на строке дефолтной комнаты
  ///
  /// In ru, this message translates to:
  /// **'По умолчанию'**
  String get roomsDefaultBadge;

  /// Подпись кнопки добавления комнаты (FAB / пустое состояние)
  ///
  /// In ru, this message translates to:
  /// **'Добавить комнату'**
  String get roomsAdd;

  /// Семантика/подпись действия редактирования комнаты
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get roomsEditAction;

  /// Семантика/подпись действия удаления комнаты
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get roomsDeleteAction;

  /// Заголовок пустого состояния списка комнат
  ///
  /// In ru, this message translates to:
  /// **'Комнат пока нет'**
  String get roomsEmptyTitle;

  /// Подпись к пустому состоянию списка комнат
  ///
  /// In ru, this message translates to:
  /// **'Добавьте комнату, чтобы группировать растения по местам'**
  String get roomsEmptyHint;

  /// Надзаголовок-капс в шапке sheet создания комнаты
  ///
  /// In ru, this message translates to:
  /// **'Новая комната'**
  String get roomSheetCreateOverline;

  /// Надзаголовок-капс в шапке sheet редактирования комнаты
  ///
  /// In ru, this message translates to:
  /// **'Комната'**
  String get roomSheetEditOverline;

  /// Заголовок sheet создания комнаты
  ///
  /// In ru, this message translates to:
  /// **'Добавить комнату'**
  String get roomSheetCreateTitle;

  /// Заголовок sheet редактирования комнаты
  ///
  /// In ru, this message translates to:
  /// **'Изменить комнату'**
  String get roomSheetEditTitle;

  /// Подпись/семантика кнопки закрытия sheet комнаты
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get roomSheetClose;

  /// Метка поля названия комнаты
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get roomSheetNameLabel;

  /// Плейсхолдер поля названия комнаты
  ///
  /// In ru, this message translates to:
  /// **'Например: Гостиная'**
  String get roomSheetNameHint;

  /// Ошибка валидации названия комнаты: пусто или слишком длинное
  ///
  /// In ru, this message translates to:
  /// **'Введите название (до {max} символов)'**
  String roomSheetNameError(int max);

  /// Метка необязательного поля эмодзи комнаты
  ///
  /// In ru, this message translates to:
  /// **'Эмодзи'**
  String get roomSheetEmojiLabel;

  /// Плейсхолдер поля эмодзи комнаты
  ///
  /// In ru, this message translates to:
  /// **'🪴'**
  String get roomSheetEmojiHint;

  /// Подпись: поле эмодзи необязательно
  ///
  /// In ru, this message translates to:
  /// **'необязательно'**
  String get roomSheetEmojiOptional;

  /// Кнопка подтверждения создания комнаты
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get roomSheetCreateSubmit;

  /// Кнопка подтверждения изменения комнаты
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get roomSheetEditSubmit;

  /// Снэкбар-подтверждение после создания комнаты
  ///
  /// In ru, this message translates to:
  /// **'Комната добавлена'**
  String get roomCreated;

  /// Снэкбар-подтверждение после изменения комнаты
  ///
  /// In ru, this message translates to:
  /// **'Комната обновлена'**
  String get roomUpdated;

  /// Снэкбар-подтверждение после удаления комнаты
  ///
  /// In ru, this message translates to:
  /// **'Комната удалена'**
  String get roomDeleted;

  /// Заголовок диалога подтверждения удаления комнаты
  ///
  /// In ru, this message translates to:
  /// **'Удалить комнату?'**
  String get roomDeleteConfirmTitle;

  /// Текст диалога подтверждения удаления комнаты
  ///
  /// In ru, this message translates to:
  /// **'Комната «{name}» будет удалена.'**
  String roomDeleteConfirmMessage(String name);

  /// Кнопка отмены в диалоге удаления комнаты
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get roomDeleteConfirmCancel;

  /// Кнопка подтверждения в диалоге удаления комнаты
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get roomDeleteConfirmDelete;

  /// Надзаголовок-капс в шапке пикера переноса растений
  ///
  /// In ru, this message translates to:
  /// **'Перенос растений'**
  String get roomMoveOverline;

  /// Заголовок пикера переноса растений из удаляемой комнаты
  ///
  /// In ru, this message translates to:
  /// **'Куда перенести растения?'**
  String get roomMoveTitle;

  /// Подпись пикера переноса растений
  ///
  /// In ru, this message translates to:
  /// **'В комнате «{name}» есть растения. Выберите, куда их перенести перед удалением.'**
  String roomMoveSubtitle(String name);

  /// Подпись/семантика кнопки закрытия пикера переноса
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get roomMoveClose;

  /// Строка настроек: открыть превью-флоу экранов входа (визуальная заглушка)
  ///
  /// In ru, this message translates to:
  /// **'Экраны входа (превью)'**
  String get profileAuthPreviewTitle;

  /// Подпись/семантика кнопки возврата на auth-экранах
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get authBack;

  /// Брендовое название в шапке экрана входа
  ///
  /// In ru, this message translates to:
  /// **'PlantCare'**
  String get authBrand;

  /// Метка текущего языка в шапке экрана входа
  ///
  /// In ru, this message translates to:
  /// **'RU'**
  String get authLocale;

  /// Надзаголовок-капс над hero-заголовком экрана входа (экран 07)
  ///
  /// In ru, this message translates to:
  /// **'Дневник для растений'**
  String get authWelcomeOverline;

  /// Hero-заголовок экрана входа (экран 07)
  ///
  /// In ru, this message translates to:
  /// **'Растения, о которых не забывают'**
  String get authWelcomeTitle;

  /// Подпись под hero-заголовком экрана входа
  ///
  /// In ru, this message translates to:
  /// **'Напоминания о поливе, опрыскивании и подкормке. Прямо как от заботливой бабушки — но цифровой.'**
  String get authWelcomeSubtitle;

  /// Кнопка входа через Google (coming soon)
  ///
  /// In ru, this message translates to:
  /// **'Продолжить через Google'**
  String get authContinueGoogle;

  /// Кнопка входа через Apple (только iOS)
  ///
  /// In ru, this message translates to:
  /// **'Продолжить через Apple'**
  String get authContinueApple;

  /// Текст ошибки социального входа (Google/Apple)
  ///
  /// In ru, this message translates to:
  /// **'Не удалось войти. Попробуйте ещё раз.'**
  String get authSocialError;

  /// Кнопка входа через Telegram (переход к вводу кода)
  ///
  /// In ru, this message translates to:
  /// **'Продолжить через Telegram'**
  String get authContinueTelegram;

  /// Разделитель между группами способов входа
  ///
  /// In ru, this message translates to:
  /// **'или'**
  String get authOr;

  /// Кнопка входа как гость (coming soon)
  ///
  /// In ru, this message translates to:
  /// **'Зайти как гость'**
  String get authContinueGuest;

  /// Дисклеймер об условиях и политике на экране входа
  ///
  /// In ru, this message translates to:
  /// **'Нажимая «Продолжить», вы соглашаетесь с условиями и политикой конфиденциальности.'**
  String get authTerms;

  /// Индикатор шага в шапке экрана ввода кода (экран 08)
  ///
  /// In ru, this message translates to:
  /// **'Шаг 2 из 2'**
  String get authCodeStepIndicator;

  /// Надзаголовок-капс над заголовком экрана ввода кода
  ///
  /// In ru, this message translates to:
  /// **'Telegram · подтверждение'**
  String get authCodeOverline;

  /// Заголовок экрана ввода кода (экран 08)
  ///
  /// In ru, this message translates to:
  /// **'Введите код из чата с ботом'**
  String get authCodeTitle;

  /// Подпись экрана ввода кода с именем бота-назначения
  ///
  /// In ru, this message translates to:
  /// **'Мы написали вам в {bot}. Откройте Telegram и скопируйте 6-значный код.'**
  String authCodeSubtitle(String bot);

  /// Плейсхолдер назначения кода — имя Telegram-бота (статичная заглушка)
  ///
  /// In ru, this message translates to:
  /// **'@PlantCareBot'**
  String get authCodeBot;

  /// Текст обратного отсчёта до повторной отправки кода (mm:ss)
  ///
  /// In ru, this message translates to:
  /// **'Отправить новый код через {seconds}'**
  String authResendIn(String seconds);

  /// Кликабельная подпись повторной отправки кода (таймер досчитал)
  ///
  /// In ru, this message translates to:
  /// **'Отправить код повторно'**
  String get authResend;

  /// Семантика клавиши backspace цифровой клавиатуры
  ///
  /// In ru, this message translates to:
  /// **'Удалить цифру'**
  String get authKeypadBackspace;

  /// Семантика цифровой клавиши клавиатуры
  ///
  /// In ru, this message translates to:
  /// **'Цифра {digit}'**
  String authKeypadDigit(String digit);

  /// Основная кнопка «Продолжить» на экране ввода кода (активна при полном коде)
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get authContinue;

  /// Надзаголовок-капс на экране приветствия после входа (экран 09)
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт привязан · Telegram'**
  String get authWelcomeBackOverline;

  /// Имя пользователя на экране приветствия (статичная заглушка превью-флоу)
  ///
  /// In ru, this message translates to:
  /// **'Алина'**
  String get authWelcomeBackName;

  /// Приветственный заголовок экрана 09 с именем пользователя
  ///
  /// In ru, this message translates to:
  /// **'Привет, {name}'**
  String authWelcomeBackTitle(String name);

  /// Подпись под приветствием на экране 09
  ///
  /// In ru, this message translates to:
  /// **'Тут будет жить ваш сад. Добавим первое растение — и научимся его понимать.'**
  String get authWelcomeBackSubtitle;

  /// Чип на экране приветствия: напоминания
  ///
  /// In ru, this message translates to:
  /// **'Напоминания'**
  String get authChipReminders;

  /// Чип на экране приветствия: дневник
  ///
  /// In ru, this message translates to:
  /// **'Дневник'**
  String get authChipJournal;

  /// Чип на экране приветствия: календарь
  ///
  /// In ru, this message translates to:
  /// **'Календарь'**
  String get authChipCalendar;

  /// Основная кнопка экрана 09: перейти к мастеру добавления растения
  ///
  /// In ru, this message translates to:
  /// **'Добавить первое растение'**
  String get authAddFirstPlant;

  /// Вторичная ссылка экрана 09: уйти на главную без добавления растения
  ///
  /// In ru, this message translates to:
  /// **'Я просто посмотрю'**
  String get authGoHome;

  /// Экран 27: ссылка вверху справа — отложить запрос разрешения на пуши
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get pushPrimingSkip;

  /// Экран 27: первая часть hero-заголовка (обычное начертание)
  ///
  /// In ru, this message translates to:
  /// **'Я напомню '**
  String get pushPrimingTitleLead;

  /// Экран 27: акцентное слово hero-заголовка (серифный курсив)
  ///
  /// In ru, this message translates to:
  /// **'вовремя'**
  String get pushPrimingTitleAccent;

  /// Экран 27: подзаголовок-объяснение ценности уведомлений
  ///
  /// In ru, this message translates to:
  /// **'Растения будут писать тебе сами — когда захотят пить, и только в удобные часы. Без спама.'**
  String get pushPrimingSubtitle;

  /// Экран 27: заголовок образца пуш-уведомления (имя растения + время)
  ///
  /// In ru, this message translates to:
  /// **'Моника · сейчас'**
  String get pushPrimingPreviewTitle;

  /// Экран 27: текст образца пуш-уведомления (voice line растения)
  ///
  /// In ru, this message translates to:
  /// **'«Полей меня, пожалуйста!»'**
  String get pushPrimingPreviewBody;

  /// Экран 27: основная кнопка — согласиться на пуши
  ///
  /// In ru, this message translates to:
  /// **'Разрешить уведомления'**
  String get pushPrimingAllow;

  /// Экран 27: подпись под кнопкой о возможности изменить разрешение позже
  ///
  /// In ru, this message translates to:
  /// **'Можно изменить в любой момент в настройках'**
  String get pushPrimingFootnote;

  /// Заголовок экрана ввода email для magic link
  ///
  /// In ru, this message translates to:
  /// **'Вход по почте'**
  String get authEmailTitle;

  /// Подзаголовок экрана ввода email: объяснение magic-link флоу
  ///
  /// In ru, this message translates to:
  /// **'Введите адрес — пришлём ссылку для входа. Пароль не нужен.'**
  String get authEmailSubtitle;

  /// Подпись поля ввода email
  ///
  /// In ru, this message translates to:
  /// **'Электронная почта'**
  String get authEmailLabel;

  /// Плейсхолдер поля ввода email
  ///
  /// In ru, this message translates to:
  /// **'you@example.com'**
  String get authEmailHint;

  /// Сообщение о неверном формате email под полем ввода
  ///
  /// In ru, this message translates to:
  /// **'Проверьте адрес почты'**
  String get authEmailInvalid;

  /// Основная кнопка экрана ввода email: запросить magic link
  ///
  /// In ru, this message translates to:
  /// **'Получить ссылку'**
  String get authSendLink;

  /// Заголовок состояния после отправки magic link
  ///
  /// In ru, this message translates to:
  /// **'Проверьте почту'**
  String get authLinkSentTitle;

  /// Подзаголовок состояния после отправки magic link
  ///
  /// In ru, this message translates to:
  /// **'Мы отправили ссылку для входа. Откройте её на этом устройстве.'**
  String get authLinkSentSubtitle;

  /// Текст экрана проверки magic-link токена во время обмена
  ///
  /// In ru, this message translates to:
  /// **'Проверяем ссылку…'**
  String get authVerifying;

  /// Сообщение об ошибке проверки magic-link токена
  ///
  /// In ru, this message translates to:
  /// **'Ссылка недействительна или устарела. Запросите новую.'**
  String get authVerifyError;

  /// Кнопка возврата на экран входа после ошибки проверки токена
  ///
  /// In ru, this message translates to:
  /// **'Вернуться ко входу'**
  String get authVerifyRetry;

  /// Подпись dev-хука ручного ввода magic-link токена (только дебаг)
  ///
  /// In ru, this message translates to:
  /// **'Dev: вставить токен'**
  String get authDevTokenLabel;

  /// Заголовок строки настроек, ведущей на экран «Архив» (17)
  ///
  /// In ru, this message translates to:
  /// **'Архив'**
  String get profileArchiveTitle;

  /// Семантика кнопки «назад» на экране «Архив»
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get archiveBack;

  /// Надзаголовок (eyebrow) экрана «Архив» со счётчиком архивных растений
  ///
  /// In ru, this message translates to:
  /// **'Архив · {count, plural, =0{нет растений} one{{count} растение} few{{count} растения} many{{count} растений} other{{count} растения}}'**
  String archiveEyebrow(int count);

  /// Серифный заголовок экрана «Архив», обычная часть перед акцентом (напр. «В »)
  ///
  /// In ru, this message translates to:
  /// **'В '**
  String get archiveHeadingLead;

  /// Серифный заголовок экрана «Архив», акцентная часть (primary italic, напр. «памяти»)
  ///
  /// In ru, this message translates to:
  /// **'памяти'**
  String get archiveHeadingAccent;

  /// Подпись под заголовком экрана «Архив»
  ///
  /// In ru, this message translates to:
  /// **'Растения, с которыми пути разошлись. Их история — здесь, а не в корзине.'**
  String get archiveSubtitle;

  /// Префикс строки срока жизни для подаренного растения (мужской род, без «о»)
  ///
  /// In ru, this message translates to:
  /// **'Прожил рядом ·'**
  String get archiveLivedPrefixGifted;

  /// Префикс строки срока жизни для погибшего растения (средний род)
  ///
  /// In ru, this message translates to:
  /// **'Прожило рядом ·'**
  String get archiveLivedPrefix;

  /// Чип на карточке архивного растения (открыть дневник) — coming soon
  ///
  /// In ru, this message translates to:
  /// **'Открыть дневник'**
  String get archiveOpenDiary;

  /// Чип на карточке архивного растения (вспомнить) — coming soon
  ///
  /// In ru, this message translates to:
  /// **'Вспомнить'**
  String get archiveRemember;

  /// Eyebrow карточки ретроспективы на экране «Архив»
  ///
  /// In ru, this message translates to:
  /// **'Ретроспектива'**
  String get archiveRetrospectiveLabel;

  /// Текст карточки ретроспективы со средним сроком жизни
  ///
  /// In ru, this message translates to:
  /// **'Растения живут с тобой в среднем {avg}'**
  String archiveRetrospectiveText(String avg);

  /// Подпись карточки ретроспективы на экране «Архив»
  ///
  /// In ru, this message translates to:
  /// **'Это нормально. Каждое — память и опыт.'**
  String get archiveRetrospectiveHint;

  /// Заголовок пустого состояния экрана «Архив»
  ///
  /// In ru, this message translates to:
  /// **'Архив пуст'**
  String get archiveEmpty;

  /// Подпись пустого состояния экрана «Архив»
  ///
  /// In ru, this message translates to:
  /// **'Здесь появятся растения, с которыми ваши пути разойдутся.'**
  String get archiveEmptyHint;

  /// Микро-строка погоды на Home (G4): относительная влажность воздуха
  ///
  /// In ru, this message translates to:
  /// **'Влажность {humidity}%'**
  String weatherHumidity(int humidity);

  /// Совет погоды на Home (G4) для рекомендации DEFER_OK
  ///
  /// In ru, this message translates to:
  /// **'Влажно — полив можно отложить'**
  String get weatherAdviceDeferOk;

  /// Совет погоды на Home (G4) для рекомендации DO_NOT_DEFER
  ///
  /// In ru, this message translates to:
  /// **'Сухо — не пропускай полив'**
  String get weatherAdviceDoNotDefer;

  /// Semantics-метка строки погоды (G4) с советом
  ///
  /// In ru, this message translates to:
  /// **'Погода: влажность {humidity}%, {advice}'**
  String weatherSemanticsWithAdvice(int humidity, String advice);

  /// Semantics-метка строки погоды (G4) без совета
  ///
  /// In ru, this message translates to:
  /// **'Погода: влажность {humidity}%'**
  String weatherSemanticsHumidityOnly(int humidity);

  /// Курсивная подпись под ростком на полноэкранном скелетоне загрузки Home (экран 28)
  ///
  /// In ru, this message translates to:
  /// **'Собираю твой сад…'**
  String get homeLoadingCaption;

  /// Заголовок офлайн-баннера на полноэкранном офлайн-состоянии (экран 29)
  ///
  /// In ru, this message translates to:
  /// **'Нет связи с садом'**
  String get offlineBannerTitle;

  /// Статус-метка справа в офлайн-баннере (экран 29)
  ///
  /// In ru, this message translates to:
  /// **'офлайн'**
  String get offlineBannerStatus;

  /// Серифный заголовок офлайн-состояния, обычная часть перед акцентом (экран 29)
  ///
  /// In ru, this message translates to:
  /// **'Сад на минутку '**
  String get offlineTitleLead;

  /// Серифный заголовок офлайн-состояния, акцентная часть (primary italic, экран 29)
  ///
  /// In ru, this message translates to:
  /// **'вне зоны'**
  String get offlineTitleAccent;

  /// Подпись офлайн-состояния (экран 29)
  ///
  /// In ru, this message translates to:
  /// **'Не получается достучаться до сервера. Проверь интернет — твои растения никуда не денутся.'**
  String get offlineMessage;

  /// Надзаголовок (eyebrow) экрана 33 «Успех первого ухода»
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get firstCareSuccessEyebrow;

  /// Hero-заголовок экрана 33 после первого полива. Род слова «напоена» зафиксирован формой дизайна (грамматический род произвольной клички недоступен на клиенте — косметическое ограничение).
  ///
  /// In ru, this message translates to:
  /// **'{plant} напоена'**
  String firstCareSuccessTitleWater(String plant);

  /// Hero-заголовок экрана 33 после первого опрыскивания.
  ///
  /// In ru, this message translates to:
  /// **'{plant} опрыскана'**
  String firstCareSuccessTitleSpray(String plant);

  /// Hero-заголовок экрана 33 после первого внесения удобрения.
  ///
  /// In ru, this message translates to:
  /// **'{plant} удобрена'**
  String firstCareSuccessTitleFertilize(String plant);

  /// Нейтральный hero-заголовок экрана 33 для нераспознанного типа ухода.
  ///
  /// In ru, this message translates to:
  /// **'{plant} — уход отмечен'**
  String firstCareSuccessTitleGeneric(String plant);

  /// Акцентное слово-глагол hero-заголовка экрана 33 (полив) — выделяется курсивом и цветом primary.
  ///
  /// In ru, this message translates to:
  /// **'напоена'**
  String get firstCareSuccessVerbWater;

  /// Акцентное слово-глагол hero-заголовка экрана 33 (опрыскивание).
  ///
  /// In ru, this message translates to:
  /// **'опрыскана'**
  String get firstCareSuccessVerbSpray;

  /// Акцентное слово-глагол hero-заголовка экрана 33 (удобрение).
  ///
  /// In ru, this message translates to:
  /// **'удобрена'**
  String get firstCareSuccessVerbFertilize;

  /// Реплика-благодарность растения в speech-bubble экрана 33 (голос растения — первый уход, issue #91).
  ///
  /// In ru, this message translates to:
  /// **'«Спасибо! Ты мой лучший садовник 🌿»'**
  String get firstCareSuccessBubble;

  /// Нейтральное имя растения на экране 33, если деталь не загрузилась (уход уже записан — не показываем как ошибку).
  ///
  /// In ru, this message translates to:
  /// **'Растение'**
  String get firstCareSuccessFallbackPlantName;

  /// Чип старта стрика на экране 33 (только при onTime == true). Формат из issue #91.
  ///
  /// In ru, this message translates to:
  /// **'День 1 🔥'**
  String get firstCareSuccessStreakDayOne;

  /// Строка ободрения внизу экрана 33 БЕЗ счётчика дней (интервал до следующего ухода недоступен, G19).
  ///
  /// In ru, this message translates to:
  /// **'Я напомню, когда придёт время следующего ухода.'**
  String get firstCareSuccessNextHint;

  /// Префикс строки-счётчика экрана 33 для полива: перед болд-частью «через N дн.».
  ///
  /// In ru, this message translates to:
  /// **'Следующий полив — '**
  String get firstCareSuccessNextPrefixWater;

  /// Префикс строки-счётчика экрана 33 для опрыскивания: перед болд-частью «через N дн.».
  ///
  /// In ru, this message translates to:
  /// **'Следующее опрыскивание — '**
  String get firstCareSuccessNextPrefixSpray;

  /// Префикс строки-счётчика экрана 33 для подкормки: перед болд-частью «через N дн.».
  ///
  /// In ru, this message translates to:
  /// **'Следующая подкормка — '**
  String get firstCareSuccessNextPrefixFertilize;

  /// Суффикс строки-счётчика экрана 33 после болд-части «через N дн.» (общий для всех типов ухода).
  ///
  /// In ru, this message translates to:
  /// **', напомню сама'**
  String get firstCareSuccessNextSuffix;

  /// CTA-кнопка экрана 33 → возврат на карточку растения (issue #91).
  ///
  /// In ru, this message translates to:
  /// **'Отлично'**
  String get firstCareSuccessCta;

  /// Надзаголовок экрана 21 «Полная история ухода»
  ///
  /// In ru, this message translates to:
  /// **'Дневник ухода'**
  String get careHistoryOverline;

  /// Ссылка-вход на полную историю ухода с карточки растения (02 → «Дневник · Всё»)
  ///
  /// In ru, this message translates to:
  /// **'Всё'**
  String get careHistoryViewAll;

  /// Подпись плитки сводки: всего записей истории
  ///
  /// In ru, this message translates to:
  /// **'забот\nвсего'**
  String get careHistorySummaryTotalLabel;

  /// Значение плитки сводки: всего записей
  ///
  /// In ru, this message translates to:
  /// **'{count}'**
  String careHistorySummaryTotalValue(int count);

  /// Подпись плитки сводки: доля уходов вовремя
  ///
  /// In ru, this message translates to:
  /// **'вовремя'**
  String get careHistorySummaryOnTimeLabel;

  /// Значение плитки сводки: процент уходов вовремя
  ///
  /// In ru, this message translates to:
  /// **'{percent}%'**
  String careHistorySummaryOnTimeValue(int percent);

  /// Подпись плитки сводки: серия уходов вовремя
  ///
  /// In ru, this message translates to:
  /// **'дней\nстрик'**
  String get careHistorySummaryStreakLabel;

  /// Значение плитки сводки: длина серии
  ///
  /// In ru, this message translates to:
  /// **'{count}'**
  String careHistorySummaryStreakValue(int count);

  /// Фильтр-чип «все типы ухода» на экране 21
  ///
  /// In ru, this message translates to:
  /// **'Всё'**
  String get careHistoryFilterAll;

  /// Дата записи таймлайна: день недели, число, время (локальная TZ)
  ///
  /// In ru, this message translates to:
  /// **'{dow} {day} · {time}'**
  String careHistoryEntryDate(String dow, String day, String time);

  /// Метка записи таймлайна: уход выполнен в срок
  ///
  /// In ru, this message translates to:
  /// **'ВОВРЕМЯ'**
  String get careHistoryOnTime;

  /// Метка записи таймлайна: уход выполнен с опозданием
  ///
  /// In ru, this message translates to:
  /// **'С ОПОЗДАНИЕМ'**
  String get careHistoryLate;

  /// Маркер появления растения в конце таймлайна
  ///
  /// In ru, this message translates to:
  /// **'{name} появилась у тебя · {date}'**
  String careHistoryPlantCreated(String name, String date);

  /// Кнопка дозагрузки следующей страницы истории
  ///
  /// In ru, this message translates to:
  /// **'Показать ещё'**
  String get careHistoryLoadMore;

  /// Ошибка дозагрузки страницы истории (показанный список сохранён)
  ///
  /// In ru, this message translates to:
  /// **'Не удалось дозагрузить историю'**
  String get careHistoryLoadMoreError;

  /// Заголовок пустого дневника (экран 31), первая часть
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get careHistoryEmptyTitle;

  /// Заголовок пустого дневника (экран 31), акцентная часть
  ///
  /// In ru, this message translates to:
  /// **'только начинается'**
  String get careHistoryEmptyTitleAccent;

  /// Реплика растения в пустом дневнике (экран 31)
  ///
  /// In ru, this message translates to:
  /// **'Я только переехал к тебе. Отметь первый уход — и начнём вести историю вместе.'**
  String get careHistoryEmptyBubble;

  /// Подпись автора реплики в пустом дневнике
  ///
  /// In ru, this message translates to:
  /// **'— {name}'**
  String careHistoryEmptyAuthor(String name);

  /// CTA пустого дневника (экран 31): открыть отметку ухода
  ///
  /// In ru, this message translates to:
  /// **'Отметить первый уход'**
  String get careHistoryEmptyCta;

  /// Строка настроек профиля → экран 14 «Месячный отчёт»
  ///
  /// In ru, this message translates to:
  /// **'Месячный отчёт'**
  String get profileReportTitle;

  /// Кнопка «Поделиться» в шапке отчёта (экран 14)
  ///
  /// In ru, this message translates to:
  /// **'Поделиться'**
  String get reportShare;

  /// Кнопка «назад» на экране месячного отчёта (экран 14)
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get reportBack;

  /// Семантическая метка кнопки «<» переключения на предыдущий месяц в отчёте
  ///
  /// In ru, this message translates to:
  /// **'Предыдущий месяц'**
  String get reportPrevMonth;

  /// Семантическая метка кнопки «>» переключения на следующий месяц в отчёте
  ///
  /// In ru, this message translates to:
  /// **'Следующий месяц'**
  String get reportNextMonth;

  /// Надстрочник hero на экране отчёта: «Отчёт · май 2026»
  ///
  /// In ru, this message translates to:
  /// **'Отчёт · {month}'**
  String reportOverline(String month);

  /// Hero-заголовок отчёта при высоком проценте вовремя
  ///
  /// In ru, this message translates to:
  /// **'Месяц прошёл отлично'**
  String get reportTitleGreat;

  /// Hero-заголовок отчёта при среднем проценте вовремя
  ///
  /// In ru, this message translates to:
  /// **'Хороший месяц'**
  String get reportTitleGood;

  /// Нейтральный hero-заголовок отчёта (нет данных по проценту / низкий)
  ///
  /// In ru, this message translates to:
  /// **'Итоги месяца'**
  String get reportTitleNeutral;

  /// Подзаголовок hero про текущий стрик
  ///
  /// In ru, this message translates to:
  /// **'Стрик {streak, plural, one{{streak} день} few{{streak} дня} many{{streak} дней} other{{streak} дня}} заботы подряд. Так держать.'**
  String reportSubtitleStreak(int streak);

  /// Подзаголовок hero, когда стрик 0
  ///
  /// In ru, this message translates to:
  /// **'Понемногу складывается твоя история заботы.'**
  String get reportSubtitleNoStreak;

  /// Подпись большого числа: стрик
  ///
  /// In ru, this message translates to:
  /// **'дней\nподряд'**
  String get reportStatStreak;

  /// Подпись большого числа: выполнено забот
  ///
  /// In ru, this message translates to:
  /// **'забот\nвыполнено'**
  String get reportStatDone;

  /// Подпись большого числа: процент вовремя
  ///
  /// In ru, this message translates to:
  /// **'вовремя'**
  String get reportStatOnTime;

  /// Подпись большого числа: пропусков (просрочено)
  ///
  /// In ru, this message translates to:
  /// **'пропусков'**
  String get reportStatOverdue;

  /// Плейсхолдер числа, когда данных нет (например процент вовремя null)
  ///
  /// In ru, this message translates to:
  /// **'—'**
  String get reportNoData;

  /// Формат процента вовремя на экране отчёта
  ///
  /// In ru, this message translates to:
  /// **'{value}%'**
  String reportPercent(int value);

  /// Заголовок секции разбивки выполненного по типам ухода
  ///
  /// In ru, this message translates to:
  /// **'По типам заботы'**
  String get reportByTypeLabel;

  /// Заголовок секции недельного тренда
  ///
  /// In ru, this message translates to:
  /// **'По неделям'**
  String get reportTrendLabel;

  /// Подпись недели в тренде: сколько выполнено
  ///
  /// In ru, this message translates to:
  /// **'{done, plural, one{{done} забота} few{{done} заботы} many{{done} забот} other{{done} заботы}}'**
  String reportTrendWeekDone(int done);

  /// Короткая подпись недели в тренде (номер ISO-недели)
  ///
  /// In ru, this message translates to:
  /// **'Нед. {number}'**
  String reportWeekLabel(String number);

  /// Нижняя CTA-кнопка «Поделиться отчётом» (экран 14)
  ///
  /// In ru, this message translates to:
  /// **'Поделиться отчётом'**
  String get reportShareCta;

  /// Первая строка текста для share sheet: заголовок с месяцем
  ///
  /// In ru, this message translates to:
  /// **'🌿 Мой отчёт за {month}'**
  String reportShareTextHeader(String month);

  /// Строка share-текста: количество выполненных уходов
  ///
  /// In ru, this message translates to:
  /// **'Обработано уходов: {count}'**
  String reportShareTextCares(int count);

  /// Строка share-текста: процент уходов вовремя
  ///
  /// In ru, this message translates to:
  /// **'Вовремя: {pct}%'**
  String reportShareTextOnTime(int pct);

  /// Подпись приложения в конце share-текста
  ///
  /// In ru, this message translates to:
  /// **'Plants Care App'**
  String get reportShareTextAppCredit;

  /// Заголовок пустого состояния отчёта (нет заботы за месяц)
  ///
  /// In ru, this message translates to:
  /// **'Пока пусто'**
  String get reportEmptyTitle;

  /// Текст пустого состояния отчёта
  ///
  /// In ru, this message translates to:
  /// **'За этот месяц ещё нет заботы. Отметь первый уход — и здесь появятся твои итоги.'**
  String get reportEmptyBody;

  /// Overline в шапке экрана 22 «Редактирование расписания»: имя растения
  ///
  /// In ru, this message translates to:
  /// **'Расписание · {plant}'**
  String editScheduleOverline(String plant);

  /// Серифный заголовок экрана 22
  ///
  /// In ru, this message translates to:
  /// **'Как часто заботиться?'**
  String get editScheduleTitle;

  /// Подпись под заголовком экрана 22
  ///
  /// In ru, this message translates to:
  /// **'Интервалы влияют на напоминания и стрик'**
  String get editScheduleSubtitle;

  /// Кнопка сохранения изменений расписания (шапка экрана 22)
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get editScheduleDone;

  /// Кнопка «назад» в шапке экрана 22
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get editScheduleBack;

  /// Префикс строки «Следующий уход · {когда}» на карточке типа ухода
  ///
  /// In ru, this message translates to:
  /// **'Следующий уход'**
  String get editScheduleNextCare;

  /// Подпись на карточке, когда расписание выключено
  ///
  /// In ru, this message translates to:
  /// **'Выключено'**
  String get editScheduleDisabled;

  /// Подпись степпера интервала «Каждые N дн.»
  ///
  /// In ru, this message translates to:
  /// **'Каждые'**
  String get editScheduleEvery;

  /// Подпись степпера объёма воды (только для полива)
  ///
  /// In ru, this message translates to:
  /// **'Объём воды'**
  String get editScheduleWaterAmount;

  /// Значение степпера интервала: N дн.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} дн.} few{{count} дн.} many{{count} дн.} other{{count} дн.}}'**
  String editScheduleDaysUnit(int count);

  /// Значение степпера объёма воды: N мл
  ///
  /// In ru, this message translates to:
  /// **'{count} мл'**
  String editScheduleMlUnit(int count);

  /// Плейсхолдер объёма воды, когда значение не задано
  ///
  /// In ru, this message translates to:
  /// **'—'**
  String get editScheduleAmountUnset;

  /// Относительный срок следующего ухода: сегодня
  ///
  /// In ru, this message translates to:
  /// **'сегодня'**
  String get editScheduleDueToday;

  /// Относительный срок следующего ухода: завтра
  ///
  /// In ru, this message translates to:
  /// **'завтра'**
  String get editScheduleDueTomorrow;

  /// Относительный срок следующего ухода: просрочено (в прошлом)
  ///
  /// In ru, this message translates to:
  /// **'просрочено'**
  String get editScheduleDueOverdue;

  /// Относительный срок следующего ухода: через N дн.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{через {count} дн.} few{через {count} дн.} many{через {count} дн.} other{через {count} дн.}}'**
  String editScheduleDueInDays(int count);

  /// Заголовок карточки сброса интервалов к рекомендованным для вида
  ///
  /// In ru, this message translates to:
  /// **'Сбросить к рекомендованным'**
  String get editScheduleResetTitle;

  /// Подпись карточки сброса интервалов к рекомендованным
  ///
  /// In ru, this message translates to:
  /// **'Интервалы из каталога для вашего вида'**
  String get editScheduleResetSubtitle;

  /// Декоративная цитата-заметка внизу экрана 22
  ///
  /// In ru, this message translates to:
  /// **'«Летом я пью чаще — можешь поставить полив раз в 5 дней, а зимой вернуть на 9.»'**
  String get editScheduleNote;

  /// Заголовок пустого состояния (backend не вернул ни одного расписания)
  ///
  /// In ru, this message translates to:
  /// **'Расписаний пока нет'**
  String get editScheduleEmptyTitle;

  /// Текст пустого состояния экрана 22
  ///
  /// In ru, this message translates to:
  /// **'Для этого растения ещё не настроены интервалы ухода.'**
  String get editScheduleEmptyBody;

  /// Снэкбар при ошибке сохранения, когда тип ошибки общий
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить расписание. Попробуй ещё раз.'**
  String get editScheduleSaveError;

  /// Заголовок-overline экрана 24 «Лента уведомлений»
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notificationsTitle;

  /// Серифный заголовок экрана 24: число непрочитанных уведомлений
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Пока тихо в твоём саду} one{{count} новое от твоего сада} few{{count} новых от твоего сада} many{{count} новых от твоего сада} other{{count} новых от твоего сада}}'**
  String notificationsHeroCount(int count);

  /// Кнопка в шапке экрана 24 — пометить видимые непрочитанные прочитанными
  ///
  /// In ru, this message translates to:
  /// **'Прочитать'**
  String get notificationsMarkAllRead;

  /// Заголовок группы уведомлений за сегодня (экран 24)
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get notificationsGroupToday;

  /// Заголовок группы уведомлений за вчера (экран 24)
  ///
  /// In ru, this message translates to:
  /// **'Вчера'**
  String get notificationsGroupYesterday;

  /// Метка времени уведомления (час:минута в локальной TZ)
  ///
  /// In ru, this message translates to:
  /// **'в {time}'**
  String notificationsTimeAt(String time);

  /// Текст ошибки дозагрузки страницы ленты (экран 24)
  ///
  /// In ru, this message translates to:
  /// **'Не удалось дозагрузить уведомления'**
  String get notificationsLoadMoreError;

  /// Семантическая метка для индикатора непрочитанного уведомления
  ///
  /// In ru, this message translates to:
  /// **'непрочитано'**
  String get notificationsUnreadSemantic;

  /// Категорийная/семантическая метка типа уведомления «уход»
  ///
  /// In ru, this message translates to:
  /// **'Уход'**
  String get notificationsTypeCare;

  /// Метка типа уведомления «тревога»
  ///
  /// In ru, this message translates to:
  /// **'Тревога'**
  String get notificationsTypeAlert;

  /// Метка типа уведомления «награда/достижение»
  ///
  /// In ru, this message translates to:
  /// **'Достижение'**
  String get notificationsTypeAward;

  /// Метка типа уведомления «отчёт»
  ///
  /// In ru, this message translates to:
  /// **'Отчёт'**
  String get notificationsTypeReport;

  /// Метка типа уведомления «системное»
  ///
  /// In ru, this message translates to:
  /// **'Системное'**
  String get notificationsTypeSystem;

  /// Лид серифного заголовка пустой ленты (экран 32) перед акцентным словом
  ///
  /// In ru, this message translates to:
  /// **'Пока '**
  String get notificationsEmptyTitleLead;

  /// Акцентная часть заголовка пустой ленты (экран 32)
  ///
  /// In ru, this message translates to:
  /// **'тихо'**
  String get notificationsEmptyTitleAccent;

  /// Подзаголовок пустой ленты (экран 32)
  ///
  /// In ru, this message translates to:
  /// **'Все растения довольны — ни одной заботы не пропущено. Загляну сюда, когда кому-то понадобится внимание.'**
  String get notificationsEmptyMessage;

  /// Успокаивающий чип на пустой ленте (экран 32). Без числа растений — провайдера счётчика растений в порядке здесь нет
  ///
  /// In ru, this message translates to:
  /// **'Сад в порядке'**
  String get notificationsEmptyChip;

  /// Подсказка/семантика колокольчика на главной с числом непрочитанных
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{Уведомления} one{Уведомления: {count} непрочитанное} few{Уведомления: {count} непрочитанных} many{Уведомления: {count} непрочитанных} other{Уведомления: {count} непрочитанных}}'**
  String notificationsBadgeTooltip(int count);

  /// Заголовок секции-входа в редактирование расписания на карточке растения
  ///
  /// In ru, this message translates to:
  /// **'Расписание ухода'**
  String get plantCardScheduleTitle;

  /// Ссылка-вход «Изменить» в редактирование расписания (карточка растения)
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get plantCardScheduleEdit;

  /// Строка профиля — вход на экран 23 «Тихие часы»
  ///
  /// In ru, this message translates to:
  /// **'Уведомления и время'**
  String get profileNotificationsTitle;

  /// Строка профиля — вход на экран 25 «Режим отпуска»
  ///
  /// In ru, this message translates to:
  /// **'Режим отпуска'**
  String get profileVacationTitle;

  /// Строка профиля — вход на экран 35 «Сезонные интервалы»
  ///
  /// In ru, this message translates to:
  /// **'Сезонные интервалы'**
  String get profileSeasonalTitle;

  /// Кнопка «назад» экрана 23
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get quietHoursBack;

  /// Оверлайн шапки экрана 23
  ///
  /// In ru, this message translates to:
  /// **'Уведомления и время'**
  String get quietHoursOverline;

  /// Серифный заголовок 23, обычная часть перед акцентом
  ///
  /// In ru, this message translates to:
  /// **'Тихие '**
  String get quietHoursTitleLead;

  /// Серифный заголовок 23, акцентная курсивная часть
  ///
  /// In ru, this message translates to:
  /// **'часы'**
  String get quietHoursTitleAccent;

  /// Подзаголовок экрана 23
  ///
  /// In ru, this message translates to:
  /// **'Ночью растения подождут до утра — не разбудят пушем.'**
  String get quietHoursSubtitle;

  /// Подпись в центре кольца: сколько часов тишины
  ///
  /// In ru, this message translates to:
  /// **'{hours, plural, one{{hours} час тишины} few{{hours} часа тишины} many{{hours} часов тишины} other{{hours} часа тишины}}'**
  String quietHoursRingCount(int hours);

  /// Легенда кольца — период активных напоминаний
  ///
  /// In ru, this message translates to:
  /// **'Напоминания идут'**
  String get quietHoursLegendOn;

  /// Легенда кольца — период тишины
  ///
  /// In ru, this message translates to:
  /// **'Тишина'**
  String get quietHoursLegendQuiet;

  /// Карточка-кнопка начала тихих часов на экране 23
  ///
  /// In ru, this message translates to:
  /// **'Засыпаю в'**
  String get quietHoursStartLabel;

  /// Карточка-кнопка конца тихих часов на экране 23
  ///
  /// In ru, this message translates to:
  /// **'Просыпаюсь в'**
  String get quietHoursEndLabel;

  /// Заголовок секции параметров на экране 23
  ///
  /// In ru, this message translates to:
  /// **'Параметры'**
  String get quietHoursParamsSection;

  /// Строка «Таймзона» в секции параметров (экран 23)
  ///
  /// In ru, this message translates to:
  /// **'Таймзона'**
  String get quietHoursTimezoneTitle;

  /// Значение таймзоны: город и GMT-метка
  ///
  /// In ru, this message translates to:
  /// **'{city} · {gmt}'**
  String quietHoursTimezoneValue(String city, String gmt);

  /// Декоративная (неактивная) строка-тумблер на экране 23, не покрыта backend
  ///
  /// In ru, this message translates to:
  /// **'Не беспокоить ночью'**
  String get quietHoursDndTitle;

  /// Подпись декоративной строки «Не беспокоить ночью»
  ///
  /// In ru, this message translates to:
  /// **'Перенести просроченное на утро'**
  String get quietHoursDndSubtitle;

  /// Декоративная (неактивная) строка дайджеста на экране 23, не покрыта backend
  ///
  /// In ru, this message translates to:
  /// **'Утренний дайджест'**
  String get quietHoursDigestTitle;

  /// Подпись декоративной строки «Утренний дайджест»
  ///
  /// In ru, this message translates to:
  /// **'Все заботы дня одним сообщением'**
  String get quietHoursDigestSubtitle;

  /// Декоративное фиксированное время утреннего дайджеста
  ///
  /// In ru, this message translates to:
  /// **'9:00'**
  String get quietHoursDigestTime;

  /// Бейдж «скоро» для контролов, ещё не покрытых backend (экран 23)
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get quietHoursSoon;

  /// Декоративная цитата внизу экрана 23
  ///
  /// In ru, this message translates to:
  /// **'«Если меня надо полить в 3 ночи — напомню в 8 утра. Спи спокойно.»'**
  String get quietHoursQuote;

  /// Снэкбар при ошибке сохранения тихих часов/таймзоны (общий тип)
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сохранить. Попробуй ещё раз.'**
  String get quietHoursSaveError;

  /// Оверлайн пикера 36 при выборе начала тихих часов
  ///
  /// In ru, this message translates to:
  /// **'Тихие часы начинаются'**
  String get timePickerStartOverline;

  /// Оверлайн пикера 36 при выборе конца тихих часов
  ///
  /// In ru, this message translates to:
  /// **'Тихие часы заканчиваются'**
  String get timePickerEndOverline;

  /// Заголовок пикера 36 при выборе начала
  ///
  /// In ru, this message translates to:
  /// **'Засыпаю в'**
  String get timePickerStartTitle;

  /// Заголовок пикера 36 при выборе конца
  ///
  /// In ru, this message translates to:
  /// **'Просыпаюсь в'**
  String get timePickerEndTitle;

  /// Кнопка применения выбора времени (пикер 36)
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get timePickerDone;

  /// Кнопка «назад» экрана 37
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get timezoneBack;

  /// Оверлайн шапки экрана 37
  ///
  /// In ru, this message translates to:
  /// **'Таймзона'**
  String get timezoneOverline;

  /// Серифный заголовок 37, обычная часть перед акцентом
  ///
  /// In ru, this message translates to:
  /// **'Когда у тебя '**
  String get timezoneTitleLead;

  /// Серифный заголовок 37, акцентная курсивная часть
  ///
  /// In ru, this message translates to:
  /// **'утро'**
  String get timezoneTitleAccent;

  /// Серифный заголовок 37, хвост после акцента (знак вопроса)
  ///
  /// In ru, this message translates to:
  /// **'?'**
  String get timezoneTitleTail;

  /// Плейсхолдер поля поиска на экране 37
  ///
  /// In ru, this message translates to:
  /// **'Город или регион…'**
  String get timezoneSearchHint;

  /// Заголовок секции списка таймзон (экран 37)
  ///
  /// In ru, this message translates to:
  /// **'Россия'**
  String get timezoneSectionRussia;

  /// Пустой результат поиска по таймзонам (экран 37)
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get timezoneEmpty;

  /// Semantics-метка галочки выбранной таймзоны (экран 37)
  ///
  /// In ru, this message translates to:
  /// **'Выбрано'**
  String get timezoneSelectedHint;

  /// Строка профиля — вход на экран 19 «Список покупок»
  ///
  /// In ru, this message translates to:
  /// **'Список покупок'**
  String get profileShoppingTitle;

  /// Заголовок-overline экрана 19 «Список покупок»
  ///
  /// In ru, this message translates to:
  /// **'Список покупок'**
  String get shoppingTitle;

  /// Серифный заголовок экрана 19: счётчик «N позиций · M куплено»
  ///
  /// In ru, this message translates to:
  /// **'{total, plural, =0{Список пуст} one{{total} позиция · {bought} куплено} few{{total} позиции · {bought} куплено} many{{total} позиций · {bought} куплено} other{{total} позиций · {bought} куплено}}'**
  String shoppingHeroSummary(int total, int bought);

  /// Кнопка/строка добавления новой позиции в список покупок (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Добавить позицию'**
  String get shoppingAddItem;

  /// Overline в шите добавления позиции (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Список покупок'**
  String get shoppingAddSheetOverline;

  /// Заголовок шита добавления позиции (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Новая позиция'**
  String get shoppingAddSheetTitle;

  /// Метка поля ввода названия позиции (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Что купить'**
  String get shoppingAddSheetLabel;

  /// Плейсхолдер поля ввода названия позиции (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Например, грунт для суккулентов'**
  String get shoppingAddSheetHint;

  /// Кнопка подтверждения добавления позиции (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get shoppingAddSheetSubmit;

  /// Semantics/тултип кнопки удаления позиции из списка покупок (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Удалить позицию'**
  String get shoppingItemDelete;

  /// Semantics-метка чекбокса «куплено» у позиции (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Отметить купленным'**
  String get shoppingItemToggle;

  /// Снэкбар после удаления позиции (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Позиция удалена'**
  String get shoppingItemDeleted;

  /// Лид серифного заголовка пустого списка покупок (экран 19) перед акцентным словом
  ///
  /// In ru, this message translates to:
  /// **'Список '**
  String get shoppingEmptyTitleLead;

  /// Акцентная часть заголовка пустого списка покупок (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'пуст'**
  String get shoppingEmptyTitleAccent;

  /// Подзаголовок пустого списка покупок (экран 19)
  ///
  /// In ru, this message translates to:
  /// **'Здесь будут вещи для твоих растений — грунт, горшки, удобрения. Добавь первую позицию.'**
  String get shoppingEmptyMessage;

  /// Кнопка повтора загрузки диагноза (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get diagnosisRetry;

  /// Бейдж-предупреждение в hero-секции когда есть проблемы (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'⚠ Что‑то не так'**
  String get diagnosisBadgeWarning;

  /// Заголовок пустого состояния «Всё в порядке» (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'Всё в порядке'**
  String get diagnosisHealthyTitle;

  /// Подпись к пустому состоянию «Всё в порядке» (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'Растение здорово — проблем не обнаружено'**
  String get diagnosisHealthyMessage;

  /// Заголовок секции проблем на экране «Диагноз растения» (15)
  ///
  /// In ru, this message translates to:
  /// **'Проблемы'**
  String get diagnosisTitleIssues;

  /// Бейдж серьёзности проблемы: критично (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'Критично'**
  String get diagnosisSeverityHigh;

  /// Бейдж серьёзности проблемы: умеренно (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'Умеренно'**
  String get diagnosisSeverityMedium;

  /// Бейдж серьёзности проблемы: незначительно (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'Незначительно'**
  String get diagnosisSeverityLow;

  /// Бейдж серьёзности проблемы: неизвестно / forward-compat (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'—'**
  String get diagnosisSeverityUnknown;

  /// Заголовок секции рекомендаций на экране «Диагноз растения» (15)
  ///
  /// In ru, this message translates to:
  /// **'Рекомендации'**
  String get diagnosisTitleRecommendations;

  /// Сообщение об ошибке загрузки диагноза (экран 15)
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить диагноз'**
  String get diagnosisErrorMessage;

  /// Серифный заголовок экрана 30 «Пустой поиск каталога» с запросом пользователя
  ///
  /// In ru, this message translates to:
  /// **'Не нашли «{query}»'**
  String catalogSearchEmptyTitle(String query);

  /// Подпись под заголовком экрана 30 «Пустой поиск каталога»
  ///
  /// In ru, this message translates to:
  /// **'Возможно, опечатка. Попробуй иначе или загляни в популярное.'**
  String get catalogSearchEmptyMessage;

  /// Надпись над чипами популярных видов на экране 30
  ///
  /// In ru, this message translates to:
  /// **'Может, ты искал(а)'**
  String get catalogSuggestionsTitle;

  /// Серифный заголовок CTA-карточки «Нет в каталоге» на экране 30
  ///
  /// In ru, this message translates to:
  /// **'Нет в каталоге?'**
  String get catalogNotInCatalogTitle;

  /// Подпись CTA-карточки «Нет в каталоге» на экране 30
  ///
  /// In ru, this message translates to:
  /// **'Заведи растение вручную — расписание настроишь сам(а).'**
  String get catalogNotInCatalogHint;

  /// Кнопка CTA-карточки «Нет в каталоге» на экране 30: добавить растение вручную
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get catalogNotInCatalogAdd;

  /// Заголовок пункта меню «Язык» в профиле (экран 13)
  ///
  /// In ru, this message translates to:
  /// **'Язык / Language'**
  String get languageScreenTitle;

  /// Tooltip кнопки «назад» на экране 38 «Язык приложения»
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get languageBack;

  /// Первая (незакрашенная) часть заголовка экрана 38 — «Язык »
  ///
  /// In ru, this message translates to:
  /// **'Язык '**
  String get languageScreenTitleLead;

  /// Вторая (primary italic) часть заголовка экрана 38 — «приложения»
  ///
  /// In ru, this message translates to:
  /// **'приложения'**
  String get languageScreenTitleAccent;

  /// Подзаголовок под заголовком на экране 38
  ///
  /// In ru, this message translates to:
  /// **'Реплики растений тоже переведём — характер сохранится'**
  String get languageScreenSubtitle;

  /// Подсказка внизу экрана 38 о форматировании даты/времени
  ///
  /// In ru, this message translates to:
  /// **'Дату и время форматируем по выбранному языку.'**
  String get languageScreenHint;

  /// Заголовок экрана редактирования растения (шапка и кнопка «назад»)
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get editPlantTitle;

  /// Кнопка сохранения изменений на экране редактирования растения
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get editPlantSave;

  /// Метка поля ввода имени растения на экране редактирования
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get editPlantNameLabel;

  /// Метка необязательного поля заметок на экране редактирования
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get editPlantNotesLabel;

  /// Метка пикера комнаты (локации) на экране редактирования
  ///
  /// In ru, this message translates to:
  /// **'Комната'**
  String get editPlantLocationLabel;

  /// Метка поля выбора вида растения на экране редактирования
  ///
  /// In ru, this message translates to:
  /// **'Вид'**
  String get editPlantSpeciesLabel;

  /// Плейсхолдер для незаполненного поля вида на экране редактирования
  ///
  /// In ru, this message translates to:
  /// **'Без вида'**
  String get editPlantSpeciesNone;

  /// Снэкбар-подтверждение после успешного сохранения изменений растения
  ///
  /// In ru, this message translates to:
  /// **'Изменения сохранены'**
  String get editPlantSuccessSnackbar;

  /// Заголовок шага 5 мастера: дата приобретения растения
  ///
  /// In ru, this message translates to:
  /// **'Когда завели {name}?'**
  String addPlantStepAcquiredTitle(String name);

  /// Chip быстрого выбора даты: сегодня
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get addPlantStepAcquiredToday;

  /// Chip быстрого выбора даты: примерно 3 дня назад
  ///
  /// In ru, this message translates to:
  /// **'На этой неделе'**
  String get addPlantStepAcquiredThisWeek;

  /// Chip быстрого выбора даты: 30 дней назад
  ///
  /// In ru, this message translates to:
  /// **'Месяц назад'**
  String get addPlantStepAcquiredMonthAgo;

  /// Chip быстрого выбора даты: открывает DatePicker для произвольной прошлой даты
  ///
  /// In ru, this message translates to:
  /// **'Раньше'**
  String get addPlantStepAcquiredEarlier;

  /// Кнопка пропуска шага даты приобретения (и шага акклиматизации)
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get addPlantStepAcquiredSkip;

  /// Заголовок шага 6 мастера: является ли растение новым (акклиматизация)
  ///
  /// In ru, this message translates to:
  /// **'Растение новое?'**
  String get addPlantStepAcclimationTitle;

  /// Вариант ответа: растение новое → включить акклиматизацию
  ///
  /// In ru, this message translates to:
  /// **'Да, только купил'**
  String get addPlantStepAcclimationYes;

  /// Вариант ответа: растение уже адаптировано
  ///
  /// In ru, this message translates to:
  /// **'Нет, уже адаптировалось'**
  String get addPlantStepAcclimationNo;

  /// Подсказка под кнопками шага акклиматизации: объяснение периода акклиматизации
  ///
  /// In ru, this message translates to:
  /// **'Во время акклиматизации (21 день) мы будем задавать вопросы о состоянии растения.'**
  String get addPlantStepAcclimationHint;

  /// Строка на карточке растения: дата приобретения и возраст
  ///
  /// In ru, this message translates to:
  /// **'С тобой с {date} ({age})'**
  String plantCardAcquiredSince(String date, String age);

  /// Бейдж на карточке растения: растение в периоде акклиматизации
  ///
  /// In ru, this message translates to:
  /// **'Акклиматизация'**
  String get plantCardAcclimationBadge;

  /// Оверлайн шапки экрана 35
  ///
  /// In ru, this message translates to:
  /// **'Сезонные интервалы'**
  String get seasonalOverline;

  /// Кнопка «назад» экрана 35
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get seasonalBack;

  /// Серифный заголовок 35, обычная часть перед акцентом
  ///
  /// In ru, this message translates to:
  /// **'Уход '**
  String get seasonalTitleLead;

  /// Серифный заголовок 35, акцентная курсивная часть
  ///
  /// In ru, this message translates to:
  /// **'по сезону'**
  String get seasonalTitleAccent;

  /// Подзаголовок экрана 35
  ///
  /// In ru, this message translates to:
  /// **'Летом растения пьют чаще, зимой почти спят. Подстраиваем расписание автоматически.'**
  String get seasonalSubtitle;

  /// Заголовок тумблера авто-подстройки на экране 35
  ///
  /// In ru, this message translates to:
  /// **'Автоматически по сезону'**
  String get seasonalToggleTitle;

  /// Подпись тумблера авто-подстройки на экране 35
  ///
  /// In ru, this message translates to:
  /// **'Менять частоту полива и опрыскивания'**
  String get seasonalToggleSubtitle;

  /// Пояснение режима MULTIPLIER на экране 35
  ///
  /// In ru, this message translates to:
  /// **'Множитель к базовому интервалу'**
  String get seasonalModeMultiplier;

  /// Пояснение режима FIXED на экране 35
  ///
  /// In ru, this message translates to:
  /// **'Фиксированные интервалы на сезон'**
  String get seasonalModeFixed;

  /// Оверлайн карточки текущего сезона на экране 35
  ///
  /// In ru, this message translates to:
  /// **'Сейчас · {season}'**
  String seasonalNowLabel(String season);

  /// Название сезона «весна» с эмодзи (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'весна 🌱'**
  String get seasonalSpring;

  /// Название сезона «лето» с эмодзи (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'лето ☀️'**
  String get seasonalSummer;

  /// Название сезона «осень» с эмодзи (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'осень 🍂'**
  String get seasonalAutumn;

  /// Название сезона «зима» с эмодзи (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'зима ❄️'**
  String get seasonalWinter;

  /// Заголовок карточки текущего сезона, когда авто-подстройка включена (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'Подстраиваем под сезон'**
  String get seasonalCardOnTitle;

  /// Текст карточки сезона: весна, авто-подстройка включена
  ///
  /// In ru, this message translates to:
  /// **'Весной растения просыпаются — поливаем чуть чаще.'**
  String get seasonalCardOnSpring;

  /// Текст карточки сезона: лето, авто-подстройка включена
  ///
  /// In ru, this message translates to:
  /// **'Летом растения пьют активнее — поливаем чаще.'**
  String get seasonalCardOnSummer;

  /// Текст карточки сезона: осень, авто-подстройка включена
  ///
  /// In ru, this message translates to:
  /// **'Осенью рост замедляется — поливаем реже.'**
  String get seasonalCardOnAutumn;

  /// Текст карточки сезона: зима, авто-подстройка включена
  ///
  /// In ru, this message translates to:
  /// **'Зимой растения отдыхают — поливаем заметно реже.'**
  String get seasonalCardOnWinter;

  /// Заголовок карточки, когда авто-подстройка выключена (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'Авто-подстройка выключена'**
  String get seasonalCardOffTitle;

  /// Текст карточки, когда авто-подстройка выключена (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'Расписание не меняется по сезонам. Включите тумблер, чтобы летом поливать чаще, а зимой реже.'**
  String get seasonalCardOffBody;

  /// Заголовок секции со столбчатой диаграммой сезонов (экран 35)
  ///
  /// In ru, this message translates to:
  /// **'Частота полива по году'**
  String get seasonalSeasonsSection;

  /// Относительная частота полива весной (диаграмма экрана 35)
  ///
  /// In ru, this message translates to:
  /// **'+10%'**
  String get seasonalSpringFactor;

  /// Относительная частота полива летом (диаграмма экрана 35)
  ///
  /// In ru, this message translates to:
  /// **'+20%'**
  String get seasonalSummerFactor;

  /// Относительная частота полива осенью (диаграмма экрана 35)
  ///
  /// In ru, this message translates to:
  /// **'базовый'**
  String get seasonalAutumnFactor;

  /// Относительная частота полива зимой (диаграмма экрана 35)
  ///
  /// In ru, this message translates to:
  /// **'−30%'**
  String get seasonalWinterFactor;

  /// Декоративная цитата внизу экрана 35
  ///
  /// In ru, this message translates to:
  /// **'«Зимой не заливай меня — я отдыхаю и пью совсем мало.»'**
  String get seasonalQuote;

  /// Сноска про per-plant интервалы на экране 35
  ///
  /// In ru, this message translates to:
  /// **'Точные интервалы по сезонам считаются для каждого растения индивидуально на основе его расписания ухода.'**
  String get seasonalNote;

  /// Тип события журнала растения: пересадка (TRANSPLANT)
  ///
  /// In ru, this message translates to:
  /// **'Пересадка'**
  String get plantEventTypeTransplant;

  /// Тип события журнала растения: замена грунта (SOIL_CHANGE)
  ///
  /// In ru, this message translates to:
  /// **'Замена грунта'**
  String get plantEventTypeSoilChange;

  /// Тип события журнала растения: обрезка (PRUNING)
  ///
  /// In ru, this message translates to:
  /// **'Обрезка'**
  String get plantEventTypePruning;

  /// Тип события журнала растения: обработка от вредителей (PEST_TREATMENT)
  ///
  /// In ru, this message translates to:
  /// **'Обработка от вредителей'**
  String get plantEventTypePestTreatment;

  /// Заголовок экрана журнала событий растения
  ///
  /// In ru, this message translates to:
  /// **'Журнал событий'**
  String get plantEventsScreenTitle;

  /// Кнопка открытия sheet добавления события (журнал событий)
  ///
  /// In ru, this message translates to:
  /// **'Добавить событие'**
  String get addPlantEventButton;

  /// Ссылка-вход на полный журнал событий с карточки растения (02)
  ///
  /// In ru, this message translates to:
  /// **'Все события'**
  String get plantEventsViewAll;

  /// Заголовок секции журнала событий в карточке растения (02)
  ///
  /// In ru, this message translates to:
  /// **'Журнал событий'**
  String get plantEventsSectionTitle;

  /// Заголовок пустого состояния журнала событий
  ///
  /// In ru, this message translates to:
  /// **'Событий пока нет'**
  String get plantEventsEmptyTitle;

  /// Подпись пустого состояния журнала событий
  ///
  /// In ru, this message translates to:
  /// **'Отмечайте пересадки, обрезку и другие важные моменты — так проще вспомнить историю растения.'**
  String get plantEventsEmptyHint;

  /// CTA в пустом состоянии журнала событий
  ///
  /// In ru, this message translates to:
  /// **'Добавить первое событие'**
  String get plantEventsEmptyCta;

  /// Заголовок sheet добавления события растения
  ///
  /// In ru, this message translates to:
  /// **'Что произошло?'**
  String get addPlantEventSheetTitle;

  /// Overline (надзаголовок) sheet добавления события растения
  ///
  /// In ru, this message translates to:
  /// **'Журнал событий'**
  String get addPlantEventSheetOverline;

  /// Снэкбар-подтверждение после записи события растения
  ///
  /// In ru, this message translates to:
  /// **'Событие записано'**
  String get plantEventAddedSnackbar;

  /// Тост при дедупе (409) записи события растения
  ///
  /// In ru, this message translates to:
  /// **'Событие уже записано'**
  String get plantEventDuplicateSnackbar;

  /// Кнопка подзагрузки следующей страницы журнала событий
  ///
  /// In ru, this message translates to:
  /// **'Показать ещё'**
  String get plantEventsLoadMore;

  /// Строка ошибки подзагрузки страницы журнала событий
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить ещё'**
  String get plantEventsLoadMoreError;

  /// Заголовок экрана справочника болезней и вредителей (issue #68)
  ///
  /// In ru, this message translates to:
  /// **'Болезни и вредители'**
  String get diseaseCatalogTitle;

  /// Подсказка поля поиска в справочнике болезней
  ///
  /// In ru, this message translates to:
  /// **'Поиск по названию или симптому'**
  String get diseaseCatalogSearchHint;

  /// Метка кнопки очистки поля поиска в справочнике болезней
  ///
  /// In ru, this message translates to:
  /// **'Очистить поиск'**
  String get diseaseCatalogSearchClear;

  /// Пустое состояние списка справочника болезней (нет результатов)
  ///
  /// In ru, this message translates to:
  /// **'Болезни не найдены'**
  String get diseaseCatalogEmpty;

  /// Заголовок секции «Симптомы» на карточке болезни
  ///
  /// In ru, this message translates to:
  /// **'Симптомы'**
  String get diseaseDetailSymptomsTitle;

  /// Заголовок секции «Лечение» на карточке болезни
  ///
  /// In ru, this message translates to:
  /// **'Лечение'**
  String get diseaseDetailTreatmentTitle;

  /// Заголовок секции «Профилактика» на карточке болезни
  ///
  /// In ru, this message translates to:
  /// **'Профилактика'**
  String get diseaseDetailPreventionTitle;

  /// Пункт меню «ещё» на карточке растения — открыть редактирование
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get plantCardMenuEdit;

  /// Пункт меню «ещё» на карточке растения — отправить растение в архив
  ///
  /// In ru, this message translates to:
  /// **'В архив'**
  String get archivePlantMenuLabel;

  /// Заголовок диалога подтверждения архивации растения
  ///
  /// In ru, this message translates to:
  /// **'Отправить в архив?'**
  String get archivePlantConfirmTitle;

  /// Текст диалога подтверждения архивации растения
  ///
  /// In ru, this message translates to:
  /// **'Растение переместится в архив. Вернуть его в список можно будет из экрана «Архив».'**
  String get archivePlantConfirmBody;

  /// Кнопка подтверждения архивации в диалоге
  ///
  /// In ru, this message translates to:
  /// **'Архивировать'**
  String get archivePlantConfirmAction;

  /// Снэкбар-подтверждение успешной архивации растения
  ///
  /// In ru, this message translates to:
  /// **'Растение перемещено в архив'**
  String get archivePlantSuccess;

  /// Универсальная кнопка отмены действия в диалогах
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// Заголовок строки перехода на экран совместного ухода (экран 26) в профиле
  ///
  /// In ru, this message translates to:
  /// **'Совместный уход'**
  String get profileSharingTitle;

  /// Семантический ярлык кнопки «назад» на экране совместного ухода
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get sharingBack;

  /// Надзаголовок (overline) экрана совместного ухода
  ///
  /// In ru, this message translates to:
  /// **'Совместный уход'**
  String get sharingOverline;

  /// Серифный заголовок экрана совместного ухода
  ///
  /// In ru, this message translates to:
  /// **'Ухаживайте вместе'**
  String get sharingTitle;

  /// Подзаголовок-описание под заголовком экрана совместного ухода
  ///
  /// In ru, this message translates to:
  /// **'Близкий человек сможет отмечать полив, пока тебя нет'**
  String get sharingSubtitle;

  /// Заголовок секции со списком текущих соухаживающих
  ///
  /// In ru, this message translates to:
  /// **'Помогают сейчас'**
  String get sharingCurrentLabel;

  /// Текст статуса приглашения в строке соухаживающего: ожидает принятия
  ///
  /// In ru, this message translates to:
  /// **'приглашение отправлено'**
  String get sharingStatusPending;

  /// Текст статуса принятого приглашения в строке соухаживающего
  ///
  /// In ru, this message translates to:
  /// **'помогает с уходом'**
  String get sharingStatusAccepted;

  /// Бейдж статуса PENDING в строке соухаживающего
  ///
  /// In ru, this message translates to:
  /// **'ОЖИДАЕТ'**
  String get sharingBadgePending;

  /// Бейдж статуса ACCEPTED в строке соухаживающего
  ///
  /// In ru, this message translates to:
  /// **'ПРИНЯТО'**
  String get sharingBadgeAccepted;

  /// Количество растений, доверенных соухаживающему
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, =0{нет растений} one{{count} растение} few{{count} растения} many{{count} растений} other{{count} растения}}'**
  String sharingMemberPlants(int count);

  /// Заголовок пустого состояния списка соухаживающих
  ///
  /// In ru, this message translates to:
  /// **'Пока никого нет'**
  String get sharingEmptyTitle;

  /// Подсказка пустого состояния списка соухаживающих
  ///
  /// In ru, this message translates to:
  /// **'Пригласите близкого человека помочь с уходом за вашими растениями'**
  String get sharingEmptyHint;

  /// Заголовок секции приглашения нового соухаживающего
  ///
  /// In ru, this message translates to:
  /// **'Пригласить'**
  String get sharingInviteLabel;

  /// Плейсхолдер поля ввода контакта приглашаемого
  ///
  /// In ru, this message translates to:
  /// **'@username или телефон'**
  String get sharingContactHint;

  /// Inline-ошибка пустого поля контакта
  ///
  /// In ru, this message translates to:
  /// **'Введите контакт приглашаемого'**
  String get sharingContactError;

  /// Заголовок секции выбора растений для приглашения
  ///
  /// In ru, this message translates to:
  /// **'Какие растения доверить'**
  String get sharingSelectPlantsLabel;

  /// Счётчик выбранных растений в секции выбора
  ///
  /// In ru, this message translates to:
  /// **'{count} выбрано'**
  String sharingSelectedCount(int count);

  /// Inline-ошибка, когда не выбрано ни одного растения
  ///
  /// In ru, this message translates to:
  /// **'Выберите хотя бы одно растение'**
  String get sharingNoPlantsError;

  /// Сообщение, когда у пользователя нет растений для выбора в приглашении
  ///
  /// In ru, this message translates to:
  /// **'У вас пока нет растений, которыми можно поделиться'**
  String get sharingNoPlantsAvailable;

  /// Сообщение об ошибке загрузки списка растений в секции выбора
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить растения'**
  String get sharingPlantsLoadError;

  /// Заголовок переключателя права отмечать уход
  ///
  /// In ru, this message translates to:
  /// **'Может отмечать уход'**
  String get sharingPermissionTitle;

  /// Подсказка под переключателем права отмечать уход
  ///
  /// In ru, this message translates to:
  /// **'Иначе — только смотреть расписание'**
  String get sharingPermissionHint;

  /// Кнопка отправки приглашения соухаживающего
  ///
  /// In ru, this message translates to:
  /// **'Отправить приглашение'**
  String get sharingSubmit;

  /// Снэкбар-подтверждение успешной отправки приглашения
  ///
  /// In ru, this message translates to:
  /// **'Приглашение отправлено'**
  String get sharingInviteSuccess;

  /// Тултип кнопки «назад» на экране 25 «Режим отпуска»
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get vacationBack;

  /// Оверлайн-заголовок в шапке экрана 25
  ///
  /// In ru, this message translates to:
  /// **'Режим отпуска'**
  String get vacationOverline;

  /// Первая часть серифного заголовка экрана 25
  ///
  /// In ru, this message translates to:
  /// **'Уезжаешь? '**
  String get vacationTitleLead;

  /// Акцентная (курсив) часть серифного заголовка экрана 25
  ///
  /// In ru, this message translates to:
  /// **'Сад подождёт'**
  String get vacationTitleAccent;

  /// Подзаголовок экрана 25
  ///
  /// In ru, this message translates to:
  /// **'Поставим напоминания на паузу, пока тебя нет'**
  String get vacationSubtitle;

  /// Заголовок баннера активного отпуска на экране 25
  ///
  /// In ru, this message translates to:
  /// **'Отпуск включён'**
  String get vacationActiveBannerTitle;

  /// Подпись баннера активного отпуска — до какой даты пауза
  ///
  /// In ru, this message translates to:
  /// **'Напоминания на паузе до {date}'**
  String vacationActiveBannerUntil(String date);

  /// Подпись баннера активного отпуска, когда дата окончания неизвестна
  ///
  /// In ru, this message translates to:
  /// **'Напоминания на паузе'**
  String get vacationActiveBannerNoDate;

  /// Подпись карточки даты начала отпуска (экран 25)
  ///
  /// In ru, this message translates to:
  /// **'С'**
  String get vacationFromLabel;

  /// Подпись карточки даты конца отпуска (экран 25)
  ///
  /// In ru, this message translates to:
  /// **'По'**
  String get vacationToLabel;

  /// Длительность выбранного отпуска в днях (экран 25)
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день без забот} few{{count} дня без забот} many{{count} дней без забот} other{{count} дней без забот}}'**
  String vacationDaysCount(int count);

  /// Подсказка-ошибка, если выбранный диапазон превышает лимит backend
  ///
  /// In ru, this message translates to:
  /// **'Отпуск не может быть дольше {max} дней'**
  String vacationRangeTooLong(int max);

  /// Заголовок секции «что произойдёт» на экране 25
  ///
  /// In ru, this message translates to:
  /// **'Что будет с садом'**
  String get vacationWhatHappensSection;

  /// Пункт «пуши приостановлены» в секции «что будет с садом»
  ///
  /// In ru, this message translates to:
  /// **'Напоминания на паузе'**
  String get vacationPausePushTitle;

  /// Описание пункта «пуши приостановлены»
  ///
  /// In ru, this message translates to:
  /// **'Не будем напоминать об уходе, пока ты в отпуске'**
  String get vacationPausePushSubtitle;

  /// Пункт о поведении дедлайнов в секции «что будет с садом»
  ///
  /// In ru, this message translates to:
  /// **'Дедлайны не сдвигаются'**
  String get vacationDeadlinesTitle;

  /// Описание поведения дедлайнов во время отпуска
  ///
  /// In ru, this message translates to:
  /// **'Просроченные задачи соберём в сводку «С возвращением!»'**
  String get vacationDeadlinesSubtitle;

  /// Кнопка включения режима отпуска (экран 25)
  ///
  /// In ru, this message translates to:
  /// **'Включить отпуск'**
  String get vacationEnableCta;

  /// Кнопка досрочного завершения режима отпуска (экран 25)
  ///
  /// In ru, this message translates to:
  /// **'Завершить отпуск'**
  String get vacationDisableCta;

  /// Снэкбар-подтверждение включения отпуска
  ///
  /// In ru, this message translates to:
  /// **'Режим отпуска включён'**
  String get vacationEnabledSnack;

  /// Снэкбар-подтверждение выключения отпуска
  ///
  /// In ru, this message translates to:
  /// **'Режим отпуска выключен'**
  String get vacationDisabledSnack;

  /// Строка «Удалить аккаунт» в секции настроек профиля
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get profileDeleteAccount;

  /// Заголовок экрана удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Удаление аккаунта'**
  String get deleteAccountScreenTitle;

  /// Заголовок предупреждения о необратимости удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Это действие нельзя отменить'**
  String get deleteAccountWarningTitle;

  /// Подробное описание того, что будет удалено при удалении аккаунта (требование App Store)
  ///
  /// In ru, this message translates to:
  /// **'Будут удалены все ваши данные: растения и их история ухода, расписания, список покупок, настройки и токены сессий. Telegram-привязка также удаляется — при следующем /start создаётся новый аккаунт. Восстановление невозможно.'**
  String get deleteAccountWarningBody;

  /// Метка чекбокса подтверждения удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Я понимаю, что данные будут удалены безвозвратно'**
  String get deleteAccountConfirmLabel;

  /// Кнопка подтверждения удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get deleteAccountCta;

  /// Заголовок финального диалога подтверждения удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт?'**
  String get deleteAccountDialogTitle;

  /// Тело финального диалога подтверждения удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт и все данные будут удалены немедленно. Это действие необратимо.'**
  String get deleteAccountDialogBody;

  /// Кнопка отмены в диалоге удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get deleteAccountDialogCancel;

  /// Кнопка подтверждения удаления в диалоге удаления аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get deleteAccountDialogConfirm;

  /// Снэкбар ошибки при удалении аккаунта
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить аккаунт. Попробуйте ещё раз.'**
  String get deleteAccountErrorSnack;
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
