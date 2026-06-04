import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/api_error.dart';
import '../../../core/network/connectivity_provider.dart';
import 'home_providers.dart';

part 'home_view_state.g.dart';

/// Top-level состояние экрана «Главная» поверх посекционной логики (экраны
/// 28 — скелетон холодного старта, 29 — полноэкранный офлайн).
///
/// - [coldLoading] — полноэкранный скелетон (28);
/// - [offline] — полноэкранный офлайн (29);
/// - [content] — обычный экран, дальше работает посекционная логика
///   (skeleton/ErrorState внутри каждой секции).
enum HomeViewState { coldLoading, offline, content }

/// Derived-состояние верхнего уровня для Home.
///
/// Ключуется **только** на [homePlantsProvider] — первичном контенте сада.
/// Намеренно НЕ смотрим на tasks/locations: иначе полноэкранный скелетон/офлайн
/// «залипал» бы из-за медленной или упавшей вторичной секции, хотя сад уже
/// готов к показу. Состояние вторичных секций отрисовывается посекционно
/// внутри `content`.
///
/// Правила переходов (по `AsyncValue<List<Plant>>` из [homePlantsProvider]):
/// - [coldLoading] — первичная загрузка без данных:
///   `isLoading && !hasValue`;
/// - [offline] — сетевая ошибка без закэшированного значения:
///   `hasError && !hasValue && error is NetworkError`;
/// - [content] — всё остальное: есть данные (в т.ч. рефреш поверх кэша или
///   ошибка при наличии кэша), либо не-сетевая ошибка без данных — её покажет
///   посекционный ErrorState.
///
/// Побочный эффект: подписывается на [connectivityProvider] и при переходе
/// offline → online автоматически инвалидирует все home-провайдеры (авто-рефетч,
/// аналог `onlineManager.setEventListener` из React Query).
@riverpod
HomeViewState homeViewState(Ref ref) {
  // Авто-рефетч при восстановлении сети: слушаем поток connectivity и при
  // переходе false → true инвалидируем home-провайдеры.
  ref.listen<AsyncValue<bool>>(connectivityProvider, (previous, next) {
    final wasOnline = previous?.value ?? true; // optimistic default
    final isNowOnline = next.value ?? false;
    if (!wasOnline && isNowOnline) {
      ref.invalidate(homePlantsProvider);
      ref.invalidate(homeTasksProvider);
      ref.invalidate(homeLocationsProvider);
    }
  });

  final plants = ref.watch(homePlantsProvider);

  if (plants.isLoading && !plants.hasValue) {
    return HomeViewState.coldLoading;
  }
  if (plants.hasError && !plants.hasValue && plants.error.isNetworkError) {
    return HomeViewState.offline;
  }
  return HomeViewState.content;
}

/// Отличает сетевую ошибку ([NetworkError]) от прочих [ApiError]/любого объекта.
/// Удобно для ui-builder при ветвлении полноэкранный офлайн vs ErrorState.
extension IsNetworkError on Object? {
  bool get isNetworkError => this is NetworkError;
}
