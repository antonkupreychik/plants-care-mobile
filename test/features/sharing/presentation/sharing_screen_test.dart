import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/core/widgets/skeleton_box.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/home/data/home_repository_provider.dart';
import 'package:plantcare_mobile/features/home/domain/home_repository.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/sharing/data/sharing_repository_provider.dart';
import 'package:plantcare_mobile/features/sharing/domain/sharing_member.dart';
import 'package:plantcare_mobile/features/sharing/domain/sharing_repository.dart';
import 'package:plantcare_mobile/features/sharing/presentation/sharing_screen.dart';
import 'package:plantcare_mobile/features/sharing/presentation/widgets/sharing_member_tile.dart';
import 'package:plantcare_mobile/features/sharing/presentation/widgets/sharing_plant_select_tile.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockSharingRepo extends Mock implements SharingRepository {}

class _MockHomeRepo extends Mock implements HomeRepository {}

const _misha = SharingMember(
  id: 1,
  contact: '@misha',
  status: SharingMemberStatus.pending,
  canLogCare: true,
  plantIds: [10, 11],
);

const _monica = Plant(id: 10, name: 'Моника', speciesName: 'Монстера');
const _fernando = Plant(id: 11, name: 'Фернандо', speciesName: 'Папоротник');

Future<T> _pending<T>() => Completer<T>().future;

Widget _wrap(_MockSharingRepo repo, _MockHomeRepo homeRepo) {
  return ProviderScope(
    overrides: [
      sharingRepositoryProvider.overrideWithValue(repo),
      homeRepositoryProvider.overrideWithValue(homeRepo),
    ],
    child: MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(),
      home: const SharingScreen(),
    ),
  );
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(SharingScreen)));

void main() {
  setUpAll(() {
    registerFallbackValue(<int>[]);
  });

  late _MockSharingRepo repo;
  late _MockHomeRepo homeRepo;

  setUp(() {
    repo = _MockSharingRepo();
    homeRepo = _MockHomeRepo();
    // Дефолт: список растений готов (две штуки).
    when(() => homeRepo.getPlants(limit: any(named: 'limit')))
        .thenAnswer((_) async => const Result.success([_monica, _fernando]));
  });

  testWidgets('should_show_member_skeletons_when_members_loading',
      (tester) async {
    when(repo.getMembers).thenAnswer((_) => _pending());

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pump();

    expect(find.byType(SkeletonBox), findsWidgets);
  });

  testWidgets('should_show_error_with_retry_when_members_load_fails',
      (tester) async {
    when(repo.getMembers)
        .thenAnswer((_) async => const Result.failure(ApiError.network()));

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorState), findsOneWidget);
  });

  testWidgets('should_show_empty_state_when_no_members', (tester) async {
    when(repo.getMembers)
        .thenAnswer((_) async => const Result.success([]));

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pumpAndSettle();

    expect(find.text(_l10n(tester).sharingEmptyTitle), findsOneWidget);
    expect(find.byType(SharingMemberTile), findsNothing);
  });

  testWidgets('should_render_members_and_plant_select_tiles_in_data_state',
      (tester) async {
    when(repo.getMembers)
        .thenAnswer((_) async => const Result.success([_misha]));

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pumpAndSettle();

    expect(find.byType(SharingMemberTile), findsOneWidget);
    expect(find.text('@misha'), findsOneWidget);
    // Бейдж статуса PENDING.
    expect(find.text(_l10n(tester).sharingBadgePending), findsOneWidget);
    // Растения для выбора.
    expect(find.byType(SharingPlantSelectTile), findsNWidgets(2));
    expect(find.text('Моника'), findsOneWidget);
  });

  testWidgets('should_show_no_plants_message_when_user_has_no_plants',
      (tester) async {
    when(repo.getMembers)
        .thenAnswer((_) async => const Result.success([]));
    when(() => homeRepo.getPlants(limit: any(named: 'limit')))
        .thenAnswer((_) async => const Result.success([]));

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pumpAndSettle();

    expect(find.text(_l10n(tester).sharingNoPlantsAvailable), findsOneWidget);
  });

  testWidgets('should_show_validation_errors_when_submit_with_empty_form',
      (tester) async {
    when(repo.getMembers)
        .thenAnswer((_) async => const Result.success([]));

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pumpAndSettle();

    // Тап по кнопке отправки без заполнения формы.
    await tester.tap(find.text(_l10n(tester).sharingSubmit));
    await tester.pumpAndSettle();

    expect(find.text(_l10n(tester).sharingContactError), findsOneWidget);
    // Ошибка выбора растений ниже по скроллу — прокручиваем к ней.
    await tester.scrollUntilVisible(
      find.text(_l10n(tester).sharingNoPlantsError),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(_l10n(tester).sharingNoPlantsError), findsOneWidget);
    // invite не вызывался — форма невалидна.
    verifyNever(() => repo.invite(
          plantIds: any(named: 'plantIds'),
          inviteeContact: any(named: 'inviteeContact'),
          canLogCare: any(named: 'canLogCare'),
        ));
  });

  testWidgets('should_invite_with_selected_plants_and_contact_on_submit',
      (tester) async {
    var calls = 0;
    when(repo.getMembers).thenAnswer((_) async {
      calls++;
      return calls == 1
          ? const Result.success([])
          : const Result.success([_misha]);
    });
    when(() => repo.invite(
          plantIds: any(named: 'plantIds'),
          inviteeContact: any(named: 'inviteeContact'),
          canLogCare: any(named: 'canLogCare'),
        )).thenAnswer((_) async => const Result.success(_misha));

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pumpAndSettle();

    // Заполняем контакт.
    await tester.enterText(find.byType(TextField), '@misha');
    // Выбираем первое растение.
    await tester.tap(find.text('Моника'));
    await tester.pumpAndSettle();

    // Отправляем.
    await tester.tap(find.text(_l10n(tester).sharingSubmit));
    await tester.pumpAndSettle();

    final captured = verify(() => repo.invite(
          plantIds: captureAny(named: 'plantIds'),
          inviteeContact: captureAny(named: 'inviteeContact'),
          canLogCare: captureAny(named: 'canLogCare'),
        )).captured;
    expect(captured[0], [10]);
    expect(captured[1], '@misha');
    // Дефолт переключателя — true (право отмечать уход включено).
    expect(captured[2], isTrue);
    // Снэкбар успеха.
    expect(find.text(_l10n(tester).sharingInviteSuccess), findsOneWidget);
  });

  testWidgets('should_show_submit_error_when_invite_fails', (tester) async {
    when(repo.getMembers)
        .thenAnswer((_) async => const Result.success([]));
    when(() => repo.invite(
          plantIds: any(named: 'plantIds'),
          inviteeContact: any(named: 'inviteeContact'),
          canLogCare: any(named: 'canLogCare'),
        )).thenAnswer(
      (_) async => const Result.failure(ApiError.notFound()),
    );

    await tester.pumpWidget(_wrap(repo, homeRepo));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '@misha');
    await tester.tap(find.text('Моника'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_l10n(tester).sharingSubmit));
    await tester.pumpAndSettle();

    // Inline-ошибка отправки показана (текст по типу ApiError, не пустой).
    // Блок ошибки внизу формы — прокручиваем к нему.
    await tester.scrollUntilVisible(
      find.byIcon(Icons.error_outline_rounded),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });
}
