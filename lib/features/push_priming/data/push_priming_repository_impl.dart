import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/push_priming_decision.dart';
import '../domain/push_priming_repository.dart';

/// Реализация [PushPrimingRepository] поверх [FlutterSecureStorage].
///
/// Ключ хранения: [_key] = `'push_priming_decision'`.
/// Ошибок хранения здесь нет — fallback к [PushPrimingDecision.notDecided]
/// при любом сбое чтения.
class PushPrimingRepositoryImpl implements PushPrimingRepository {
  const PushPrimingRepositoryImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const String _key = 'push_priming_decision';

  @override
  Future<PushPrimingDecision> getDecision() async {
    final value = await _storage.read(key: _key);
    return PushPrimingDecision.fromCode(value);
  }

  @override
  Future<void> saveDecision(PushPrimingDecision decision) async {
    // TODO(#47): после решения по push-стеку и backend #187 —
    // при allowed вызвать системный requestPermissions и
    // POST /api/v1/devices {pushToken, platform}.
    await _storage.write(key: _key, value: decision.code);
  }
}
