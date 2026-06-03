// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

import 'package:plantcare_mobile/features/home/presentation/widgets/plant_card.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_card.dart';
import 'package:plantcare_mobile/main_dev.dart' as app;

/// Design-check integration test.
///
/// Обходит все реализованные экраны приложения, делает скриншот каждого.
/// Скриншоты забирает драйвер (test_driver/integration_test.dart) и сохраняет
/// в screenshots/captured/ на хосте.
///
/// Запуск (iOS-симулятор должен быть запущен):
///   ./scripts/design_check.sh
///
/// Или вручную:
///   flutter drive \
///     --driver=test_driver/integration_test.dart \
///     --target=integration_test/design_check_test.dart \
///     --dart-define=API_URL=... \
///     --dart-define=ACCESS_TOKEN=... \
///     --dart-define=REFRESH_TOKEN=...
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'design_check',
    (WidgetTester tester) async {
      app.main();

      // Ждём bootstrap: auth + initialLocation (/home) + первый fetch
      await _wait(tester, 6);

      // ── helpers ──────────────────────────────────────────────────

      /// Возвращает BuildContext любого Scaffold'а в дереве.
      BuildContext ctx() =>
          tester.element(find.byType(Scaffold).first);

      /// Навигация через GoRouter + ожидание загрузки экрана.
      Future<void> go(String route, {int waitSec = 4}) async {
        try {
          GoRouter.of(ctx()).go(route);
        } catch (e) {
          print('[design_check] go($route) error: $e');
        }
        await _wait(tester, waitSec);
      }

      /// Скриншот текущего экрана.
      Future<void> snap(String name) async {
        await tester.pump(const Duration(milliseconds: 300));
        print('[design_check] snap → $name');
        await binding.takeScreenshot(name);
      }

      // Android требует конвертации surface перед первым скриншотом
      await binding.convertFlutterSurfaceToImage();
      await tester.pump(const Duration(milliseconds: 300));

      // ── Статические маршруты ─────────────────────────────────────

      // 01 Главная — Мой сад
      await go('/home');
      await snap('01-home');

      // 03 Сегодня
      await go('/home/today');
      await snap('03-today');

      // 24 Лента уведомлений
      await go('/home/notifications');
      await snap('24-notifications-inbox');

      // 04a Мастер добавления — шаг 1
      await go('/home/add');
      await snap('04a-add-step1');

      // 11 График недели
      await go('/schedule');
      await snap('11-week-calendar');

      // 12 Каталог видов
      await go('/catalog');
      await snap('12-catalog');

      // 13 Профиль
      await go('/profile');
      await snap('13-profile');

      // 14 Месячный отчёт
      await go('/profile/report');
      await snap('14-monthly-report');

      // 17 Архив
      await go('/profile/archive');
      await snap('17-archive');

      // 19 Список покупок
      await go('/profile/shopping');
      await snap('19-shopping');

      // 23 Тихие часы
      await go('/profile/quiet-hours');
      await snap('23-quiet-hours');

      // 34 Дома и комнаты
      await go('/profile/rooms');
      await snap('34-rooms-homes');

      // 37 Выбор таймзоны
      await go('/profile/timezone');
      await snap('37-timezone');

      // 38 Язык приложения
      await go('/profile/language');
      await snap('38-language');

      // 33 Успех первого ухода (plantId=1 fallback — может быть error state)
      await go('/home/care-success/1?kind=water');
      await snap('33-first-care-success');

      // ── Динамические маршруты через UI ───────────────────────────

      // 02 Карточка растения — тапаем первый PlantCard на главной
      await go('/home', waitSec: 5);
      final plantCards = find.byType(PlantCard);
      if (plantCards.evaluate().isNotEmpty) {
        await tester.tap(plantCards.first);
        await _wait(tester, 4);
        await snap('02-plant-card');

        // Пробуем сохранить текущий путь для построения sub-routes
        String? plantId;
        try {
          final uri = GoRouter.of(ctx()).routeInformationProvider.value.uri;
          final match = RegExp(r'/home/plants/(\d+)').firstMatch(uri.toString());
          plantId = match?.group(1);
        } catch (_) {}

        if (plantId != null) {
          // 21 История ухода
          await go('/home/plants/$plantId/history');
          await snap('21-care-history');

          // 22 Редактирование расписания
          await go('/home/plants/$plantId/schedule');
          await snap('22-edit-schedule');

          // 15 Диагноз (экран присутствует, бэк заблокирован — снимаем UI)
          await go('/home/plants/$plantId/diagnosis');
          await snap('15-diagnosis');
        } else {
          // Fallback: ищем кнопки в UI
          await _trySnapSubScreens(tester, binding, snap);
        }
      } else {
        print('[design_check] PlantCard not found — пропускаем 02, 21, 22, 15');
      }

      // 20 Деталь вида — тапаем первый SpeciesCard в каталоге
      await go('/catalog', waitSec: 5);
      final speciesCards = find.byType(SpeciesCard);
      if (speciesCards.evaluate().isNotEmpty) {
        await tester.tap(speciesCards.first);
        await _wait(tester, 4);
        await snap('20-species-detail');
      } else {
        print('[design_check] SpeciesCard not found — пропускаем 20');
      }
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}

/// Несколько коротких pump'ов вместо pumpAndSettle: безопаснее при
/// бесконечных анимациях (shimmer, ticker, etc.) и сетевых запросах.
Future<void> _wait(WidgetTester tester, int seconds) async {
  for (int i = 0; i < seconds * 2; i++) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

/// Fallback-навигация к экранам карточки растения через текстовые кнопки UI,
/// используется когда plantId не удалось извлечь из маршрута.
Future<void> _trySnapSubScreens(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
  Future<void> Function(String) snap,
) async {
  // История ухода — ищем кнопку «Все» / «All»
  for (final label in ['Все', 'All', 'Всё']) {
    final btn = find.textContaining(label);
    if (btn.evaluate().isNotEmpty) {
      await tester.tap(btn.first);
      await _wait(tester, 3);
      await snap('21-care-history');
      break;
    }
  }
}
