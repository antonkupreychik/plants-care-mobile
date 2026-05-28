import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/decorative_leaves.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/empty_pot_illustration.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/garden_empty.dart';
import 'package:plantcare_mobile/features/home/presentation/widgets/starter_ideas.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

/// Оборачивает [child] в минимальную обвязку, которой требуют виджеты
/// пустого сада: локализации (`AppLocalizations.of`) и тему с расширением
/// `PcColors` (`Theme.of(context).extension<PcColors>()!`). Без HomeScreen и
/// роутера — тестируем виджет напрямую, чтобы не тащить лишнюю хрупкость.
///
/// `SingleChildScrollView` спасает от overflow: карточка + горизонтальная лента
/// чипов на тестовом 800×600 канвасе по высоте не помещаются.
Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

void main() {
  group('GardenEmpty rendering', () {
    testWidgets(
        'should_render_heading_subtitle_both_buttons_and_starter_block_with_3_chips',
        (tester) async {
      await tester.pumpWidget(_wrap(
        GardenEmpty(
          onAdd: () {},
          onRecognizePhoto: () {},
          onOpenCatalog: () {},
        ),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(GardenEmpty)));

      // Серифный заголовок и подпись приглашения.
      expect(find.text(l10n.homeGardenEmptyHeading), findsOneWidget);
      expect(find.text(l10n.homeGardenEmptySubtitle), findsOneWidget);

      // Обе кнопки призыва к действию.
      expect(find.widgetWithText(FilledButton, l10n.homeAddPlant),
          findsOneWidget);
      expect(
          find.widgetWithText(OutlinedButton, l10n.homeRecognizeByPhoto),
          findsOneWidget);

      // Блок «Идеи на старт» с тремя стартовыми видами.
      expect(find.byType(StarterIdeas), findsOneWidget);
      expect(find.text(l10n.homeStarterMonstera), findsOneWidget);
      expect(find.text(l10n.homeStarterSucculent), findsOneWidget);
      expect(find.text(l10n.homeStarterPothos), findsOneWidget);
    });
  });

  group('GardenEmpty callbacks', () {
    testWidgets('should_invoke_onAdd_once_when_primary_button_tapped',
        (tester) async {
      var addCalls = 0;
      var recognizeCalls = 0;
      var catalogCalls = 0;

      await tester.pumpWidget(_wrap(
        GardenEmpty(
          onAdd: () => addCalls++,
          onRecognizePhoto: () => recognizeCalls++,
          onOpenCatalog: () => catalogCalls++,
        ),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(GardenEmpty)));

      await tester
          .tap(find.widgetWithText(FilledButton, l10n.homeAddPlant));
      await tester.pump();

      expect(addCalls, 1);
      // Тап по PRIMARY не должен задеть другие колбэки.
      expect(recognizeCalls, 0);
      expect(catalogCalls, 0);
    });

    testWidgets(
        'should_invoke_onRecognizePhoto_once_when_secondary_button_tapped',
        (tester) async {
      var addCalls = 0;
      var recognizeCalls = 0;

      await tester.pumpWidget(_wrap(
        GardenEmpty(
          onAdd: () => addCalls++,
          onRecognizePhoto: () => recognizeCalls++,
          onOpenCatalog: () {},
        ),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(GardenEmpty)));

      await tester.tap(
          find.widgetWithText(OutlinedButton, l10n.homeRecognizeByPhoto));
      await tester.pump();

      expect(recognizeCalls, 1);
      expect(addCalls, 0);
    });

    testWidgets('should_invoke_onOpenCatalog_when_starter_chip_tapped',
        (tester) async {
      var catalogCalls = 0;
      var addCalls = 0;

      await tester.pumpWidget(_wrap(
        GardenEmpty(
          onAdd: () => addCalls++,
          onRecognizePhoto: () {},
          onOpenCatalog: () => catalogCalls++,
        ),
      ));
      await tester.pumpAndSettle();

      final l10n =
          AppLocalizations.of(tester.element(find.byType(GardenEmpty)));

      // Тапаем сам чип (InkWell-обёртку первого вида), а не текст-подпись:
      // подпись лежит у нижнего края карточки и не является целью жеста.
      final chipInkWell = find.ancestor(
        of: find.text(l10n.homeStarterMonstera),
        matching: find.byType(InkWell),
      );
      expect(chipInkWell, findsOneWidget);

      // Лента чипов лежит ниже карточки — на тестовом 800×600 канвасе уходит
      // за нижний край. Подкручиваем её в видимую область перед тапом.
      await tester.ensureVisible(chipInkWell);
      await tester.pumpAndSettle();

      await tester.tap(chipInkWell);
      await tester.pump();

      expect(catalogCalls, 1);
      expect(addCalls, 0);
    });
  });

  group('decorative widgets smoke', () {
    testWidgets('should_paint_EmptyPotIllustration_without_exception',
        (tester) async {
      await tester.pumpWidget(_wrap(const EmptyPotIllustration(size: 160)));
      await tester.pumpAndSettle();

      expect(find.byType(EmptyPotIllustration), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should_paint_DecorativeLeaves_without_exception',
        (tester) async {
      // DecorativeLeaves — Positioned.fill, корректно живёт только в Stack.
      await tester.pumpWidget(_wrap(
        const SizedBox(
          height: 200,
          child: Stack(children: [DecorativeLeaves()]),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DecorativeLeaves), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
