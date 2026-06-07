import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/api_error_l10n.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/theme/app_theme.dart';
import 'package:plantcare_mobile/core/widgets/error_state.dart';
import 'package:plantcare_mobile/features/add_plant/data/add_plant_repository_provider.dart';
import 'package:plantcare_mobile/features/add_plant/domain/add_plant_repository.dart';
import 'package:plantcare_mobile/features/add_plant/domain/species_summary.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_controller.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_screen.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/add_plant_wizard_state.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/species_providers.dart';
import 'package:plantcare_mobile/features/add_plant/presentation/widgets/care_plan_preview.dart';
import 'package:plantcare_mobile/core/locations/garden_location.dart';
import 'package:plantcare_mobile/features/home/presentation/home_providers.dart';
import 'package:plantcare_mobile/l10n/app_localizations.dart';

class _MockRepo extends Mock implements AddPlantRepository {}

/// Заглушка экрана комнат для тестов: при монтировании вызывает [onCreated]
/// (имитирует создание комнаты через rooms_controller → invalidate),
/// показывает маркер [_roomsMarker].
class _RoomsStub extends ConsumerStatefulWidget {
  const _RoomsStub({required this.onCreated});

  /// Вызывается один раз после первого кадра (post-frame).
  final VoidCallback onCreated;

  @override
  ConsumerState<_RoomsStub> createState() => _RoomsStubState();
}

class _RoomsStubState extends ConsumerState<_RoomsStub> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onCreated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('комнаты', key: _roomsMarker)),
    );
  }
}

/// Фейковый контроллер: стартует в idle, позволяет эмитировать
/// [AddPlantScheduleFailure] без реального сетевого вызова.
class _FakeWizardController extends AddPlantWizardController {
  @override
  AddPlantWizardState build() => const AddPlantWizardState();

  void emitScheduleFailure(int plantId) {
    state = state.copyWith(
      status: AddPlantSubmitStatus.scheduleFailure(
        plantId: plantId,
        error: const ApiError.network(),
      ),
    );
  }
}

const _ficus = SpeciesSummary(
  id: 7,
  name: 'Фикус',
  latinName: 'Ficus',
  wateringDays: 7,
  fertilizingDays: 30,
);

const _locations = [
  GardenLocation(id: 1, name: 'Спальня', isDefault: true, emoji: '🛏'),
  GardenLocation(id: 2, name: 'Кухня', isDefault: false),
];

Future<List<SpeciesSummary>> _pending() => Completer<List<SpeciesSummary>>().future;

/// Маркер «хост-экрана» под мастером — после закрытия мастера (`context.pop()`)
/// мы должны вернуться сюда.
const _hostMarker = Key('host-screen');

/// Маркер карточки растения — после успешного submit мастер переходит сюда.
const _plantCardMarker = Key('plant-card-screen');

/// Маркер экрана расписания — при AddPlantScheduleFailure мастер переходит сюда.
const _scheduleMarker = Key('edit-schedule-screen');

/// Маркер экрана управления комнатами — заглушка для тестов навигации.
const _roomsMarker = Key('rooms-screen');

