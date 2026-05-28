import '../../../core/error/result.dart';
import 'archive_view.dart';

/// Контракт data-слоя экрана «Архив» (17) — список архивных/memorial-растений
/// пользователя.
///
/// Возвращает `Future<Result<T>>` и НЕ бросает наружу: доменная ошибка приходит
/// как [ApiError] в `Failure` (MADR-011). Presentation зависит только от этого
/// интерфейса (MADR-002) — реализация скрыта в data.
///
/// **Статус:** backend-эндпоинта пока нет (BACKEND-GAPS #117:
/// `GET /plants?status=archived` или `/archive` — в roadmap). Сейчас в проде
/// работает [FakeArchiveRepositoryImpl] (статичный мок). Когда backend отдаст
/// эндпоинт — добавится dio/codegen-реализация с маппингом DTO→domain и
/// `AuthScope.user` (растения пользователя); domain/state/UI не меняются —
/// перевешивается только `archiveRepositoryProvider`.
abstract interface class ArchiveRepository {
  /// Архив пользователя: список memorial-растений + ретроспектива
  /// (`GET /archive`, scope user — когда появится).
  Future<Result<ArchiveView>> getArchive();
}
