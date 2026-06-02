import 'package:flutter/foundation.dart';

/// Реактивный флаг аутентификации для router-guard (MADR-008).
///
/// Стабильный долгоживущий инстанс, который go_router слушает через
/// `refreshListenable`: при смене авторизации зовётся [notifyListeners] и
/// роутер перевычисляет `redirect`. Источник истины по токенам — [JwtAuthSession];
/// этот объект лишь дублирует булев флаг в форме [Listenable], чтобы не делать
/// сессию [ChangeNotifier] и не тянуть Flutter в auth-ядро.
///
/// Флипают флаг две точки: data-слой входа/выхода ([AuthRepositoryImpl]) и
/// `RefreshInterceptor.onSessionExpired` (невозвратный отказ refresh).
class AuthStatusNotifier extends ChangeNotifier {
  AuthStatusNotifier(this._isAuthenticated);

  bool _isAuthenticated;

  /// Текущее состояние авторизации (то, на что смотрит `redirect`).
  bool get isAuthenticated => _isAuthenticated;

  /// Устанавливает флаг и уведомляет слушателей ТОЛЬКО при реальном изменении
  /// (идемпотентно): лишние `notifyListeners` дёргали бы пересчёт redirect и
  /// потенциально ломали навигацию в полёте.
  void set(bool v) {
    if (_isAuthenticated == v) return;
    _isAuthenticated = v;
    notifyListeners();
  }
}
