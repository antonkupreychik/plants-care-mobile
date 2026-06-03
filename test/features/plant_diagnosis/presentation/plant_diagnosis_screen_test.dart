import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/care_history/data/care_history_repository_provider.dart';
import 'package:plantcare_mobile/features/care_history/domain/care_history_repository.dart';
import 'package:plantcare_mobile/features/home/domain/plant.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/data/diagnosis_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/diagnosis_issue.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/diagnosis_repository.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/diagnosis_severity.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/domain/plant_diagnosis.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/presentation/plant_diagnosis_screen.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/presentation/widgets/_healthy_state.dart';
import 'package:plantcare_mobile/features/plant_diagnosis/presentation/widgets/_issues_list.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockDiagnosisRepo extends Mock implements DiagnosisRepository {}

class _MockCareHistoryRepo extends Mock implements CareHistoryRepository {}

const _plantId = 42;

Future<T> _pending<T>() => Completer<T>().future;

Plant _plant({String name = 'Фикус'}) => Plant(
      id: _plantId,
      name: name,
      speciesName: 'Ficus benjamina',
      locationName: 'Гостиная',
      createdAt: DateTime.utc(2026, 1, 1),
    );

PlantDiagnosis _healthyDiagnosis() => const PlantDiagnosis(
      issues: [],
      recommendations: [],
    );

PlantDiagnosis _sickDiagnosis() => PlantDiagnosis(
      issues: [
        const DiagnosisIssue(
          code: 'UNDERWATERED',
          severity: DiagnosisSeverity.high,
          title: 'Недополив',
        ),
        const DiagnosisIssue(
          code: 'LOW_HUMIDITY',
          severity: DiagnosisSeverity.medium,
          title: 'Низкая влажность',
        ),
      ],
      recommendations: const [
        'Поливайте обильнее',
        'Используйте увлажнитель',
      ],
    );

Widget _wrap({
  required _MockDiagnosisRepo diagnosisRepo,
  required _MockCareHistoryRepo careRepo,
}) =>
    ProviderScope(
      overrides: [
        diagnosisRepositoryProvider.overrideWithValue(diagnosisRepo),
        careHistoryRepositoryProvider.overrideWithValue(careRepo),
      ],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: const PlantDiagnosisScreen(plantId: _plantId),
      ),
    );

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(PlantDiagnosisScreen)));

