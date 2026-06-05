import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/features/sharing/data/sharing_repository_provider.dart';
import 'package:plantcare_mobile/features/sharing/domain/sharing_member.dart';
import 'package:plantcare_mobile/features/sharing/domain/sharing_repository.dart';
import 'package:plantcare_mobile/features/sharing/presentation/sharing_controller.dart';

class _MockSharingRepo extends Mock implements SharingRepository {}

const _misha = SharingMember(
  id: 1,
  contact: '@misha',
  status: SharingMemberStatus.pending,
  canLogCare: true,
  plantIds: [10, 11],
);

const _lena = SharingMember(
  id: 2,
  contact: '@lena',
  status: SharingMemberStatus.pending,
  canLogCare: false,
  plantIds: [12],
);

ProviderContainer _container(_MockSharingRepo repo) {
  final container = ProviderContainer(
    overrides: [sharingRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  late _MockSharingRepo repo;

  setUp(() => repo = _MockSharingRepo());

  group('initial load', () {
    test('should_expose_list_when_repo_returns_success', () async {
      when(repo.getMembers)
          .thenAnswer((_) async => const Result.success([_misha]));
      final container = _container(repo);

      final list = await container.read(sharingControllerProvider.future);

      expect(list, [_misha]);
    });

    test('should_expose_AsyncError_with_ApiError_when_repo_fails', () async {
      when(repo.getMembers)
          .thenAnswer((_) async => const Result.failure(ApiError.network()));
      final container = _container(repo);

      final states = <AsyncValue<List<SharingMember>>>[];
      final sub = container.listen(
        sharingControllerProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      addTearDown(sub.close);
      expect(states.first.isLoading, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(sharingControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, const ApiError.network());
    });
  });

  group('invite', () {
    test('should_return_success_and_refetch_list', () async {
      var calls = 0;
      when(repo.getMembers).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const Result.success([_misha])
            : const Result.success([_misha, _lena]);
      });
      when(() => repo.invite(
            plantIds: any(named: 'plantIds'),
            inviteeContact: any(named: 'inviteeContact'),
            canLogCare: any(named: 'canLogCare'),
          )).thenAnswer((_) async => const Result.success(_lena));
      final container = _container(repo);
      await container.read(sharingControllerProvider.future);

      final result = await container
          .read(sharingControllerProvider.notifier)
          .invite(plantIds: [12], inviteeContact: '@lena', canLogCare: false);

      expect(result, isA<Success<SharingMember>>());
      expect((result as Success).value, _lena);
      expect(container.read(sharingControllerProvider).value, [_misha, _lena]);
      verify(repo.getMembers).called(2);
    });

    test('should_forward_invite_arguments_to_repo', () async {
      when(repo.getMembers)
          .thenAnswer((_) async => const Result.success([]));
      when(() => repo.invite(
            plantIds: any(named: 'plantIds'),
            inviteeContact: any(named: 'inviteeContact'),
            canLogCare: any(named: 'canLogCare'),
          )).thenAnswer((_) async => const Result.success(_misha));
      final container = _container(repo);
      await container.read(sharingControllerProvider.future);

      await container.read(sharingControllerProvider.notifier).invite(
        plantIds: [10, 11],
        inviteeContact: '@misha',
        canLogCare: true,
      );

      verify(() => repo.invite(
            plantIds: [10, 11],
            inviteeContact: '@misha',
            canLogCare: true,
          )).called(1);
    });

    test('should_return_failure_and_not_refetch_when_repo_fails', () async {
      when(repo.getMembers)
          .thenAnswer((_) async => const Result.success([_misha]));
      when(() => repo.invite(
            plantIds: any(named: 'plantIds'),
            inviteeContact: any(named: 'inviteeContact'),
            canLogCare: any(named: 'canLogCare'),
          )).thenAnswer(
        (_) async => const Result.failure(ApiError.badRequest(message: 'empty')),
      );
      final container = _container(repo);
      await container.read(sharingControllerProvider.future);

      final result = await container
          .read(sharingControllerProvider.notifier)
          .invite(plantIds: [], inviteeContact: '@x', canLogCare: false);

      expect(result, isA<Failure<SharingMember>>());
      // Только начальная загрузка — рефетча не было (мутация неуспешна).
      verify(repo.getMembers).called(1);
    });
  });
}
