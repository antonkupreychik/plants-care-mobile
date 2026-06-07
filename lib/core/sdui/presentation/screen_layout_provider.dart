import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../error/result.dart';
import '../data/sdui_repository_provider.dart';
import '../domain/sdui_screen_layout.dart';

part 'screen_layout_provider.g.dart';

/// State-слой SDUI главного экрана (MADR-015).
///
/// Отдаёт `AsyncValue<SduiScreenLayout>` (loading / error / data). В `AsyncError`
/// лежит типизированный `ApiError` (см. [_unwrap]) — UI маппит его в текст через
/// `AppLocalizations`, как остальные home-провайдеры.
///
/// Инвалидируется после успешного действия ухода (см. `ActionRunner`), чтобы
/// сервер пересобрал лейаут (`today_summary`, доступность действий).
@riverpod
Future<SduiScreenLayout> homeScreenLayout(Ref ref) async {
  final result = await ref.watch(sduiRepositoryProvider).getHomeLayout();
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
