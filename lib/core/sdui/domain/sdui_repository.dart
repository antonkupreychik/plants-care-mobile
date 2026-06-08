import '../../error/result.dart';
import 'sdui_screen_layout.dart';

/// Контракт data-слоя для SDUI-композиции экранов (MADR-015).
///
/// Возвращает `Future<Result<T>>` и НЕ бросает наружу (MADR-011). Реализация
/// скрыта в data, presentation зависит только от этого интерфейса (MADR-002).
abstract interface class SduiRepository {
  /// Лейаут главного экрана (`GET /api/v1/ui/home`, scope chat — тот же
  /// механизм идентификации, что у `/today`).
  ///
  /// Шлёт `X-UI-Catalog-Version` = [kUiCatalogVersion]. Нераспознанные типы
  /// блоков отфильтровываются здесь (forward-compatibility) — наружу уходит
  /// только то, что клиент умеет рендерить.
  Future<Result<SduiScreenLayout>> getHomeLayout();
}
