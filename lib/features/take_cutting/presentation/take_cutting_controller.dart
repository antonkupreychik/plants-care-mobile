import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/result.dart';
// Кросс-фичевая инвалидация после успешного POST: созданный росток должен
// появиться в саду. Импорт presentation-провайдера home — то же осознанное
// исключение из «фича не импортит presentation другой фичи», что и в
// add_plant_wizard_controller (зависим от объявления провайдера, не от виджетов).
import '../../home/presentation/home_providers.dart';
import '../data/take_cutting_repository_provider.dart';
import '../domain/propagation_method.dart';
import 'take_cutting_state.dart';

part 'take_cutting_controller.g.dart';

/// Контроллер мастера «Взять черенок» (экран 18) — держит данные ростка и ведёт
/// сабмит. Family по [parentPlantId] (родитель, от которого берём черенок).
/// autoDispose сбрасывает состояние при закрытии мастера.
///
/// Виджет читает `ref.watch(takeCuttingControllerProvider(parentId))` и зовёт
/// методы; бизнес-логики/валидации в виджете нет (MADR-002). Use case для
/// создания нет (репозиторий тонкий, доменная логика — только валидация имени в
/// [TakeCuttingState]), поэтому [submit] зовёт репозиторий через провайдер
/// напрямую — допустимо, когда отдельного use case не существует.
@riverpod
class TakeCuttingController extends _$TakeCuttingController {
  @override
  TakeCuttingState build(int parentPlantId) {
    // Дата среза по умолчанию — сегодня (локальная), из инжектируемых часов
    // (детерминизм в тестах). Хранится как локальная дата для пикера/формата.
    final today = ref.watch(clockProvider).nowUtc().toLocal();
    return TakeCuttingState(cutAt: DateTime(today.year, today.month, today.day));
  }

  /// Ввод имени ростка. Сбрасывает статус ошибки, чтобы повторный сабмит был
  /// возможен после правки.
  void setName(String name) {
    state = state.copyWith(
      name: name,
      status: const TakeCuttingSubmitStatus.idle(),
    );
  }

  /// Выбор способа размножения (toggle активной карточки).
  void selectMethod(PropagationMethod method) {
    state = state.copyWith(method: method);
  }

  /// Выбор даты среза (из DatePicker).
  void setCutAt(DateTime date) {
    state = state.copyWith(cutAt: DateTime(date.year, date.month, date.day));
  }

  /// Создать росток, привязав к [parentPlantId].
  ///
  /// Single-call gate через [TakeCuttingState.canSubmit] (валидное имя + нет
  /// активной отправки). Возвращает id созданной записи при успехе, иначе null.
  /// На сервер уходит только имя + `parentPlantId`; способ и дата среза —
  /// UI-only (backend-полей пока нет).
  Future<int?> submit() async {
    if (!state.canSubmit) return null;

    state = state.copyWith(
      status: const TakeCuttingSubmitStatus.submitting(),
    );

    final result =
        await ref.read(takeCuttingRepositoryProvider).createCutting(
              name: state.trimmedName,
              parentPlantId: parentPlantId,
            );

    if (!ref.mounted) return null;

    switch (result) {
      case Success(:final value):
        ref.invalidate(homePlantsProvider);
        state = state.copyWith(
          status: TakeCuttingSubmitStatus.success(value),
        );
        return value;
      case Failure(:final error):
        state = state.copyWith(
          status: TakeCuttingSubmitStatus.failure(error),
        );
        return null;
    }
  }
}
