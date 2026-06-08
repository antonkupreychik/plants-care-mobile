import 'package:freezed_annotation/freezed_annotation.dart';

part 'sdui_action.freezed.dart';

/// Тип SDUI-действия (`ActionDescriptor.kind`). Клиент сопоставляет его с
/// нативным обработчиком (`ActionRunner`). Нераспознанный backend-код → [unknown]
/// (UI не выполняет действие, но и не падает — graceful degradation).
enum SduiActionKind {
  /// `log_care` — отметить уход (переиспользует care-event флоу).
  logCare,

  /// `navigate` — перейти на маршрут (`target`) через go_router.
  navigate,

  /// Нераспознанный/новый вид действия — клиент его не исполняет.
  unknown;

  /// Маппинг строкового `kind` backend в [SduiActionKind]. Неизвестное значение
  /// (контракт мог добавить вид) → [unknown], не бросаем.
  static SduiActionKind fromApi(String? raw) => switch (raw) {
        'log_care' => SduiActionKind.logCare,
        'navigate' => SduiActionKind.navigate,
        _ => SduiActionKind.unknown,
      };
}

/// Доменное описание действия SDUI (`ActionDescriptor` → domain, MADR-015).
///
/// Чистый Dart, иммутабельно. Декларативное «что отправить на backend»:
/// `ActionRunner` сопоставляет [kind] с нативным флоу (для [SduiActionKind.logCare]
/// — существующий care-event репозиторий), а [method]/[path]/[payload] оставляет
/// как метаданные. Клиент НЕ изобретает новый сетевой путь под действие —
/// исполняет его через уже существующий типизированный флоу фичи (FLUTTER.md:
/// «новый эндпоинт сперва на бэкенде»).
@freezed
abstract class SduiAction with _$SduiAction {
  const factory SduiAction({
    /// Вид действия (по нему выбирается обработчик).
    required SduiActionKind kind,

    /// HTTP-метод из дескриптора (метаданные; нативный флоу знает свой путь).
    /// Для [SduiActionKind.navigate] не используется — пустая строка.
    @Default('') String method,

    /// Относительный путь из дескриптора (метаданные).
    /// Для [SduiActionKind.navigate] не используется — пустая строка.
    @Default('') String path,

    /// Маршрут навигации для [SduiActionKind.navigate] (`target`, напр.
    /// `/plants/10` или `/home/register`). `null` для не-навигационных действий.
    String? target,

    /// Шаблон тела запроса (свободная форма). Для `log_care` — `plantId`/`type`.
    Map<String, dynamic>? payload,

    /// Логические ключи чтений, которые надо инвалидировать после успеха
    /// (декларативная инвалидация, MADR-017): `home`/`today`/`plant`.
    /// `ActionRunner` маппит каждый ключ в провайдер. Отсутствует → пустой.
    @Default(<String>[]) List<String> invalidates,
  }) = _SduiAction;
}
