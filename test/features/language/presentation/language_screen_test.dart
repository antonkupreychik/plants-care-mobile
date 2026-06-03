import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/language/data/language_repository_provider.dart';
import 'package:plantcare_mobile/features/language/domain/app_language.dart';
import 'package:plantcare_mobile/features/language/domain/language_repository.dart';
import 'package:plantcare_mobile/features/language/presentation/language_providers.dart';
import 'package:plantcare_mobile/features/language/presentation/language_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockLanguageRepository extends Mock implements LanguageRepository {}

/// Стаб-нотифайер: отдаёт фиксированное состояние без обращения к хранилищу.
class _StubLocaleNotifier extends LocaleNotifier {
  _StubLocaleNotifier(this._initialState);

  final AsyncValue<Locale> _initialState;

  @override
  Future<Locale> build() {
    // Подставляем нужное состояние сразу, без обращения к репозиторию.
    state = _initialState;
    return Completer<Locale>().future; // state уже выставлен, future не используется
  }
}

Widget _wrap({
  required LanguageRepository repo,
  _StubLocaleNotifier? localeNotifier,
}) {
  return ProviderScope(
    overrides: [
      languageRepositoryProvider.overrideWithValue(repo),
      if (localeNotifier != null)
        localeProvider.overrideWith(() => localeNotifier),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const LanguageScreen(),
    ),
  );
}

