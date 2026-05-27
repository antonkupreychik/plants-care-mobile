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
  String get appTitle => 'PlantCate';

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
}
