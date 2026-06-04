import 'dart:async';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Провайдер статуса сети: `true` — онлайн, `false` — офлайн.
///
/// Реализован через периодический DNS-запрос (`dart:io`) без внешних пакетов.
/// Первое значение эмитируется до первого тика таймера (ранний снапшот при
/// монтировании), затем — каждые [_pollInterval].
///
/// Используется [HomeScreen] через `ref.listen` для авто-рефетча при
/// восстановлении сети (offline → online переход).
@riverpod
Stream<bool> connectivity(Ref ref) async* {
  yield await _checkOnline();

  await for (final _ in Stream<void>.periodic(_pollInterval)) {
    yield await _checkOnline();
  }
}

const _pollInterval = Duration(seconds: 5);

/// Возвращает `true`, если DNS-резолвер отвечает.
/// Любая ошибка или таймаут → `false`.
Future<bool> _checkOnline() async {
  try {
    final result = await InternetAddress.lookup('dns.google')
        .timeout(const Duration(seconds: 4));
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
