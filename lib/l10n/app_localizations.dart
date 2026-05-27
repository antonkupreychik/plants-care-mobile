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
  /// **'PlantCate'**
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
