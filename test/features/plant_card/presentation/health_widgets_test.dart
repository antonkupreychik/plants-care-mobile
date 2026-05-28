import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/plant_card/domain/health_zone.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_health.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_providers.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/widgets/health_badge.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/widgets/health_ring.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

const _plantId = 7;

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

typedef _HealthFn = Future<PlantHealth> Function();

Widget _wrap(Widget child, _HealthFn health) {
  return ProviderScope(
    overrides: [
      plantHealthProvider(_plantId).overrideWith((ref) => health()),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold)));

void main() {
  group('HealthRing', () {
    testWidgets('should_render_score_number_when_reliable', (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(plantId: _plantId),
        () async => const PlantHealth(
          score: 92,
          zone: HealthZone.green,
          insufficientData: false,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('92'), findsOneWidget);
      expect(find.text('—'), findsNothing);
      expect(find.byType(CustomPaint), findsWidgets);

      // Доступность: кольцо озвучивает score, а не молчит.
      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(HealthRing),
          matching: find.byType(Semantics),
        ),
      );
      expect(
        semantics.properties.label,
        _l10n(tester).healthSemanticScore(92),
      );
    });

    testWidgets('should_render_dash_and_no_score_when_insufficient_data',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(plantId: _plantId),
        () async => const PlantHealth(
          insufficientData: true,
          score: null,
          zone: null,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('—'), findsOneWidget);
      expect(find.text('0'), findsNothing);

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(HealthRing),
          matching: find.byType(Semantics),
        ),
      );
      expect(
        semantics.properties.label,
        _l10n(tester).healthSemanticUnknown,
      );
    });

    testWidgets('should_show_neutral_placeholder_without_number_when_loading',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(plantId: _plantId),
        _pending<PlantHealth>,
      ));
      await tester.pump();

      // Плейсхолдер загрузки: кольцо есть, но ни числа, ни «—».
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.text('—'), findsNothing);
      expect(find.textContaining(RegExp(r'\d')), findsNothing);
    });

    testWidgets('should_hide_silently_without_number_when_error',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthRing(plantId: _plantId),
        () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      // error → кольцо тихо исчезает: ни числа, ни «—», и нет рисующего painter.
      expect(find.text('—'), findsNothing);
      expect(find.textContaining(RegExp(r'\d')), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('HealthBadge', () {
    testWidgets('should_render_health_label_with_score_when_reliable',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthBadge(plantId: _plantId),
        () async => const PlantHealth(
          score: 92,
          zone: HealthZone.green,
          insufficientData: false,
        ),
      ));
      await tester.pumpAndSettle();

      expect(
        find.text(_l10n(tester).healthBadgeLabel(92)),
        findsOneWidget,
      );
      expect(find.text(_l10n(tester).healthScoreUnknown), findsNothing);
    });

    testWidgets('should_render_neutral_label_when_insufficient_data',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthBadge(plantId: _plantId),
        () async => const PlantHealth(
          insufficientData: true,
          score: null,
          zone: null,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(_l10n(tester).healthScoreUnknown), findsOneWidget);
      expect(find.text(_l10n(tester).healthBadgeLabel(0)), findsNothing);
    });

    testWidgets('should_show_skeleton_without_label_when_loading',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthBadge(plantId: _plantId),
        _pending<PlantHealth>,
      ));
      await tester.pump();

      expect(find.byType(SkeletonBox), findsOneWidget);
      expect(find.text(_l10n(tester).healthScoreUnknown), findsNothing);
    });

    testWidgets('should_hide_silently_when_error', (tester) async {
      await tester.pumpWidget(_wrap(
        const HealthBadge(plantId: _plantId),
        () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      // error → SizedBox.shrink: ни лейбла, ни «—», без исключения.
      expect(find.text(_l10n(tester).healthScoreUnknown), findsNothing);
      expect(find.byIcon(Icons.favorite_rounded), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
