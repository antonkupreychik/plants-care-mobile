/// Нужна ли запросу аутентификация (MADR-006/008). После перехода на JWT
/// (MADR-008) backend резолвит пользователя из `sub` access-токена, поэтому
/// [user] и [chat] больше не различаются — оба означают «слать
/// `Authorization: Bearer`». Историческое деление сохранено, чтобы не трогать
/// разметку запросов в репозиториях:
///
/// - [user] / [chat] → bearer: все пользовательские эндпоинты
///   (`/plants`, `/today`, `/calendar`, `/care-events`, `/me`, …)
/// - [none] → публичные `/species`, `/care-types`, `/health`, `/auth/**`
///
/// Data source указывает scope на каждый запрос (см. `withAuthScope`),
/// [JwtAuthSession] подставляет заголовок. Дефолт — [none] (безопасно: без
/// токена на публичные ручки).
enum AuthScope { user, chat, none }
