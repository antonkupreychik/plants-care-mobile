import 'package:freezed_annotation/freezed_annotation.dart';

import 'archived_plant.dart';

part 'archive_view.freezed.dart';

/// Агрегат данных экрана «Архив» (17) — то, что репозиторий отдаёт UI одним
/// куском: список архивных/memorial-растений плюс опциональная ретроспектива.
///
/// Чистый Dart. Пустой случай: [plants] пуст → [retrospective] `null`
/// (карточка ретроспективы скрыта). UI рисует empty-state по `plants.isEmpty`.
@freezed
abstract class ArchiveView with _$ArchiveView {
  const factory ArchiveView({
    /// Архивные растения в порядке показа (как пришли с backend).
    required List<ArchivedPlant> plants,

    /// Сводка «Ретроспектива». `null`, если архив пуст (нечего обобщать).
    ArchiveRetrospective? retrospective,
  }) = _ArchiveView;
}

/// Сводка по архиву для карточки «Ретроспектива» (низ экрана 17).
///
/// [averageLivedLabel] — готовый лейбл среднего срока жизни растений рядом
/// (напр. «1 год 4 мес.»). Считает backend, клиент не агрегирует сам.
@freezed
abstract class ArchiveRetrospective with _$ArchiveRetrospective {
  const factory ArchiveRetrospective({
    required String averageLivedLabel,
  }) = _ArchiveRetrospective;
}
