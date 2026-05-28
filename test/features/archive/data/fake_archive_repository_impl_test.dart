import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/archive/data/fake_archive_repository_impl.dart';
import 'package:plantcare_mobile/features/archive/domain/archive_view.dart';

void main() {
  group('FakeArchiveRepositoryImpl.getArchive', () {
    late FakeArchiveRepositoryImpl repo;

    setUp(() => repo = const FakeArchiveRepositoryImpl());

    test('should_return_success_with_three_plants_and_retrospective_when_called',
        () async {
      final result = await repo.getArchive();

      expect(result, isA<Success<ArchiveView>>());
      final view = (result as Success<ArchiveView>).value;
      expect(view.plants, hasLength(3));
      expect(view.retrospective, isNotNull);
      expect(view.retrospective!.averageLivedLabel, isNotEmpty);
    });

    test('should_include_gifted_and_non_gifted_plants_matching_design',
        () async {
      final result = await repo.getArchive();

      final view = (result as Success<ArchiveView>).value;
      // «Босс» — подарен (gifted=true): влияет на склонение «Прожил» и цвет точки.
      final boss = view.plants.firstWhere((p) => p.name == 'Босс');
      expect(boss.gifted, isTrue);
      // «Алоэ Вера» — погибло (gifted=false).
      final aloe = view.plants.firstWhere((p) => p.name == 'Алоэ Вера');
      expect(aloe.gifted, isFalse);
      // В наборе есть оба класса растений (для проверки обеих веток UI).
      expect(view.plants.any((p) => p.gifted), isTrue);
      expect(view.plants.any((p) => !p.gifted), isTrue);
    });
  });
}
