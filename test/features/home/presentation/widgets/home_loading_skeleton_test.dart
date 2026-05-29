import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

Widget _wrap() {
  return MaterialApp(
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: const Scaffold(body: HomeLoadingSkeleton()),
  );
}

void main() {
  group('HomeLoadingSkeleton', () {
    testWidgets('should_show_loading_caption', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(HomeLoadingSkeleton)));
      expect(l10n.homeLoadingCaption, 'Собираю твой сад…');
      expect(find.text(l10n.homeLoadingCaption), findsOneWidget);
    });

    testWidgets('should_render_skeleton_bones', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(SkeletonBox), findsWidgets);
    });

    testWidgets('should_not_overflow_on_small_screen', (tester) async {
      // Небольшой экран: скелетон не должен ронять RenderFlex overflow.
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap());
      await tester.pump();

      // pumpWidget бросил бы exception при overflow в debug-режиме.
      expect(tester.takeException(), isNull);
      expect(find.byType(HomeLoadingSkeleton), findsOneWidget);
    });
  });
}
