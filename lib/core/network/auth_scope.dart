/// Выбор «головы» PoC-заголовка backend (MADR-006). До появления JWT
/// идентификация идёт двумя заголовками в зависимости от эндпоинта
/// (api-contract §3):
///
/// - [user] → `X-User-Id`: `/plants`, `/locations`
/// - [chat] → `X-Chat-Id`: `/today`, `/calendar`, `/care-events`,
///   `/plants/{id}/history`, `/stats/streak`
/// - [none] → публичные `/species`, `/care-types`, `/health`
///
/// Data source указывает scope на каждый запрос (см. `withAuthScope`),
/// интерсептор подставляет нужный заголовок. Дефолт — [none] (безопасно:
/// не утечёт чужой заголовок).
enum AuthScope { user, chat, none }
