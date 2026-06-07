import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/plant_family/data/plant_family_repository_provider.dart';
import 'package:plantcare_mobile/features/plant_family/domain/plant_family.dart';
import 'package:plantcare_mobile/features/plant_family/domain/plant_family_repository.dart';
import 'package:plantcare_mobile/features/plant_family/presentation/plant_family_screen.dart';
import 'package:plantcare_mobile/features/plant_family/presentation/widgets/family_empty.dart';
import 'package:plantcare_mobile/features/plant_family/presentation/widgets/family_member_node.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements PlantFamilyRepository {}

const _plantId = 42;

Future<T> _pending<T>() => Completer<T>().future;

void _tallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _wrap(PlantFamilyRepository repo, {String? plantName}) => ProviderScope(
      overrides: [plantFamilyRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        home: PlantFamilyScreen(plantId: _plantId, plantName: plantName),
      ),
    );

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(PlantFamilyScreen)));

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  group('PlantFamilyScreen states', () {
    testWidgets('should_show_spinner_when_loading', (tester) async {
      when(() => repo.getFamily(_plantId))
          .thenAnswer((_) => _pending<Result<PlantFamily>>());

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should_show_error_with_retry_on_failure', (tester) async {
      when(() => repo.getFamily(_plantId))
          .thenAnswer((_) async => const Result.failure(ApiError.network()));

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorState), findsOneWidget);
    });

    testWidgets('should_show_empty_when_no_relations', (tester) async {
      when(() => repo.getFamily(_plantId)).thenAnswer(
        (_) async => const Result.success(PlantFamily(children: [])),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      expect(find.byType(FamilyEmpty), findsOneWidget);
    });

    testWidgets('should_render_parent_and_children_when_data', (tester) async {
      _tallSurface(tester);
      when(() => repo.getFamily(_plantId)).thenAnswer(
        (_) async => const Result.success(
          PlantFamily(
            parent: PlantFamilyMember(id: 1, name: 'Моника'),
            children: [
              PlantFamilyMember(id: 2, name: 'Моник'),
              PlantFamilyMember(id: 3, name: 'Дочка'),
            ],
          ),
        ),
      );

      await tester.pumpWidget(_wrap(repo, plantName: 'Фикус'));
      await tester.pumpAndSettle();

      expect(find.byType(FamilyEmpty), findsNothing);
      // Родитель, текущее растение и два отводка = 4 узла.
      expect(find.byType(FamilyMemberNode), findsNWidgets(4));
      expect(find.text('Моника'), findsOneWidget);
      expect(find.text('Моник'), findsOneWidget);
      expect(find.text('Дочка'), findsOneWidget);
      // Имя из extra показано как текущее растение.
      expect(find.text('Фикус'), findsWidgets);
    });

    // Имя текущего растения не задано → узел подписан дефолтным «Это растение».
    testWidgets('should_label_current_when_name_missing', (tester) async {
      _tallSurface(tester);
      when(() => repo.getFamily(_plantId)).thenAnswer(
        (_) async => const Result.success(
          PlantFamily(
            parent: PlantFamilyMember(id: 1, name: 'Моника'),
            children: [],
          ),
        ),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      expect(find.text(l10n.plantFamilyCurrentLabel), findsWidgets);
    });
  });
}
