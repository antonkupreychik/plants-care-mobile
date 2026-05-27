import '../../../../core/api/generated/models/streak_response.dart';
import '../../domain/streak.dart';

/// Маппинг [StreakResponse] (`/stats/streak`) → domain [Streak] (MADR-002).
///
/// `streak` (DTO) → `count` (domain): значение посчитано backend, клиент его
/// не пересчитывает (FLUTTER.md «Время и таймзоны»).
extension StreakResponseMapper on StreakResponse {
  Streak toDomain() => Streak(
        plantId: plantId,
        count: streak,
      );
}