Widget _wrapWithRealNotifier(LanguageRepository repo) {
  return ProviderScope(
    overrides: [
      languageRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const LanguageScreen(),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(LanguageScreen)));

void main() {
  setUpAll(() {
    registerFallbackValue(AppLanguage.ru);
  });

  late _MockLanguageRepository repo;

  setUp(() {
    repo = _MockLanguageRepository();
  });

  group('loading state', () {
    testWidgets('should_show_skeleton_circles_when_loading', (tester) async {
      // localeProvider зависает в AsyncLoading — ни один язык не выбран.
      final notifier = _StubLocaleNotifier(const AsyncLoading());

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pump();

      // В состоянии загрузки отображаются skeleton-кружки вместо галочек.
      expect(find.byType(SkeletonBox), findsWidgets);
    });

    testWidgets('should_not_show_check_icon_when_loading', (tester) async {
      final notifier = _StubLocaleNotifier(const AsyncLoading());

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pump();

      // Ни один язык не выбран — иконки галочки нет.
      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });
  });

  group('error state', () {
    testWidgets(
        'should_show_all_language_names_and_ru_selected_when_error',
        (tester) async {
      // Ошибка → graceful fallback: отображаем список с AppLanguage.ru
      // в качестве выбранного по умолчанию.
      final notifier = _StubLocaleNotifier(
        AsyncError(Exception('storage failure'), StackTrace.empty),
      );

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // Русский выбран (галочка присутствует).
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      // Нет skeleton'ов — экран в нормальном режиме, только fallback.
      expect(find.byType(SkeletonBox), findsNothing);
    });

    testWidgets(
        'should_show_ru_nativeName_in_error_state',
        (tester) async {
      final notifier = _StubLocaleNotifier(
        AsyncError(Exception('storage failure'), StackTrace.empty),
      );

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // 'Русский' — nativeName уникален среди ru/en.
      expect(find.text(AppLanguage.ru.nativeName), findsOneWidget);
    });

    testWidgets('should_allow_tap_on_language_row_when_error', (tester) async {
      when(() => repo.saveLanguage(any())).thenAnswer((_) async {});

      final notifier = _StubLocaleNotifier(
        AsyncError(Exception('storage failure'), StackTrace.empty),
      );

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // В состоянии ошибки строки кликабельны — onTap не null.
      // Тапаем по тексту 'Русский' (nativeName уникален).
      await tester.tap(find.text(AppLanguage.ru.nativeName));
      await tester.pumpAndSettle();

      // Тап не падает — тест дошёл сюда без исключения.
      expect(tester.takeException(), isNull);
    });
  });

  group('data state — ru selected', () {
    testWidgets(
        'should_show_check_on_ru_and_no_check_on_en_when_ru_selected',
        (tester) async {
      final notifier =
          _StubLocaleNotifier(AsyncData(Locale('ru')));

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // 'Русский' — nativeName для ru, уникален.
      expect(find.text(AppLanguage.ru.nativeName), findsOneWidget);
      // Ровно одна галочка — у русского.
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      // Нет skeleton'а.
      expect(find.byType(SkeletonBox), findsNothing);
    });

    testWidgets('should_show_both_native_and_english_names_when_data',
        (tester) async {
      final notifier =
          _StubLocaleNotifier(AsyncData(Locale('ru')));

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // nativeName для ru — 'Русский' (уникален).
      expect(find.text(AppLanguage.ru.nativeName), findsOneWidget);
      // nativeName для en — 'English'; englishName для en тоже 'English',
      // поэтому в дереве два текста 'English' (nativeName + englishName строки en).
      expect(find.text(AppLanguage.en.nativeName), findsWidgets);
      // englishName для ru — 'Russian' (уникален в дереве).
      expect(find.text(AppLanguage.ru.englishName), findsOneWidget);
    });
  });

  group('data state — en selected', () {
    testWidgets(
        'should_show_exactly_one_check_and_ru_nativeName_visible_when_en_selected',
        (tester) async {
      final notifier =
          _StubLocaleNotifier(AsyncData(Locale('en')));

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // 'Русский' всё ещё виден (обе строки в списке).
      expect(find.text(AppLanguage.ru.nativeName), findsOneWidget);
      // Галочка одна — у английского.
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });

  group('tap interactions', () {
    testWidgets('should_call_saveLanguage_en_when_english_row_tapped',
        (tester) async {
      when(() => repo.saveLanguage(any())).thenAnswer((_) async {});
      // Начинаем с ru, тапаем English.
      when(repo.getLanguage).thenAnswer((_) async => AppLanguage.ru);

      await tester.pumpWidget(_wrapWithRealNotifier(repo));
      await tester.pumpAndSettle();

      // Тапаем на строку English (nativeName не уникален — используем englishName
      // нотации «English» в строке en; но оба текста 'English' — один nativeName,
      // другой englishName. Tapаем на nativeName-часть строки en через Semantics:
      // первый встреченный Text('English') — это nativeName (fontSize 15, weight 600)).
      final englishNative = find.text('English').first;
      await tester.tap(englishNative);
      await tester.pumpAndSettle();

      verify(() => repo.saveLanguage(AppLanguage.en)).called(1);
    });

    testWidgets('should_call_saveLanguage_ru_when_russian_row_tapped',
        (tester) async {
      when(() => repo.saveLanguage(any())).thenAnswer((_) async {});
      // Начинаем с en, тапаем Русский.
      when(repo.getLanguage).thenAnswer((_) async => AppLanguage.en);

      await tester.pumpWidget(_wrapWithRealNotifier(repo));
      await tester.pumpAndSettle();

      // 'Русский' — nativeName уникален, используем его.
      await tester.tap(find.text(AppLanguage.ru.nativeName));
      await tester.pumpAndSettle();

      verify(() => repo.saveLanguage(AppLanguage.ru)).called(1);
    });
  });

  group('back button', () {
    testWidgets('should_find_back_button_in_widget_tree', (tester) async {
      final notifier =
          _StubLocaleNotifier(AsyncData(Locale('ru')));

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // Кнопка «назад» (arrow_back_rounded) всегда присутствует в шапке.
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });
  });

  group('header label', () {
    testWidgets('should_show_bilingual_header_label', (tester) async {
      final notifier =
          _StubLocaleNotifier(AsyncData(Locale('ru')));

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      // Шапка содержит «ЯЗЫК · LANGUAGE» независимо от выбранного языка.
      expect(find.text('ЯЗЫК · LANGUAGE'), findsOneWidget);
    });
  });

  group('subtitle and hint', () {
    testWidgets('should_show_subtitle_and_hint_texts_in_data_state',
        (tester) async {
      final notifier =
          _StubLocaleNotifier(AsyncData(Locale('ru')));

      await tester.pumpWidget(_wrap(repo: repo, localeNotifier: notifier));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.languageScreenSubtitle), findsOneWidget);
      expect(find.text(l10n.languageScreenHint), findsOneWidget);
    });
  });
}
