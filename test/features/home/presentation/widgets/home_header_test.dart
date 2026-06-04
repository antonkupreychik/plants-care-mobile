import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:plantcare_mobile/features/notifications/presentation/notifications_providers.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Widget _wrap({
  bool isEmptyGarden = false,
  VoidCallback? onProfile,
  VoidCallback? onComingSoon,
  VoidCallback? onNotifications,
}) =>
    ProviderScope(
      overrides: [unreadCountProvider.overrideWithValue(0)],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: Scaffold(
          body: HomeHeader(
            now: DateTime(2026, 6, 1),
            onComingSoon: onComingSoon ?? () {},
            onNotifications: onNotifications ?? () {},
            onProfile: onProfile ?? () {},
            isEmptyGarden: isEmptyGarden,
          ),
        ),
      ),
    );

void main() {
  group('HomeHeader — полная шапка (сад не пустой)', () {
    testWidgets('should_show_search_and_bell_when_garden_not_empty',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsNothing);
    });
  });

  group('HomeHeader — упрощённая шапка (пустой сад)', () {
    testWidgets('should_show_only_profile_icon_when_empty_garden',
        (tester) async {
      await tester.pumpWidget(_wrap(isEmptyGarden: true));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsNothing);
      expect(find.byIcon(Icons.notifications_none_rounded), findsNothing);
    });

    testWidgets('should_have_min_44dp_tap_zone_for_profile_icon',
        (tester) async {
      await tester.pumpWidget(_wrap(isEmptyGarden: true));
      await tester.pumpAndSettle();

      // Кнопка профиля реализована через SizedBox(width: 44, height: 44) — проверяем.
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      final has44dp = sizedBoxes.any(
        (box) => box.width != null && box.width! >= 44 && box.height != null && box.height! >= 44,
      );
      expect(has44dp, isTrue);
    });

    testWidgets('should_have_semantics_on_profile_icon', (tester) async {
      await tester.pumpWidget(_wrap(isEmptyGarden: true));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(HomeHeader)));
      // Иконка профиля обёрнута в Semantics(button: true, label: ...).
      final semantics = tester.widgetList<Semantics>(find.byType(Semantics));
      final profileButton = semantics.where(
        (s) => s.properties.button == true && s.properties.label == l10n.homeProfileTooltip,
      );
      expect(profileButton, isNotEmpty);
    });

    testWidgets('should_invoke_onProfile_when_profile_icon_tapped',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        isEmptyGarden: true,
        onProfile: () => tapped = true,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.person_outline_rounded));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
