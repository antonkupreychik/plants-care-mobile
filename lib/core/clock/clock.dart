/// Источник времени (FLUTTER.md «Время»). Логика не зовёт `DateTime.now()`
/// напрямую — берёт время через [Clock] (инжектится провайдером, тестируемо).
/// Сервер хранит UTC; клиент оперирует UTC, показывает в TZ юзера на уровне UI.
abstract interface class Clock {
  DateTime nowUtc();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}
