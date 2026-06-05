import '../../../../core/api/generated/models/vacation_response.dart';
import '../../domain/vacation_status.dart';

/// Маппинг DTO ↔ domain для фичи «Режим отпуска» (MADR-007: сгенерированные DTO
/// не правим, маппинг руками и покрыт тестом).
extension VacationResponseMapper on VacationResponse {
  /// `VacationResponse` → доменный [VacationStatus]. `pausedUntil` приходит как
  /// UTC `date-time` (или `null`) — пробрасываем как есть, клиент не
  /// пересчитывает (FLUTTER.md «Время»).
  VacationStatus toVacationStatus() => VacationStatus(
        active: active,
        pausedUntil: pausedUntil,
      );
}
