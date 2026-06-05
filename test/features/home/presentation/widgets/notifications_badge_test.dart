import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:plantcare_mobile/features/notifications/presentation/notifications_providers.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Рендерит шапку Home с заданным [unread] (override derived-провайдера) и
/// фиксирует, был ли тап по колокольчику.
Widget _wrap(int unread, {VoidCallback? onNotifications}) => ProviderScope(
      overrides: [unreadCountProvider.overrideWithValue(unread)],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: Scaffold(
          body: HomeHeader(
            now: DateTime(2026, 6, 1),
            onSearch: () {},
            onNotifications: onNotifications ?? () {},
            onProfile: () {},
          ),
        ),
      ),
    );

void main() {
  group('notifications badge', () {
    testWidgets('should_hide_badge_when_unreadCount_zero', (tester) async {
      await tester.pumpWidget(_wrap(0));
      await tester.pumpAndSettle();

      // Badge — число у колокольчика; при 0 числового бейджа нет.
      expect(find.text('0'), findsNothing);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    });

    testWidgets('should_show_badge_with_count_when_unreadCount_positive',
        (tester) async {
      await tester.pumpWidget(_wrap(3));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('should_show_9plus_when_count_overflows', (tester) async {
      await tester.pumpWidget(_wrap(42));
      await tester.pumpAndSettle();

      // Переполнение схлопывается в «9+».
      expect(find.text('9+'), findsOneWidget);
      expect(find.text('42'), findsNothing);
    });

    testWidgets('should_invoke_onNotifications_when_bell_tapped',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(2, onNotifications: () => tapped = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.notifications_none_rounded));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