/// Монтирует мастер на отдельном маршруте `/add` поверх хост-экрана через
/// настоящий GoRouter — так `context.pop()`/`context.go()` внутри мастера
/// работают, как в проде (мастер на root-навигаторе поверх shell).
/// [species]/[speciesError] управляют шагом 1, [repo] (необязателен) — сабмитом.
/// [locationsAfterRooms] — список, который вернёт homeLocationsProvider после
/// возврата из экрана комнат (для тестов автовыбора новой комнаты).
Future<void> _pump(
  WidgetTester tester, {
  List<SpeciesSummary>? species,
  Object? speciesError,
  bool speciesLoading = false,
  List<GardenLocation> locations = _locations,
  _MockRepo? repo,
}) async {
  final router = GoRouter(
    initialLocation: '/add',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) =>
            const Scaffold(body: Center(child: Text('хост', key: _hostMarker))),
        routes: [
          GoRoute(
            path: 'add',
            builder: (_, _) => const AddPlantWizardScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (_, _) => const SizedBox(),
            routes: [
              GoRoute(
                path: 'rooms',
                name: 'rooms',
                builder: (_, _) => const Scaffold(
                  body: Center(
                    child: Text('комнаты', key: _roomsMarker),
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'home',
            builder: (_, _) => const SizedBox(),
            routes: [
              GoRoute(
                path: 'plants/:id',
                builder: (_, _) => const Scaffold(
                  body: Center(
                    child: Text('карточка', key: _plantCardMarker),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'schedule',
                    name: 'editSchedule',
                    builder: (_, _) => const Scaffold(
                      body: Center(
                        child: Text('расписание', key: _scheduleMarker),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        if (repo != null) addPlantRepositoryProvider.overrideWithValue(repo),
        speciesSearchProvider('').overrideWith((ref) {
          if (speciesLoading) return _pending();
          if (speciesError != null) return Future.error(speciesError);
          return Future.value(species ?? const <SpeciesSummary>[]);
        }),
        homeLocationsProvider.overrideWith((ref) async => locations),
      ],
      child: MaterialApp.router(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    ),
  );
  await tester.pump();
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(AddPlantWizardScreen)));

/// Переход с шага 1 на шаг 2 нажатием «Пропустить вид».
Future<void> _skipToNameStep(WidgetTester tester) async {
  final l10n = _l10n(tester);
  await tester.tap(find.text(l10n.addPlantSkipSpeciesTitle));
  await tester.pumpAndSettle();
}

void main() {
  group('step 1 (species search)', () {
    testWidgets('should_show_skeleton_when_loading', (tester) async {
      await _pump(tester, speciesLoading: true);

      // Скелетон есть, ошибки/empty нет.
      expect(find.byType(ErrorState), findsNothing);
      final l10n = _l10n(tester);
      expect(find.text(l10n.addPlantSearchEmpty), findsNothing);
    });

    testWidgets('should_show_error_with_retry_when_search_fails',
        (tester) async {
      await _pump(tester, speciesError: const ApiError.network());
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      expect(find.byType(ErrorState), findsOneWidget);
      expect(
        find.text(l10n.messageForError(const ApiError.network())),
        findsOneWidget,
      );
      expect(find.text(l10n.retry), findsOneWidget);
    });

    testWidgets('should_show_empty_state_when_no_species', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      expect(find.text(l10n.addPlantSearchEmpty), findsOneWidget);
    });

    testWidgets('should_show_species_cards_when_data', (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();

      expect(find.text('Фикус'), findsOneWidget);
      expect(find.text('Ficus'), findsOneWidget);
    });

    testWidgets('should_go_to_name_step_with_prefilled_name_when_species_tapped',
        (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Фикус'));
      await tester.pumpAndSettle();

      final l10n = _l10n(tester);
      // Шаг 2: заголовок имени + поле префиллено именем вида.
      expect(find.text(l10n.addPlantNameTitle), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Фикус'), findsOneWidget);
    });

    testWidgets('should_go_to_name_step_without_species_when_skip',
        (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();

      await _skipToNameStep(tester);

      final l10n = _l10n(tester);
      expect(find.text(l10n.addPlantNameTitle), findsOneWidget);
      // Имя не префиллено (вид не выбран).
      expect(find.widgetWithText(TextField, 'Фикус'), findsNothing);
    });
  });

  group('step 2 (name + room)', () {
    testWidgets('should_keep_next_disabled_until_valid_name_then_enable',
        (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      // Имя пустое: «Далее» отрисована, но не должна вести на шаг 3.
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();
      expect(find.text(l10n.addPlantNameTitle), findsOneWidget); // остались

      // Вводим валидное имя → «Далее» работает.
      await tester.enterText(find.byType(TextField).first, 'Алоэ');
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();

      // Перешли на шаг 3 (план ухода).
      expect(find.text(l10n.addPlantCarePlanTitle), findsOneWidget);
    });

    testWidgets('should_show_rooms_from_homeLocationsProvider', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);

      expect(find.text('Спальня'), findsOneWidget);
      expect(find.text('Кухня'), findsOneWidget);
    });
  });

  group('step 3 (care plan)', () {
    testWidgets('should_show_plan_cards_when_species_selected', (tester) async {
      await _pump(tester, species: const [_ficus], repo: _MockRepo());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Фикус'));
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      // Шаг 2 → шаг 3.
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();

      // _ficus имеет 2 интервала (watering, fertilizing) → 2 карточки плана.
      expect(find.byType(CarePlanPreview), findsOneWidget);
      expect(find.byType(CarePlanHint), findsNothing);
    });

    testWidgets('should_show_hint_when_no_species_selected', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      await tester.enterText(find.byType(TextField).first, 'Алоэ');
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext));
      await tester.pumpAndSettle();

      expect(find.byType(CarePlanHint), findsOneWidget);
      expect(find.byType(CarePlanPreview), findsNothing);
    });
  });

  group('step 4 (photo + window + submit)', () {
    /// Доводит мастер до шага 5 (дата + акклиматизация, кнопка «Добавить в сад»)
    /// с валидным именем «Алоэ» (без вида).
    Future<void> goToConfirm(WidgetTester tester) async {
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'Алоэ');
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext)); // → шаг 3 (care plan)
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext)); // → шаг 4 (photo/window)
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext)); // → шаг 5 (date + acclimation)
      await tester.pumpAndSettle();
    }

    testWidgets('should_show_progress_and_block_button_while_submitting',
        (tester) async {
      final repo = _MockRepo();
      final completer = Completer<Result<int>>();
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
            acquiredAt: any(named: 'acquiredAt'),
            isNew: any(named: 'isNew'),
          )).thenAnswer((_) => completer.future);

      await _pump(tester, species: const [], repo: repo);
      await tester.pumpAndSettle();
      await goToConfirm(tester);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantSubmitGarden));
      await tester.pump(); // submitting

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const Result.success(1));
      await tester.pumpAndSettle();
    });

    testWidgets('should_show_inline_error_and_keep_form_on_failure',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
            acquiredAt: any(named: 'acquiredAt'),
            isNew: any(named: 'isNew'),
          )).thenAnswer((_) async => const Result.failure(ApiError.network()));

      await _pump(tester, species: const [], repo: repo);
      await tester.pumpAndSettle();
      await goToConfirm(tester);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantSubmitGarden));
      await tester.pumpAndSettle();

      // Inline-ошибка по типу + форма на месте (мастер не закрыт), кнопка снова есть.
      expect(
        find.text(l10n.messageForError(const ApiError.network())),
        findsOneWidget,
      );
      expect(find.text(l10n.addPlantStepAcclimationTitle), findsOneWidget);
      expect(find.text(l10n.addPlantSubmitGarden), findsOneWidget);
    });

    testWidgets('should_navigate_to_plant_card_on_success',
        (tester) async {
      final repo = _MockRepo();
      when(() => repo.createPlant(
            name: any(named: 'name'),
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
            acquiredAt: any(named: 'acquiredAt'),
            isNew: any(named: 'isNew'),
          )).thenAnswer((_) async => const Result.success(99));

      await _pump(tester, species: const [], repo: repo);
      await tester.pumpAndSettle();
      await goToConfirm(tester);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantSubmitGarden));
      await tester.pumpAndSettle();

      // Мастер закрыт, открылась карточка растения.
      expect(find.byType(AddPlantWizardScreen), findsNothing);
      expect(find.byKey(_plantCardMarker), findsOneWidget);
      verify(() => repo.createPlant(
            name: 'Алоэ',
            locationId: any(named: 'locationId'),
            notes: any(named: 'notes'),
            speciesId: any(named: 'speciesId'),
            acquiredAt: any(named: 'acquiredAt'),
            isNew: any(named: 'isNew'),
          )).called(1);
    });
  });

  group('step 1 extras (categories + recognize)', () {
    testWidgets('should_show_category_chips', (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      expect(find.text(l10n.addPlantCategoryPopular), findsOneWidget);
      expect(find.text(l10n.addPlantCategoryBeginner), findsOneWidget);
      expect(find.text(l10n.addPlantCategoryFlowering), findsOneWidget);
      expect(find.text(l10n.addPlantCategoryLowWater), findsOneWidget);
    });

    testWidgets('should_show_recognize_placeholder_snackbar_when_tapped',
        (tester) async {
      await _pump(tester, species: const [_ficus]);
      await tester.pumpAndSettle();
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantRecognizeHint));
      await tester.pump();

      expect(find.text(l10n.addPlantRecognizeUnavailable), findsOneWidget);
    });
  });

  group('step 2 extras (new room CTA)', () {
    testWidgets('should_show_new_room_cta_on_step_2', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      expect(find.text(l10n.addPlantNewRoom), findsOneWidget);
    });

    testWidgets(
        'should_push_rooms_without_unmounting_wizard_when_new_room_tapped',
        (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      // Тап «Новая комната» открывает экран комнат поверх мастера (push).
      await tester.tap(find.text(l10n.addPlantNewRoom));
      await tester.pumpAndSettle();

      // Экран комнат открыт поверх.
      expect(find.byKey(_roomsMarker), findsOneWidget);
      // Wizard присутствует в дереве (не размонтирован) — состояние черновика
      // сохранено (autoDispose провайдера не срабатывает).
      // skipOffstage: false — мастер ниже rooms в стеке и может быть offstage.
      expect(
        find.byType(AddPlantWizardScreen, skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets(
        'should_restore_wizard_state_after_returning_from_rooms',
        (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      // Вводим имя — визард должен помнить его после возврата из комнат.
      await tester.enterText(find.byType(TextField).first, 'Монстера');
      await tester.pumpAndSettle();

      // Переходим в экран комнат (push, не go).
      await tester.tap(find.text(l10n.addPlantNewRoom));
      await tester.pumpAndSettle();
      expect(find.byKey(_roomsMarker), findsOneWidget);

      // Возвращаемся назад.
      final NavigatorState navigator =
          tester.state(find.byType(Navigator).first);
      navigator.pop();
      await tester.pumpAndSettle();

      // Мастер снова на переднем плане, введённое имя сохранено.
      expect(find.byType(AddPlantWizardScreen), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Монстера'), findsOneWidget);
    });

    testWidgets(
        'should_autoselect_new_room_when_returning_from_rooms_after_creation',
        (tester) async {
      // Начальный список — только «Спальня».
      const existingRoom =
          GardenLocation(id: 1, name: 'Спальня', isDefault: true);
      const newRoom = GardenLocation(id: 3, name: 'Балкон', isDefault: false);

      // Мутабельная ссылка: stub обновляет её и инвалидирует провайдер.
      // Провайдер перечитывает список при следующем build (после инвалидации).
      var currentLocations = <GardenLocation>[existingRoom];

      late ProviderContainer container;
      container = ProviderContainer(
        overrides: [
          speciesSearchProvider('').overrideWith(
            (ref) => Future.value(const <SpeciesSummary>[]),
          ),
          homeLocationsProvider.overrideWith(
            (ref) async => List<GardenLocation>.unmodifiable(currentLocations),
          ),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/add',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(
              body: Center(child: Text('хост', key: _hostMarker)),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, _) => const AddPlantWizardScreen(),
              ),
              GoRoute(
                path: 'profile',
                builder: (_, _) => const SizedBox(),
                routes: [
                  GoRoute(
                    path: 'rooms',
                    name: 'rooms',
                    builder: (_, _) => _RoomsStub(
                      onCreated: () {
                        // Имитируем создание комнаты: rooms_controller обновляет
                        // список и инвалидирует homeLocationsProvider.
                        currentLocations = [existingRoom, newRoom];
                        container.invalidate(homeLocationsProvider);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _skipToNameStep(tester);
      final l10n = _l10n(tester);

      // Переходим в экран комнат (stub «создаёт» Балкон и инвалидирует провайдер).
      await tester.tap(find.text(l10n.addPlantNewRoom));
      await tester.pumpAndSettle();
      expect(find.byKey(_roomsMarker), findsOneWidget);

      // Возвращаемся назад.
      final NavigatorState navigator =
          tester.state(find.byType(Navigator).first);
      navigator.pop();
      await tester.pumpAndSettle();

      // Новая комната «Балкон» отображается в списке.
      expect(find.text('Балкон'), findsOneWidget);
    });
  });

  group('step 4 extras (photo + window side)', () {
    Future<void> goToPhotoStep(WidgetTester tester) async {
      await _skipToNameStep(tester);
      final l10n = _l10n(tester);
      await tester.enterText(find.byType(TextField).first, 'Алоэ');
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext)); // → шаг 3 (care plan)
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.addPlantNext)); // → шаг 4 (photo/window)
      await tester.pumpAndSettle();
    }

    testWidgets('should_show_window_side_options', (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await goToPhotoStep(tester);
      final l10n = _l10n(tester);

      // Заголовок секции рисуется в верхнем регистре (_SectionLabel).
      expect(
        find.text(l10n.addPlantWindowLabel.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text(l10n.addPlantWindowSouth), findsOneWidget);
      expect(find.text(l10n.addPlantWindowEast), findsOneWidget);
      expect(find.text(l10n.addPlantWindowWest), findsOneWidget);
      expect(find.text(l10n.addPlantWindowNorth), findsOneWidget);
    });

    testWidgets('should_show_photo_unavailable_snackbar_when_camera_tapped',
        (tester) async {
      await _pump(tester, species: const []);
      await tester.pumpAndSettle();
      await goToPhotoStep(tester);
      final l10n = _l10n(tester);

      await tester.tap(find.text(l10n.addPlantPhotoCamera));
      await tester.pump();

      expect(find.text(l10n.addPlantPhotoUnavailable), findsOneWidget);
    });
  });

  group('ref.listen navigation', () {
    /// Строит мастер поверх GoRouter с маршрутом editSchedule, используя
    /// [_FakeWizardController] вместо реального контроллера.
    /// Возвращает Riverpod-контейнер, чтобы тест мог вызвать методы фейкового
    /// контроллера после рендера.
    Future<ProviderContainer> pumpWithFakeController(
      WidgetTester tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/add',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(
              body: Center(child: Text('хост', key: _hostMarker)),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, _) => const AddPlantWizardScreen(),
              ),
              GoRoute(
                path: 'home',
                builder: (_, _) => const SizedBox(),
                routes: [
                  GoRoute(
                    path: 'plants/:id',
                    builder: (_, _) => const Scaffold(
                      body: Center(
                        child: Text('карточка', key: _plantCardMarker),
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: 'schedule',
                        name: 'editSchedule',
                        builder: (_, _) => const Scaffold(
                          body: Center(
                            child: Text('расписание', key: _scheduleMarker),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      // Создаём контейнер явно, чтобы можно было обратиться к notifier-у
      // после рендера без зависимости от внутреннего контейнера ProviderScope.
      final container = ProviderContainer(
        overrides: [
          addPlantWizardControllerProvider
              .overrideWith(() => _FakeWizardController()),
          speciesSearchProvider('').overrideWith(
            (ref) => Future.value(const <SpeciesSummary>[]),
          ),
          homeLocationsProvider.overrideWith((ref) async => _locations),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
      await tester.pump();
      return container;
    }

    testWidgets(
        'should_navigate_to_editSchedule_when_AddPlantScheduleFailure_emitted',
        (tester) async {
      // Arrange: мастер в idle-состоянии.
      final container = await pumpWithFakeController(tester);

      // Убеждаемся, что мастер отрисован и маршрут расписания ещё не открыт.
      expect(find.byType(AddPlantWizardScreen), findsOneWidget);
      expect(find.byKey(_scheduleMarker), findsNothing);

      // Act: контроллер эмитирует scheduleFailure (растение создано, но
      // интервалы не применились из-за сетевой ошибки).
      final notifier = container
          .read(addPlantWizardControllerProvider.notifier)
          as _FakeWizardController;
      notifier.emitScheduleFailure(42);
      await tester.pumpAndSettle();

      // Assert: ref.listen поймал переход и навигировал на editSchedule.
      expect(find.byType(AddPlantWizardScreen), findsNothing);
      expect(find.byKey(_scheduleMarker), findsOneWidget);
    });
  });
}
