import '../../../core/error/result.dart';
import '../domain/archive_repository.dart';
import '../domain/archive_view.dart';
import '../domain/archived_plant.dart';

/// TODO(BACKEND-GAPS #117): заглушка до появления эндпоинта архива
/// (`GET /plants?status=archived` / `/archive`). Заменить на dio/codegen-
/// реализацию с маппингом DTO→domain и `AuthScope.user`; domain/state/UI при
/// этом НЕ меняются — перевешивается только `archiveRepositoryProvider`.
///
/// Возвращает захардкоженный [ArchiveView] из дизайна (screens-v4.jsx,
/// ArchiveScreen). Искусственная задержка 300 мс — чтобы loading-state UI был
/// реально наблюдаем. Никаких сетевых вызовов.
class FakeArchiveRepositoryImpl implements ArchiveRepository {
  const FakeArchiveRepositoryImpl();

  static const Duration _fakeLatency = Duration(milliseconds: 300);

  @override
  Future<Result<ArchiveView>> getArchive() async {
    await Future<void>.delayed(_fakeLatency);
    return const Result.success(
      ArchiveView(
        plants: [
          ArchivedPlant(
            id: 1,
            name: 'Алоэ Вера',
            speciesName: 'Алоэ',
            livedLabel: '11 месяцев',
            cause: 'Перелив',
            archivedDateLabel: 'апрель 2026',
          ),
          ArchivedPlant(
            id: 2,
            name: 'Босс',
            speciesName: 'Бонсай',
            livedLabel: '3 года 2 мес.',
            cause: 'Подарили родителям',
            archivedDateLabel: 'март 2026',
            gifted: true,
          ),
          ArchivedPlant(
            id: 3,
            name: 'Пушистик',
            speciesName: 'Папоротник',
            livedLabel: '4 месяца',
            cause: 'Сухой воздух',
            archivedDateLabel: 'январь 2026',
          ),
        ],
        retrospective: ArchiveRetrospective(
          averageLivedLabel: '1 год 4 мес.',
        ),
      ),
    );
  }
}
