import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/locations/garden_location.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/species_summary.dart';
import 'add_plant_wizard_controller.dart';
import 'add_plant_wizard_state.dart';
import 'species_providers.dart';
import 'widgets/step_care_plan.dart';
import 'widgets/step_confirm.dart';
import 'widgets/step_name_room.dart';
import 'widgets/step_species.dart';
import 'widgets/wizard_chrome.dart';

/// Экран 04 «Добавление растения» — мастер из 4 шагов.
///
/// Текущий шаг держит локально (`PageController` + индекс) — данные копятся в
/// [addPlantWizardControllerProvider]. Полноэкранно поверх shell (см. роут
/// `/home/add`). На успешном сабмите закрывает мастер и возвращает на Home;
/// инвалидацию сада делает контроллер сам.
///
/// Продуктовый объём: 4-шаговый флоу, но backend сохраняет лишь
/// `name + locationId + notes`. Шаг вида префиллит имя + показывает read-only
/// план ухода; шаг расписания — read-only превью (BACKEND-GAPS).
///
/// [initialSpeciesId] — опциональный предвыбранный вид (CTA «Добавить в мой
/// сад» с карточки вида, экран 20). Если задан, мастер при инициализации грузит
/// этот вид, кладёт его в черновик и стартует с шага 2 (имя/комната), минуя
/// шаг 1. При ошибке загрузки — деградирует на обычный старт с шага 1.
class AddPlantWizardScreen extends ConsumerStatefulWidget {
  const AddPlantWizardScreen({super.key, this.initialSpeciesId});

  /// Id предвыбранного вида или null (обычный старт с шага 1).
  final int? initialSpeciesId;

  @override
  ConsumerState<AddPlantWizardScreen> createState() =>
      _AddPlantWizardScreenState();
}

class _AddPlantWizardScreenState extends ConsumerState<AddPlantWizardScreen> {
  static const _totalSteps = 4;
  static const _pageDuration = Duration(milliseconds: 280);
  // Индекс шага 2 «Имя/комната» в [PageView] (0-based).
  static const _stepNameRoom = 1;

  // Стартовая страница [PageController]: при предвыбранном виде сразу шаг 2,
  // иначе шаг 1. Используется как initialPage, чтобы не было «прыжка» анимации.
  late final PageController _pageController = PageController(
    initialPage: widget.initialSpeciesId != null ? _stepNameRoom : 0,
  );
  late int _step =
      widget.initialSpeciesId != null ? _stepNameRoom : 0; // 0-based индекс.

  @override
  void initState() {
    super.initState();
    final id = widget.initialSpeciesId;
    if (id != null) {
      // Предвыбор делаем один раз при инициализации (не на rebuild).
      // PageView уже стартует на шаге 2 (см. initialPage), а вид
      // подгружаем асинхронно и кладём в черновик.
      WidgetsBinding.instance.addPostFrameCallback((_) => _preselect(id));
    }
  }

