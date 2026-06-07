import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_screen_layout.dart';
import 'package:plantcare_mobile/core/sdui/presentation/screen_layout_view.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/location_chips.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/plant_card.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/features/weather/domain/watering_recommendation.dart';
import 'package:plantcare_mobile/features/weather/presentation/widgets/weather_strip.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Widget _wrap(SduiScreenLayout layout) {
  return ProviderScope(
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(
        body: SingleChildScrollView(child: ScreenLayoutView(layout: layout)),
      ),
    ),
  );
}

SduiScreenLayout _layout(List<SduiBlock> blocks) =>
    SduiScreenLayout(screenId: 'home', version: 1, blocks: blocks);

void main() {
  group('ScreenLayoutView renders each block type', () {
    testWidgets('weather_strip renders WeatherStripContent', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.weatherStrip(
          available: true,
          humidityPercent: 60,
          recommendation: WateringRecommendation.doNotDefer,
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherStripContent), findsOneWidget);
    });

    testWidgets('unavailable weather_strip renders nothing', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.weatherStrip(available: false),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherStripContent), findsNothing);
    });

    testWidgets('today_summary renders TodayCard', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.todaySummary(total: 5, done: 2, remaining: 3, overdue: 1),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(TodayCard), findsOneWidget);
    });

    testWidgets('location_chips renders LocationChips', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.locationChips(
          locations: [
            GardenLocation(id: 1, name: 'Кухня', isDefault: false),
          ],
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(LocationChips), findsOneWidget);
      expect(find.text('Кухня'), findsOneWidget);
    });

    testWidgets('plant_grid renders PlantCard per item', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.plantGrid(
          plants: [
            SduiPlantGridItem(id: 1, name: 'Монстера'),
            SduiPlantGridItem(id: 2, name: 'Кактус'),
          ],
        ),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(PlantCard), findsNWidgets(2));
      expect(find.text('Монстера'), findsOneWidget);
      expect(find.text('Кактус'), findsOneWidget);
    });

    testWidgets('renders multiple blocks in order', (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.todaySummary(total: 1, done: 0, remaining: 1, overdue: 0),
        SduiBlock.plantGrid(plants: [SduiPlantGridItem(id: 1, name: 'X')]),
      ])));
      await tester.pumpAndSettle();

      expect(find.byType(TodayCard), findsOneWidget);
      expect(find.byType(PlantCard), findsOneWidget);
    });
  });

  group('graceful degradation', () {
    testWidgets('unknown block renders nothing and does not throw',
        (tester) async {
      await tester.pumpWidget(_wrap(_layout(const [
        SduiBlock.todaySummary(total: 1, done: 0, remaining: 1, overdue: 0),
        SduiBlock.unknown(),
        SduiBlock.plantGrid(plants: [SduiPlantGridItem(id: 1, name: 'X')]),
      ])));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Известные блоки отрисованы, неизвестный — пропущен (ничего не рисует).
      expect(find.byType(TodayCard), findsOneWidget);
      expect(find.byType(PlantCard), findsOneWidget);
    });
  });
}
