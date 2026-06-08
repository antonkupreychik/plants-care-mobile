import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/network/connectivity_provider.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_action.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_block.dart';
import 'package:plantcare_mobile/core/sdui/domain/sdui_screen_layout.dart';
import 'package:plantcare_mobile/core/sdui/presentation/screen_layout_provider.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/offline_state.dart';
import 'package:plantcare_mobile/features/home/presentation/home_screen.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/plant_card.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/today_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

/// Никогда не завершающийся Future → провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

final _utcNow = DateTime.utc(2026, 5, 27, 9);

typedef _Layout = Future<SduiScreenLayout> Function();

Widget _wrap({_Layout? layout}) {
  return ProviderScope(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(_utcNow)),
      connectivityProvider.overrideWith((_) => Stream.value(true)),
      homeScreenLayoutProvider.overrideWith(
        (ref) => (layout ??
            () async => const SduiScreenLayout(
                  screenId: 'home',
                  version: 1,
                  blocks: [],
                ))(),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const HomeScreen(),
    ),
  );
}

void main() {
  group('HomeScreen SDUI states', () {
    testWidgets('cold loading shows full-screen skeleton', (tester) async {
      await tester.pumpWidget(_wrap(layout: _pending<SduiScreenLayout>));
      await tester.pump();

      expect(find.byType(HomeLoadingSkeleton), findsOneWidget);
      expect(find.byType(OfflineState), findsNothing);
    });

    testWidgets('network error shows OfflineState', (tester) async {
      await tester.pumpWidget(_wrap(
        layout: () async => throw const ApiError.network(),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.byType(OfflineState), findsOneWidget);
      expect(find.text(l10n.offlineMessage), findsOneWidget);
      expect(find.byType(HomeLoadingSkeleton), findsNothing);
    });

    testWidgets('non-network error shows ErrorState inside shell',
        (tester) async {
      await tester.pumpWidget(_wrap(
        layout: () async => throw const ApiError.unknown(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.byType(OfflineState), findsNothing);
    });
  });

  group('HomeScreen SDUI data', () {
    testWidgets('renders blocks from server layout', (tester) async {
      await tester.pumpWidget(_wrap(
        layout: () async => const SduiScreenLayout(
          screenId: 'home',
          version: 1,
          blocks: [
            SduiBlock.todaySummary(total: 3, done: 1, remaining: 2, overdue: 0),
            SduiBlock.plantGrid(
              plants: [
                SduiPlantGridItem(id: 1, name: 'Фикус'),
                SduiPlantGridItem(id: 2, name: 'Кактус'),
              ],
            ),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(TodayCard), findsOneWidget);
      expect(find.byType(PlantCard), findsNWidgets(2));
      expect(find.text('Фикус'), findsOneWidget);
      expect(find.text('Кактус'), findsOneWidget);
      expect(find.byType(HomeLoadingSkeleton), findsNothing);
      expect(find.byType(OfflineState), findsNothing);
    });

    testWidgets('guest_banner block renders title/body from l10n keys',
        (tester) async {
      await tester.pumpWidget(_wrap(
        layout: () async => const SduiScreenLayout(
          screenId: 'home',
          version: 1,
          blocks: [
            SduiBlock.guestBanner(
              titleKey: 'home.guest.title',
              bodyKey: 'home.guest.body',
              ctaAction: SduiAction(
                kind: SduiActionKind.navigate,
                target: '/home/register',
              ),
            ),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.text(l10n.sduiHomeGuestTitle), findsOneWidget);
      expect(find.text(l10n.sduiHomeGuestBody), findsOneWidget);
    });

    testWidgets('empty_state block renders title/body + CTA from l10n keys',
        (tester) async {
      await tester.pumpWidget(_wrap(
        layout: () async => const SduiScreenLayout(
          screenId: 'home',
          version: 1,
          blocks: [
            SduiBlock.emptyState(
              iconKey: 'home.empty.icon',
              titleKey: 'home.empty.title',
              bodyKey: 'home.empty.body',
              ctaAction: SduiAction(
                kind: SduiActionKind.navigate,
                target: '/home/add',
              ),
            ),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      final l10n = AppLocalizations.of(tester.element(find.byType(HomeScreen)));
      expect(find.text(l10n.sduiHomeEmptyTitle), findsOneWidget);
      expect(find.text(l10n.sduiHomeEmptyBody), findsOneWidget);
      // CTA-кнопка с подписью добавления растения.
      expect(find.text(l10n.homeAddPlant), findsOneWidget);
    });

    testWidgets('unknown l10n key degrades to empty string (no crash)',
        (tester) async {
      await tester.pumpWidget(_wrap(
        layout: () async => const SduiScreenLayout(
          screenId: 'home',
          version: 1,
          blocks: [
            SduiBlock.guestBanner(
              titleKey: 'totally.unknown.key',
              bodyKey: 'also.unknown',
            ),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('unknown block is skipped, known ones render', (tester) async {
      await tester.pumpWidget(_wrap(
        layout: () async => const SduiScreenLayout(
          screenId: 'home',
          version: 1,
          blocks: [
            SduiBlock.todaySummary(total: 1, done: 0, remaining: 1, overdue: 0),
            SduiBlock.unknown(),
            SduiBlock.plantGrid(plants: [SduiPlantGridItem(id: 1, name: 'X')]),
          ],
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(TodayCard), findsOneWidget);
      expect(find.byType(PlantCard), findsOneWidget);
    });
  });
}