  /// Грузит вид по id и проставляет его в черновик (как [selectSpecies]).
  /// При ошибке/невалидном id — деградируем на старт с шага 1 (откатываем
  /// стартовую страницу на 0), без краша.
  Future<void> _preselect(int id) async {
    try {
      final detail = await ref.read(speciesDetailProvider(id).future);
      if (!mounted) return;
      ref
          .read(addPlantWizardControllerProvider.notifier)
          .selectSpecies(detail.summary);
    } catch (_) {
      // Загрузка вида не удалась — откатываем на шаг 1, пользователь выберет
      // вид вручную. Без снекбара: деградация тихая (вид опционален в мастере).
      if (!mounted) return;
      _goTo(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    _pageController.animateToPage(
      index,
      duration: _pageDuration,
      curve: Curves.easeInOut,
    );
  }

  void _next() => _goTo(_step + 1);

  /// Назад: первый шаг → закрыть мастер; иначе — предыдущая страница.
  void _back() {
    if (_step == 0) {
      _close();
    } else {
      _goTo(_step - 1);
    }
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  void _onSelectSpecies(SpeciesSummary species) {
    ref.read(addPlantWizardControllerProvider.notifier).selectSpecies(species);
    _next();
  }

  Future<void> _submit() async {
    await ref.read(addPlantWizardControllerProvider.notifier).submit();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(addPlantWizardControllerProvider);
    final controller = ref.read(addPlantWizardControllerProvider.notifier);

    // Успех — закрываем мастер ровно один раз (listen, не в build).
    ref.listen(
      addPlantWizardControllerProvider.select((s) => s.status),
      (prev, next) {
        if (next is AddPlantSuccess) {
          // Захватываем messenger до pop: после _close() этот context
          // размонтируется, и ScaffoldMessenger.of(context) был бы хрупок.
          final messenger = ScaffoldMessenger.of(context);
          _close();
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.addPlantSubmitted)));
        }
      },
    );

    final submitting = state.status is AddPlantSubmitting;
    final draft = state.draft;
    final errorMessage = switch (state.status) {
      AddPlantFailure(:final error) => l10n.messageForError(error),
      _ => null,
    };

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: WizardHeader(
                step: _step + 1,
                totalSteps: _totalSteps,
                onBack: _back,
                onSkip: _step == 0 ? _next : null,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                // Свайп отключён: навигация только кнопками (валидность шага
                // решает контроллер/canSubmit, не жест).
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _StepScroll(
                    child: StepSpecies(
                      onSelected: _onSelectSpecies,
                      onSkip: _next,
                    ),
                  ),
                  _StepScroll(
                    child: StepNameRoom(
                      initialName: draft.name,
                      selectedLocationId: draft.locationId,
                      isNameValid: draft.isNameValid,
                      onNameChanged: controller.setName,
                      onLocationChanged: controller.setLocation,
                    ),
                  ),
                  _StepScroll(child: StepCarePlan(species: draft.species)),
                  _StepScroll(
                    child: _ConfirmStep(
                      state: state,
                      errorMessage: errorMessage,
                      onNoteChanged: controller.setNotes,
                    ),
                  ),
                ],
              ),
            ),
            // Панель действий: на шаге 1 скрыта (выбор вида/пропуск ведут вперёд).
            if (_step > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: _step == _totalSteps - 1
                    ? WizardActionBar(
                        primaryLabel: l10n.addPlantSubmit,
                        primaryIcon: Icons.check_rounded,
                        primaryEnabled: state.canSubmit,
                        primaryLoading: submitting,
                        onPrimary: _submit,
                        secondaryLabel: l10n.addPlantBack,
                        onSecondary: _back,
                      )
                    : WizardActionBar(
                        primaryLabel: l10n.addPlantNext,
                        primaryEnabled: _step != 1 || draft.isNameValid,
                        onPrimary: _next,
                        secondaryLabel: l10n.addPlantBack,
                        onSecondary: _back,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Скроллящийся контейнер страницы (контент шага может не влезать на узких
/// экранах / при крупном системном шрифте).
class _StepScroll extends StatelessWidget {
  const _StepScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      child: child,
    );
  }
}

/// Шаг подтверждения: резолвит имя комнаты из [homeLocationsProvider] по
/// `draft.locationId` (UI-обвязка, не бизнес-логика).
class _ConfirmStep extends ConsumerWidget {
  const _ConfirmStep({
    required this.state,
    required this.errorMessage,
    required this.onNoteChanged,
  });

  final AddPlantWizardState state;
  final String? errorMessage;
  final ValueChanged<String?> onNoteChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = state.draft;
    final locationId = draft.locationId;
    final locationName = locationId == null
        ? null
        : ref.watch(homeLocationsProvider).maybeWhen(
              data: (locs) => _nameFor(locs, locationId),
              orElse: () => null,
            );

    return StepConfirm(
      draft: draft,
      locationName: locationName,
      errorMessage: errorMessage,
      onNoteChanged: onNoteChanged,
    );
  }

  String? _nameFor(List<GardenLocation> locs, int id) {
    for (final loc in locs) {
      if (loc.id == id) return loc.name;
    }
    return null;
  }
}
