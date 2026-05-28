import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/features/archive/data/archive_repository_provider.dart';
import 'package:plantcare_mobile/features/archive/domain/archive_repository.dart';
import 'package:plantcare_mobile/features/archive/domain/archive_view.dart';
import 'package:plantcare_mobile/features/archive/domain/archived_plant.dart';
import 'package:plantcare_mobile/features/archive/presentation/archive_screen.dart';
import 'package:plantcare_mobile/features/archive/presentation/widgets/archive_empty.dart';
import 'package:plantcare_mobile/features/archive/presentation/widgets/archive_loading.dart';
import 'package:plantcare_mobile/features/archive/presentation/widgets/archive_retrospective_card.dart';
import 'package:plantcare_mobile/features/archive/presentation/widgets/archived_plant_card.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockArchiveRepo extends Mock implements ArchiveRepository {}

const _dataView = ArchiveView(
  plants: [
    ArchivedPlant(
      id: 1,
      name: 'Алоэ Вера',
      speciesName: 'Алоэ',
      livedLabel: '11 месяцев',
      cause: 'Перелив',
      archivedDateLabel: 'апрель 2026',
    ),
    ArchivedPlant(
      id: 2,
      name: 'Босс',
      speciesName: 'Бонсай',
      livedLabel: '3 года 2 мес.',
      cause: 'Подарили родителям',
      archivedDateLabel: 'март 2026',
      gifted: true,
    ),
    ArchivedPlant(
      id: 3,
      name: 'Пушистик',
      speciesName: 'Папоротник',
      livedLabel: '4 месяца',
      cause: 'Сухой воздух',
      archivedDateLabel: 'январь 2026',
    ),
  ],
  retrospective: ArchiveRetrospective(averageLivedLabel: '1 год 4 мес.'),
);

const _emptyView = ArchiveView(plants: [], retrospective: null);

Future<T> _pending<T>() => Completer<T>().future;

Widget _wrap(_MockArchiveRepo repo) {
  return ProviderScope(
    overrides: [archiveRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const ArchiveScreen(),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(ArchiveScreen)));

void main() {
  late _MockArchiveRepo repo;

  setUp(() => repo = _MockArchiveRepo());

  testWidgets('should_show_loading_skeletons_when_repository_pending',
      (tester) async {
    when(() => repo.getArchive()).thenAnswer((_) => _pending());

    await tester.pumpWidget(_wrap(repo));
    await tester.pump();

    expect(find.byType(ArchiveLoading), findsOneWidget);
    expect(find.byType(SkeletonBox), findsWidgets);
    // Карточек данных и ретроспективы нет, пока грузится.
    expect(find.byType(ArchivedPlantCard), findsNothing);
    expect(find.byType(ArchiveRetrospectiveCard), findsNothing);
    expect(find.byType(ArchiveEmpty), findsNothing);
  });

  testWidgets('should_render_three_plants_eyebrow_and_retrospective_when_data',
      (tester) async {
    when(() => repo.getArchive())
        .thenAnswer((_) async => const Result.success(_dataView));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    // Eyebrow со счётчиком (3 растения) — в шапке, всегда видно.
    expect(find.text(l10n.archiveEyebrow(3).toUpperCase()), findsOneWidget);
    // Первые карточки видны сразу (ListView.builder строит видимые).
    expect(find.text('Алоэ Вера'), findsOneWidget);
    expect(find.text('Босс'), findsOneWidget);
    expect(find.byType(ArchivedPlantCard), findsWidgets);
    // Empty-state отсутствует при наличии растений.
    expect(find.byType(ArchiveEmpty), findsNothing);

    // Прокручиваем вниз — третья карточка и ретроспектива лениво строятся.
    await tester.scrollUntilVisible(find.text('Пушистик'), 300);
    expect(find.text('Пушистик'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byType(ArchiveRetrospectiveCard),
      300,
    );
    expect(find.byType(ArchiveRetrospectiveCard), findsOneWidget);
    expect(
      find.text(l10n.archiveRetrospectiveText('1 год 4 мес.')),
      findsOneWidget,
    );
  });

  testWidgets('should_use_gifted_prefix_for_gifted_and_plain_for_others',
      (tester) async {
    when(() => repo.getArchive())
        .thenAnswer((_) async => const Result.success(_dataView));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    // «Босс» подарен → «Прожил рядом»; погибшие → «Прожило рядом».
    expect(_findRichTextContaining(l10n.archiveLivedPrefixGifted), isTrue);
    expect(_findRichTextContaining(l10n.archiveLivedPrefix), isTrue);
  });

  testWidgets('should_show_empty_state_without_cards_when_view_empty',
      (tester) async {
    when(() => repo.getArchive())
        .thenAnswer((_) async => const Result.success(_emptyView));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    expect(find.byType(ArchiveEmpty), findsOneWidget);
    expect(find.text(l10n.archiveEmpty), findsOneWidget);
    expect(find.byType(ArchivedPlantCard), findsNothing);
    expect(find.byType(ArchiveRetrospectiveCard), findsNothing);
  });

  testWidgets('should_show_error_with_retry_when_repository_fails',
      (tester) async {
    when(() => repo.getArchive())
        .thenAnswer((_) async => const Result.failure(ApiError.network()));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text(l10n.retry), findsOneWidget);
    expect(find.byType(ArchivedPlantCard), findsNothing);
  });

  testWidgets('should_show_coming_soon_snackbar_when_diary_chip_tapped',
      (tester) async {
    when(() => repo.getArchive())
        .thenAnswer((_) async => const Result.success(_dataView));

    await tester.pumpWidget(_wrap(repo));
    await tester.pumpAndSettle();

    final l10n = _l10n(tester);
    await tester.tap(find.text(l10n.archiveOpenDiary).first);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(l10n.comingSoon), findsOneWidget);
  });
}

/// Ищет в дереве RichText, чей plain text содержит [needle].
bool _findRichTextContaining(String needle) {
  final richTexts = find.byType(RichText).evaluate();
  for (final element in richTexts) {
    final widget = element.widget as RichText;
    final text = widget.text.toPlainText();
    if (text.contains(needle)) return true;
  }
  return false;
}
