import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/clock/clock.dart';
import 'package:plantcare_mobile/core/clock/clock_provider.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/router/app_router.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/features/edit_schedule/data/edit_schedule_repository_provider.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/edit_schedule_repository.dart';
import 'package:plantcare_mobile/features/edit_schedule/domain/plant_care_schedule.dart';
import 'package:plantcare_mobile/features/edit_schedule/presentation/edit_schedule_screen.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_card/data/plant_card_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_card/domain/care_history_entry.dart';
import 'package:plantcare_mobile/features/plant_card/domain/plant_card_repository.dart';
import 'package:plantcare_mobile/features/plant_card/domain/streak.dart';
import 'package:plantcare_mobile/features/plant_card/presentation/plant_card_screen.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockPlantCardRepo extends Mock implements PlantCardRepository {}

class _MockScheduleRepo extends Mock implements EditScheduleRepository {}

class _FixedClock implements Clock {
  const _FixedClock(this._now);
  final DateTime _now;
  @override
  DateTime nowUtc() => _now;
}

final _fixedNow = DateTime.utc(2026, 5, 27, 9);

void main() {
  // Карточка растения 02 показывает вход «Расписание · Изменить»; тап ведёт на
  // экран 22 EditScheduleScreen с тем же plantId (через реальный роутер).
  testWidgets(
      'should_navigate_to_EditScheduleScreen_when_schedule_edit_link_tapped',
      (tester) async {
    final cardRepo = _MockPlantCardRepo();
    when(() => cardRepo.getPlant(any())).thenAnswer(
        (_) async => const Result.success(Plant(id: 77, name: 'Фикус')));
    when(() => cardRepo.getStreak(any())).thenAnswer(
        (_) async => const Result.success(Streak(plantId: 77, count: 3)));
    when(() => cardRepo.getHistory(any())).thenAnswer(
        (_) async => const Result.success(<CareHistoryEntry>[]));

    // Чтобы экран 22 поднялся чисто, отдаём пустой список расписаний.
    final scheduleRepo = _MockScheduleRepo();
    when(() => scheduleRepo.getSchedules(any()))
        .thenAnswer((_) async => const Result.success(<PlantCareSchedule>[]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(_fixedNow)),
          plantCardRepositoryProvider.overrideWithValue(cardRepo),
          editScheduleRepositoryProvider.overrideWithValue(scheduleRepo),
        ],
        child: MaterialApp.router(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light(),
          routerConfig: appRouter,
        ),
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/home/plants/77');
    await tester.pumpAndSettle();

    final l10n =
        AppLocalizations.of(tester.element(find.byType(PlantCardScreen)));

    // Вход «Расписание ухода · Изменить» на карточке.
    expect(find.text(l10n.plantCardScheduleTitle), findsOneWidget);
    final editLink = find.text(l10n.plantCardScheduleEdit);
    expect(editLink, findsOneWidget);

    await tester.tap(editLink);
    await tester.pumpAndSettle();

    // Перешли на экран 22 с тем же plantId.
    expect(find.byType(EditScheduleScreen), findsOneWidget);
    final screen =
        tester.widget<EditScheduleScreen>(find.byType(EditScheduleScreen));
    expect(screen.plantId, 77);
    // Имя пробрасывается через extra → overline шапки.
    expect(screen.plantName, 'Фикус');
  });
}
