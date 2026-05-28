import 'package:freezed_annotation/freezed_annotation.dart';

part 'archived_plant.freezed.dart';

/// Растение из «Архива» (экран 17) — то, с которым «пути разошлись»:
/// погибло, подарено, отдано. Источник данных пока отсутствует на backend
/// (BACKEND-GAPS #117: `GET /plants?status=archived` / `/archive` — в roadmap),
/// поэтому модель спроектирована под дизайн-карточку, а не под DTO.
///
/// Чистый Dart: ни Flutter, ни Riverpod, ни presentation. Иллюстрацию
/// (`PlantArt`) подбирает UI по [speciesName] через `PlantArt.fromSpecies` —
/// domain не знает про ассеты/enum из presentation (FLUTTER.md: слои не текут).
///
/// Текстовые лейблы ([livedLabel], [archivedDateLabel]) приходят уже
/// отформатированными: интервалы/даты считает backend (как в правиле о времени —
/// клиент не пересчитывает). В фейке это просто готовые строки из дизайна;
/// в реальной реализации их сформирует backend либо маппер из посчитанных полей.
@freezed
abstract class ArchivedPlant with _$ArchivedPlant {
  const factory ArchivedPlant({
    /// Идентификатор растения (backend `id`).
    required int id,

    /// Кличка растения (напр. «Алоэ Вера», «Босс»).
    required String name,

    /// Вид растения (напр. «Алоэ», «Бонсай», «Папоротник»). По нему UI
    /// резолвит иллюстрацию через `PlantArt.fromSpecies`.
    required String speciesName,

    /// Готовый лейбл «сколько прожило рядом» (напр. «11 месяцев»,
    /// «3 года 2 мес.»). Форматирует backend, клиент не считает.
    required String livedLabel,

    /// Причина/заметка расставания (напр. «Перелив», «Подарили родителям»,
    /// «Сухой воздух»). Показывается в кавычках курсивом.
    required String cause,

    /// Готовый лейбл месяца архивации (напр. «апрель 2026»).
    required String archivedDateLabel,

    /// Растение подарено/отдано (а не погибло). Влияет на цвет точки (primary
    /// вместо terracotta) и склонение «Прожил» / «Прожило» в UI.
    @Default(false) bool gifted,
  }) = _ArchivedPlant;
}