void main() {
  setUpAll(() => registerFallbackValue(StackTrace.empty));

  late _MockDiagnosisRepo diagnosisRepo;
  late _MockCareHistoryRepo careRepo;

  setUp(() {
    diagnosisRepo = _MockDiagnosisRepo();
    careRepo = _MockCareHistoryRepo();
  });

  /// Стабит `getPlant` на успешный ответ — нужен во всех тестах секции диагноза,
  /// чтобы hero-шапка не оставалась в loading и не мешала `pumpAndSettle`.
  void stubPlantSuccess() {
    when(() => careRepo.getPlant(_plantId)).thenAnswer(
      (_) async => Result.success(_plant()),
    );
  }

  /// Стабит `getDiagnosis` на успешный ответ.
  void stubDiagnosisSuccess(PlantDiagnosis diagnosis) {
    when(() => diagnosisRepo.getDiagnosis(_plantId))
        .thenAnswer((_) async => Result.success(diagnosis));
  }

  group('PlantDiagnosisScreen loading state', () {
    testWidgets(
        'should_show_skeleton_containers_and_no_issue_titles_when_diagnosis_loading',
        (tester) async {
      // Диагноз зависает в pending.
      when(() => diagnosisRepo.getDiagnosis(_plantId))
          .thenAnswer((_) => _pending<Result<PlantDiagnosis>>());
      stubPlantSuccess();

      await tester.pumpWidget(_wrap(
        diagnosisRepo: diagnosisRepo,
        careRepo: careRepo,
      ));
      await tester.pump();

      // IssuesListSkeleton отображается при loading.
      expect(find.byType(IssuesListSkeleton), findsOneWidget);
      // Текст проблем не виден.
      expect(find.text('Недополив'), findsNothing);
      expect(find.text('Низкая влажность'), findsNothing);
      // Здорового состояния тоже нет.
      expect(find.byType(HealthyState), findsNothing);
    });
  });

  group('PlantDiagnosisScreen error state', () {
    testWidgets('should_show_ErrorState_and_retry_button_when_diagnosis_fails',
        (tester) async {
      when(() => diagnosisRepo.getDiagnosis(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.notFound()));
      stubPlantSuccess();

      await tester.pumpWidget(_wrap(
        diagnosisRepo: diagnosisRepo,
        careRepo: careRepo,
      ));
      // Riverpod 3 retries FutureProvider failures with exponential backoff.
      // A 60-second simulated time advance exhausts all retry delays so that
      // the provider settles into a terminal state and when() calls error:.
      await tester.pump(const Duration(seconds: 60));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
      expect(find.text(_l10n(tester).diagnosisRetry), findsOneWidget);
    });
  });

  group('PlantDiagnosisScreen healthy state', () {
    testWidgets(
        'should_show_HealthyState_with_diagnosisHealthyTitle_when_isHealthy',
        (tester) async {
      stubDiagnosisSuccess(_healthyDiagnosis());
      stubPlantSuccess();

      await tester.pumpWidget(_wrap(
        diagnosisRepo: diagnosisRepo,
        careRepo: careRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.byType(HealthyState), findsOneWidget);
      expect(find.text(_l10n(tester).diagnosisHealthyTitle), findsOneWidget);
      // Карточек проблем нет.
      expect(find.byType(IssuesList), findsNothing);
    });
  });

  group('PlantDiagnosisScreen data with issues', () {
    testWidgets(
        'should_show_each_issue_title_and_recommendations_when_issues_non_empty',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      stubDiagnosisSuccess(_sickDiagnosis());
      stubPlantSuccess();

      await tester.pumpWidget(_wrap(
        diagnosisRepo: diagnosisRepo,
        careRepo: careRepo,
      ));
      await tester.pumpAndSettle();

      // Каждый issue title должен быть виден в дереве.
      expect(find.text('Недополив'), findsOneWidget);
      expect(find.text('Низкая влажность'), findsOneWidget);
      // Рекомендации видны.
      expect(find.text('Поливайте обильнее'), findsOneWidget);
      expect(find.text('Используйте увлажнитель'), findsOneWidget);
      // Здорового состояния нет.
      expect(find.byType(HealthyState), findsNothing);
    });
  });

  group('PlantDiagnosisScreen hero loading state', () {
    testWidgets(
        'should_not_show_plant_name_when_plant_provider_loading',
        (tester) async {
      stubDiagnosisSuccess(_healthyDiagnosis());
      // Данные растения зависают в pending.
      when(() => careRepo.getPlant(_plantId))
          .thenAnswer((_) => _pending<Result<Plant>>());

      await tester.pumpWidget(_wrap(
        diagnosisRepo: diagnosisRepo,
        careRepo: careRepo,
      ));
      await tester.pump();

      // Имени растения нет — hero показывает skeleton.
      expect(find.text('Фикус'), findsNothing);
    });

    testWidgets(
        'should_render_diagnosis_section_independently_when_plant_loading',
        (tester) async {
      stubDiagnosisSuccess(_healthyDiagnosis());
      // Данные растения зависают.
      when(() => careRepo.getPlant(_plantId))
          .thenAnswer((_) => _pending<Result<Plant>>());

      await tester.pumpWidget(_wrap(
        diagnosisRepo: diagnosisRepo,
        careRepo: careRepo,
      ));
      await tester.pumpAndSettle();

      // Секция диагноза рендерится независимо от hero.
      expect(find.byType(HealthyState), findsOneWidget);
    });
  });

  group('PlantDiagnosisScreen hero data state', () {
    testWidgets('should_show_plant_name_in_hero_when_plant_loaded',
        (tester) async {
      stubDiagnosisSuccess(_healthyDiagnosis());
      when(() => careRepo.getPlant(_plantId)).thenAnswer(
        (_) async => Result.success(_plant(name: 'Монстера')),
      );

      await tester.pumpWidget(_wrap(
        diagnosisRepo: diagnosisRepo,
        careRepo: careRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Монстера'), findsOneWidget);
    });
  });
}
