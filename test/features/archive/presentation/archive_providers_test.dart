import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/archive/data/archive_repository_provider.dart';
import 'package:plantcare_mobile/features/archive/domain/archive_repository.dart';
import 'package:plantcare_mobile/features/archive/domain/archive_view.dart';
import 'package:plantcare_mobile/features/archive/domain/archived_plant.dart';
import 'package:plantcare_mobile/features/archive/presentation/archive_providers.dart';

class _MockArchiveRepo extends Mock implements ArchiveRepository {}

const _view = ArchiveView(
  plants: [
    ArchivedPlant(
      id: 1,
      name: 'Алоэ Вера',
      speciesName: 'Алоэ',
      livedLabel: '11 месяцев',
      cause: 'Перелив',
      archivedDateLabel: 'апрель 2026',
    ),
  ],
  retrospective: ArchiveRetrospective(averageLivedLabel: '1 год 4 мес.'),
);

ProviderContainer _containerWith(ArchiveRepository repo) {
  final container = ProviderContainer(
    overrides: [archiveRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

/// Удерживает AutoDispose-провайдер живым подпиской и ждёт ошибки.
Future<Object?> _awaitError(ProviderContainer container) {
  final completer = Completer<Object?>();
  final sub = container.listen<AsyncValue<ArchiveView>>(
    archiveViewProvider,
    (_, next) {
      if (next.hasError && !completer.isCompleted) {
        completer.complete(next.error);
      }
    },
  );
  addTearDown(sub.close);
  return completer.future;
}

void main() {
  late _MockArchiveRepo repo;

  setUp(() => repo = _MockArchiveRepo());

  test('should_emit_AsyncData_with_view_when_repository_succeeds', () async {
    when(() => repo.getArchive())
        .thenAnswer((_) async => const Result.success(_view));
    final container = _containerWith(repo);

    final value = await container.read(archiveViewProvider.future);

    expect(value, _view);
  });

  test('should_emit_AsyncError_with_ApiError_when_repository_fails', () async {
    when(() => repo.getArchive())
        .thenAnswer((_) async => const Result.failure(ApiError.network()));
    final container = _containerWith(repo);

    final error = await _awaitError(container);

    expect(error, const ApiError.network());
  });
}
