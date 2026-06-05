import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/clock/clock_provider.dart';
import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../data/vacation_repository_provider.dart';
import '../domain/vacation_range.dart';
import '../domain/vacation_status.dart';
import 'vacation_state.dart';

part 'vacation_controller.g.dart';

/// Дефолтная длительность предлагаемого отпуска (дней, включительно границы).
const int _defaultVacationDays = 14;

/// Контроллер экрана 25 «Режим отпуска». Не family (статус один на пользователя).
///
/// Контракт для ui-builder:
/// - провайдер `vacationControllerProvider` → `AsyncValue<VacationState>`.
/// - `build` грузит `GET /api/v1/vacation`, кладёт `status` и инициализирует
///   `range` пресетом (сегодня … +13 дней по [Clock]). Ошибка загрузки →
///   `AsyncError(ApiError)`.
/// - чтение: `state.status` (включён ли отпуск), `state.range` (выбранный
///   диапазон), `state.isActive`, `state.canEnable`, `state.busy`,
///   `state.actionError`.
/// - правка дат: [setFrom] / [setTo] (только локально, без сети).
/// - действия: [enable] (`POST`), [disable] (`DELETE`) → возвращают [ApiError]?
///   (`null` = успех).
@riverpod
class VacationController extends _$VacationController {
  @override
  Future<VacationState> build() async {
    final result = await ref.watch(vacationRepositoryProvider).getStatus();
    return switch (result) {
      Success(:final value) =>
        VacationState(status: value, range: _defaultRange()),
      Failure(:final error) => throw error,
    };
  }

  /// Пресет диапазона: сегодня (в локальной зоне) … +(_defaultVacationDays-1).
  /// Время отбрасывается — храним календарные даты.
  VacationRange _defaultRange() {
    final today = ref.read(clockProvider).nowUtc().toLocal();
    final from = DateTime(today.year, today.month, today.day);
    final to = from.add(const Duration(days: _defaultVacationDays - 1));
    return VacationRange(from: from, to: to);
  }

  /// Устанавливает начало отпуска в драфте. Если новое начало позже конца —
  /// конец подтягивается к началу (диапазон не «выворачивается»). В сеть не ходит.
  void setFrom(DateTime from) {
    _editRange((r) {
      final newFrom = _dateOnly(from);
      final newTo = r.to.isBefore(newFrom) ? newFrom : r.to;
      return r.copyWith(from: newFrom, to: newTo);
    });
  }

  /// Устанавливает конец отпуска в драфте. Если новый конец раньше начала —
  /// начало подтягивается к концу. В сеть не ходит.
  void setTo(DateTime to) {
    _editRange((r) {
      final newTo = _dateOnly(to);
      final newFrom = newTo.isBefore(r.from) ? newTo : r.from;
      return r.copyWith(from: newFrom, to: newTo);
    });
  }

  /// Включает режим отпуска выбранным диапазоном (`POST /api/v1/vacation`).
  /// Возвращает `null` при успехе, иначе [ApiError]. No-op (возвращает `null`),
  /// если уже идёт запись или диапазон невалиден (предвалидация).
  Future<ApiError?> enable() async {
    final current = state.value;
    if (current == null || current.busy) return null;
    if (!current.range.isValid) return null;

    state = AsyncData(current.copyWith(busy: true, actionError: null));

    final result =
        await ref.read(vacationRepositoryProvider).start(current.range);
    if (!ref.mounted) return null;

    return switch (result) {
      Success(:final value) => _onSuccess(value),
      Failure(:final error) => _onActionError(error),
    };
  }

  /// Досрочно выключает режим отпуска (`DELETE /api/v1/vacation`). Возвращает
  /// `null` при успехе, иначе [ApiError]. No-op, если уже идёт запись.
  Future<ApiError?> disable() async {
    final current = state.value;
    if (current == null || current.busy) return null;

    state = AsyncData(current.copyWith(busy: true, actionError: null));

    final result = await ref.read(vacationRepositoryProvider).end();
    if (!ref.mounted) return null;

    return switch (result) {
      Success(:final value) => _onSuccess(value),
      Failure(:final error) => _onActionError(error),
    };
  }

  // --- helpers ---

  void _editRange(VacationRange Function(VacationRange) edit) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(range: edit(current.range), actionError: null),
    );
  }

  /// Успех POST/DELETE: серверное состояние становится `status`, грязь действия
  /// снимается. Возвращает `null`.
  ApiError? _onSuccess(VacationStatus status) {
    final latest = state.value;
    if (latest == null) return null;
    state = AsyncData(
      latest.copyWith(status: status, busy: false, actionError: null),
    );
    return null;
  }

  /// Ошибка POST/DELETE: кладём `actionError`, статус и диапазон не трогаем
  /// (пользователь повторит). Возвращает [error].
  ApiError? _onActionError(ApiError error) {
    final latest = state.value;
    if (latest == null) return error;
    state = AsyncData(latest.copyWith(busy: false, actionError: error));
    return error;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
