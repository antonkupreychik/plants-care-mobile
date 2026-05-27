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
