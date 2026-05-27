// Дефолтная точка входа для инструментов (`flutter run` / `flutter build`
// без `-t`). Реальные entrypoint'ы — `main_dev.dart` / `main_prod.dart`
// (MADR-010). По умолчанию запускаем dev-flavor.
import 'bootstrap.dart';
import 'core/env/app_config.dart';

void main() => bootstrap(Flavor.dev);
