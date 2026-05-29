import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_detail.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_fact.dart';
import 'package:plantcare_mobile/features/catalog/domain/species_fact_category.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/species_toxicity_banner.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

const _toxicFact = SpeciesFact(
  category: SpeciesFactCategory.toxicity,
  title: 'Токсично для кошек и собак',
  body: 'Содержит нерастворимые оксалаты кальция.',
  source: 'ASPCA',
);

const _toxicDetail = SpeciesDetail(
  id: 1,
  name: 'Диффенбахия',
  facts: [_toxicFact],
);

const _nonToxicDetail = SpeciesDetail(
  id: 2,
  name: 'Хлорофитум',
  facts: [
    SpeciesFact(
      category: SpeciesFactCategory.care,
      title: 'Уход',
      body: 'Неприхотлив.',
    ),
  ],
);

// Обёртка как в widget-тестах фичи: тема PcColors (через AppTheme.light) +
// AppLocalizations. Баннер читает оба из контекста.
Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('SpeciesToxicityBanner.shouldShow', () {
    test('should_be_true_when_detail_has_toxicity_fact', () {
      expect(SpeciesToxicityBanner.shouldShow(_toxicDetail), isTrue);
    });

    test('should_be_false_when_detail_has_no_toxicity_fact', () {
      expect(SpeciesToxicityBanner.shouldShow(_nonToxicDetail), isFalse);
    });

    test('should_be_false_when_detail_has_no_facts', () {
      expect(
        SpeciesToxicityBanner.shouldShow(
          const SpeciesDetail(id: 3, name: 'Без фактов'),
        ),
        isFalse,
      );
    });
  });

  group('SpeciesToxicityBanner widget', () {
    testWidgets('should_render_title_and_body_when_toxicity_fact_present',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const SpeciesToxicityBanner(detail: _toxicDetail)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Токсично для кошек и собак'), findsOneWidget);
      expect(
        find.text('Содержит нерастворимые оксалаты кальция.'),
        findsOneWidget,
      );
      // Источник тоже отрисован.
      expect(find.text('ASPCA'), findsOneWidget);
      // Контейнер баннера присутствует (не схлопнут в SizedBox.shrink).
      expect(
        find.descendant(
          of: find.byType(SpeciesToxicityBanner),
          matching: find.byType(Container),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should_render_shrink_and_no_content_when_no_toxicity',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const SpeciesToxicityBanner(detail: _nonToxicDetail)),
      );
      await tester.pumpAndSettle();

      // Контента баннера нет — заголовок ухода в баннер не попадает.
      expect(find.text('Уход'), findsNothing);
      // Guard: рендерит SizedBox.shrink, а не Container с декорацией.
      final banner = tester.widget<SpeciesToxicityBanner>(
        find.byType(SpeciesToxicityBanner),
      );
      expect(SpeciesToxicityBanner.shouldShow(banner.detail), isFalse);
      expect(
        find.descendant(
          of: find.byType(SpeciesToxicityBanner),
          matching: find.byType(Container),
        ),
        findsNothing,
      );
    });
  });
}
