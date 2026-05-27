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
}
