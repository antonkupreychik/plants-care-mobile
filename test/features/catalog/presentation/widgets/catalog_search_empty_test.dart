import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/catalog/domain/species.dart';
import 'package:plantcare_mobile/features/catalog/presentation/catalog_providers.dart';
import 'package:plantcare_mobile/features/catalog/presentation/widgets/catalog_search_empty.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Никогда не завершающийся Future — провайдер остаётся в AsyncLoading.
Future<T> _pending<T>() => Completer<T>().future;

Species _species(int id, String name) => Species(id: id, name: name);

Widget _wrap({
  required String query,
  Future<List<Species>> Function()? popular,
  VoidCallback? onAddPlant,
  ValueChanged<String>? onSuggestionTap,
}) {
  return ProviderScope(
    overrides: [
      popularSpeciesProvider.overrideWith(
        (_) async => popular != null ? await popular() : const <Species>[],
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: Scaffold(
        body: CatalogSearchEmpty(
          query: query,
          onSuggestionTap: onSuggestionTap ?? (_) {},
          onAddPlant: onAddPlant ?? () {},
        ),
      ),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(CatalogSearchEmpty)));

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('CatalogSearchEmpty layout', () {
    testWidgets(
        'should_show_title_containing_query_when_query_is_monstera',
        (tester) async {
      await tester.pumpWidget(_wrap(query: 'Монстера'));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Заголовок должен содержать переданный запрос — именно эту строку
      // формирует catalogSearchEmptyTitle(query).
      expect(find.text(l10n.catalogSearchEmptyTitle('Монстера')), findsOneWidget);
    });

    testWidgets(
        'should_show_hint_message_when_rendered',
        (tester) async {
      await tester.pumpWidget(_wrap(query: 'ромашка'));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.catalogSearchEmptyMessage), findsOneWidget);
    });

    testWidgets(
        'should_show_not_in_catalog_title_when_rendered',
        (tester) async {
      await tester.pumpWidget(_wrap(query: 'кактус'));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.catalogNotInCatalogTitle), findsOneWidget);
    });

    testWidgets(
        'should_show_add_button_text_when_rendered',
        (tester) async {
      await tester.pumpWidget(_wrap(query: 'кактус'));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.catalogNotInCatalogAdd), findsOneWidget);
    });
  });

  group('CatalogSearchEmpty suggestion chips', () {
    testWidgets(
        'should_show_two_chips_with_species_names_when_provider_returns_two_species',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          query: 'хлора',
          popular: () async => [
            _species(1, 'Монстера'),
            _species(2, 'Потос'),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Монстера'), findsOneWidget);
      expect(find.text('Потос'), findsOneWidget);
    });

    testWidgets(
        'should_show_suggestions_section_label_when_provider_returns_species',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          query: 'фикус',
          popular: () async => [_species(1, 'Фикус Бенджамина')],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.catalogSuggestionsTitle), findsOneWidget);
    });

    testWidgets(
        'should_not_show_chip_text_when_provider_returns_empty_list',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          query: 'МонстераB',
          popular: () async => const <Species>[],
        ),
      );
      await tester.pumpAndSettle();

      // Нет ни одного чипа с этим названием — пустой список не рендерит секцию.
      expect(find.text('МонстераB'), findsNothing);
    });

    testWidgets(
        'should_not_show_suggestions_section_when_provider_returns_empty_list',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          query: 'нечто',
          popular: () async => const <Species>[],
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Секция заголовка подсказок не появляется при пустом списке.
      expect(find.text(l10n.catalogSuggestionsTitle), findsNothing);
    });

    testWidgets(
        'should_cap_chips_at_four_when_provider_returns_more_than_four_species',
        (tester) async {
      final manySpecies = List.generate(
        6,
        (i) => _species(i + 1, 'Вид ${i + 1}'),
      );

      await tester.pumpWidget(
        _wrap(
          query: 'вид',
          popular: () async => manySpecies,
        ),
      );
      await tester.pumpAndSettle();

      // Виджет берёт только первые 4 через .take(4).
      expect(find.text('Вид 1'), findsOneWidget);
      expect(find.text('Вид 4'), findsOneWidget);
      expect(find.text('Вид 5'), findsNothing);
      expect(find.text('Вид 6'), findsNothing);
    });

    testWidgets(
        'should_call_onSuggestionTap_with_species_name_when_chip_is_tapped',
        (tester) async {
      String? tappedName;

      await tester.pumpWidget(
        _wrap(
          query: 'монст',
          popular: () async => [
            _species(1, 'Монстера'),
            _species(2, 'Потос'),
          ],
          onSuggestionTap: (name) => tappedName = name,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Монстера'));
      await tester.pump();

      expect(tappedName, equals('Монстера'));
    });

    testWidgets(
        'should_call_onSuggestionTap_with_correct_name_when_second_chip_is_tapped',
        (tester) async {
      String? tappedName;

      await tester.pumpWidget(
        _wrap(
          query: 'цвет',
          popular: () async => [
            _species(1, 'Монстера'),
            _species(2, 'Орхидея'),
          ],
          onSuggestionTap: (name) => tappedName = name,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Орхидея'));
      await tester.pump();

      // Второй чип передаёт своё собственное имя, а не имя первого.
      expect(tappedName, equals('Орхидея'));
    });
  });

  group('CatalogSearchEmpty CTA card', () {
    testWidgets(
        'should_call_onAddPlant_when_add_button_is_tapped',
        (tester) async {
      var addPlantCalled = false;

      await tester.pumpWidget(
        _wrap(
          query: 'незнакомое растение',
          onAddPlant: () => addPlantCalled = true,
        ),
      );
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      await tester.tap(find.text(l10n.catalogNotInCatalogAdd));
      await tester.pump();

      expect(addPlantCalled, isTrue);
    });

    testWidgets(
        'should_not_call_onAddPlant_when_button_is_not_tapped',
        (tester) async {
      var addPlantCalled = false;

      await tester.pumpWidget(
        _wrap(
          query: 'тест',
          onAddPlant: () => addPlantCalled = true,
        ),
      );
      await tester.pumpAndSettle();

      // Кнопку не нажимаем — коллбэк не должен вызываться.
      expect(addPlantCalled, isFalse);
    });
  });

  group('CatalogSearchEmpty loading/error state of popularSpeciesProvider', () {
    testWidgets(
        'should_render_without_chips_and_without_crash_when_provider_is_loading',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          query: 'пальма',
          popular: () => _pending<List<Species>>(),
        ),
      );
      // Один pump без settle: провайдер навсегда в AsyncLoading.
      await tester.pump();

      // Виджет отрисовался без падения.
      expect(find.byType(CatalogSearchEmpty), findsOneWidget);

      final l10n = _l10n(tester);
      // Чипов нет — секция подсказок не видна в состоянии загрузки.
      expect(find.text(l10n.catalogSuggestionsTitle), findsNothing);

      // Заголовок и кнопка добавления по-прежнему видны (не зависят от чипов).
      expect(find.text(l10n.catalogSearchEmptyTitle('пальма')), findsOneWidget);
      expect(find.text(l10n.catalogNotInCatalogAdd), findsOneWidget);
    });

    testWidgets(
        'should_render_without_chips_and_without_crash_when_provider_throws',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          query: 'кедр',
          popular: () async => throw Exception('network'),
        ),
      );
      await tester.pumpAndSettle();

      // Ошибка провайдера не роняет виджет (popularAsync.value == null).
      expect(find.byType(CatalogSearchEmpty), findsOneWidget);

      final l10n = _l10n(tester);
      expect(find.text(l10n.catalogSuggestionsTitle), findsNothing);

      // Основное содержимое по-прежнему отрисовано.
      expect(find.text(l10n.catalogSearchEmptyTitle('кедр')), findsOneWidget);
      expect(find.text(l10n.catalogNotInCatalogAdd), findsOneWidget);
    });
  });
}
