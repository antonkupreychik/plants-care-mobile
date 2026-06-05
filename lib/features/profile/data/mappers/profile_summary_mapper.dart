import '../../../../core/api/generated/models/me_response.dart';
import '../../domain/profile_summary.dart';

/// Маппинг `MeResponse` → domain [ProfileSummary] (MADR-002/007). Пишем руками —
/// сгенерированный код не правим.
///
/// Берёт «представительское» подмножество `/me`: `name`, `email`, `avatar`,
/// `createdAt`, `plantsTotal`.
///
/// [ProfileSummary.totalCareEvents] выставляется в `null`: счётчик «уходов за
/// всё время» ещё НЕ присутствует в `MeResponse` (ждёт plants-care#226). Когда
/// поле появится в схеме — добавим сюда одну строку, UI скрывает блок до тех
/// пор автоматически.
extension MeResponseProfileMapper on MeResponse {
  ProfileSummary toProfileSummary() => ProfileSummary(
        name: name,
        email: email,
        avatar: avatar,
        createdAt: createdAt,
        plantsTotal: plantsTotal,
        totalCareEvents: null,
      );
}
