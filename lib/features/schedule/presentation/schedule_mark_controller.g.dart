// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_mark_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер оптимистичной отметки ухода прямо из строки графика (экран 11).
///
/// В отличие от sheet 06 (`LogCareEventController`), здесь отметка одношаговая:
/// тап по кнопке-чеку → задача мгновенно уходит в «Сделано», параллельно
/// `POST /care-events`. На успех — кросс-фичевая инвалидация
/// ([_invalidateAfterSuccess], FLUTTER.md «Правила state»). На ошибку — откат
/// (задача возвращается из «Сделано») и [ScheduleMarkState.lastError] для
/// баннера.
///
/// Идемпотентность (FLUTTER.md): `clientId` генерируется ОДИН раз на действие
/// перед отправкой (не на каждый build) — повторный тап по уже отмеченной задаче
/// игнорируется (она в [ScheduleMarkState.doneKeys]/[pendingKeys]).
///
/// Время «сейчас» — из `clockProvider` (UTC), не `DateTime.now()` (FLUTTER.md
/// «Время»).

@ProviderFor(ScheduleMarkController)
final scheduleMarkControllerProvider = ScheduleMarkControllerProvider._();

/// Контроллер оптимистичной отметки ухода прямо из строки графика (экран 11).
///
/// В отличие от sheet 06 (`LogCareEventController`), здесь отметка одношаговая:
/// тап по кнопке-чеку → задача мгновенно уходит в «Сделано», параллельно
/// `POST /care-events`. На успех — кросс-фичевая инвалидация
/// ([_invalidateAfterSuccess], FLUTTER.md «Правила state»). На ошибку — откат
/// (задача возвращается из «Сделано») и [ScheduleMarkState.lastError] для
/// баннера.
///
/// Идемпотентность (FLUTTER.md): `clientId` генерируется ОДИН раз на действие
/// перед отправкой (не на каждый build) — повторный тап по уже отмеченной задаче
/// игнорируется (она в [ScheduleMarkState.doneKeys]/[pendingKeys]).
///
/// Время «сейчас» — из `clockProvider` (UTC), не `DateTime.now()` (FLUTTER.md
/// «Время»).
final class ScheduleMarkControllerProvider
    extends $NotifierProvider<ScheduleMarkController, ScheduleMarkState> {
  /// Контроллер оптимистичной отметки ухода прямо из строки графика (экран 11).
  ///
  /// В отличие от sheet 06 (`LogCareEventController`), здесь отметка одношаговая:
  /// тап по кнопке-чеку → задача мгновенно уходит в «Сделано», параллельно
  /// `POST /care-events`. На успех — кросс-фичевая инвалидация
  /// ([_invalidateAfterSuccess], FLUTTER.md «Правила state»). На ошибку — откат
  /// (задача возвращается из «Сделано») и [ScheduleMarkState.lastError] для
  /// баннера.
  ///
  /// Идемпотентность (FLUTTER.md): `clientId` генерируется ОДИН раз на действие
  /// перед отправкой (не на каждый build) — повторный тап по уже отмеченной задаче
  /// игнорируется (она в [ScheduleMarkState.doneKeys]/[pendingKeys]).
  ///
  /// Время «сейчас» — из `clockProvider` (UTC), не `DateTime.now()` (FLUTTER.md
  /// «Время»).
  ScheduleMarkControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scheduleMarkControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scheduleMarkControllerHash();

  @$internal
  @override
  ScheduleMarkController create() => ScheduleMarkController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScheduleMarkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScheduleMarkState>(value),
    );
  }
}

String _$scheduleMarkControllerHash() =>
    r'8c58c6add41d24669ac2d016d7f02458e7f0bef0';

/// Контроллер оптимистичной отметки ухода прямо из строки графика (экран 11).
///
/// В отличие от sheet 06 (`LogCareEventController`), здесь отметка одношаговая:
/// тап по кнопке-чеку → задача мгновенно уходит в «Сделано», параллельно
/// `POST /care-events`. На успех — кросс-фичевая инвалидация
/// ([_invalidateAfterSuccess], FLUTTER.md «Правила state»). На ошибку — откат
/// (задача возвращается из «Сделано») и [ScheduleMarkState.lastError] для
/// баннера.
///
/// Идемпотентность (FLUTTER.md): `clientId` генерируется ОДИН раз на действие
/// перед отправкой (не на каждый build) — повторный тап по уже отмеченной задаче
/// игнорируется (она в [ScheduleMarkState.doneKeys]/[pendingKeys]).
///
/// Время «сейчас» — из `clockProvider` (UTC), не `DateTime.now()` (FLUTTER.md
/// «Время»).

abstract class _$ScheduleMarkController extends $Notifier<ScheduleMarkState> {
  ScheduleMarkState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ScheduleMarkState, ScheduleMarkState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScheduleMarkState, ScheduleMarkState>,
              ScheduleMarkState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
