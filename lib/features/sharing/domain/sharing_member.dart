import 'package:freezed_annotation/freezed_annotation.dart';

part 'sharing_member.freezed.dart';

/// Статус приглашения соухаживающего (экран 26).
///
/// Зеркалит `SharingStatus` из API. `unknown` — защита от новых значений
/// backend (forward-compatibility): UI рисует нейтральный бейдж, не падает.
enum SharingMemberStatus { pending, accepted, unknown }

/// Соухаживающий — приглашение, выпущенное текущим пользователем (владельцем).
///
/// Domain-модель (чистый Dart, MADR-002). DTO `SharingMemberDto` маппится сюда
/// руками в `data/mappers/` (MADR-007). [plantIds] — набор растений, на которые
/// распространяется приглашение; UI сопоставляет их с `homePlantsProvider`,
/// чтобы показать имена.
@freezed
abstract class SharingMember with _$SharingMember {
  const factory SharingMember({
    /// Идентификатор приглашения (membership).
    required int id,

    /// Контакт приглашённого (@username или телефон).
    required String contact,

    /// Статус приглашения.
    required SharingMemberStatus status,

    /// Может ли приглашённый отмечать уход за растениями набора.
    required bool canLogCare,

    /// Растения, на которые распространяется приглашение.
    required List<int> plantIds,
  }) = _SharingMember;
}
