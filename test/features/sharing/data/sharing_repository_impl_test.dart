import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plantcare_mobile/core/api/generated/clients/sharing_client.dart';
import 'package:plantcare_mobile/core/api/generated/models/sharing_invite_create_request.dart';
import 'package:plantcare_mobile/core/api/generated/models/sharing_member_dto.dart';
import 'package:plantcare_mobile/core/api/generated/models/sharing_members_response.dart';
import 'package:plantcare_mobile/core/api/generated/models/sharing_status.dart';
import 'package:plantcare_mobile/core/api/generated/plants_care_api.dart';
import 'package:plantcare_mobile/core/error/api_error.dart';
import 'package:plantcare_mobile/core/error/result.dart';
import 'package:plantcare_mobile/core/network/auth_scope.dart';
import 'package:plantcare_mobile/core/network/request_extra.dart';
import 'package:plantcare_mobile/features/sharing/data/sharing_repository_impl.dart';
import 'package:plantcare_mobile/features/sharing/domain/sharing_member.dart';

class _MockApi extends Mock implements PlantsCareApi {}

class _MockSharingClient extends Mock implements SharingClient {}

DioException _dioWith(Object? error) => DioException(
      requestOptions: RequestOptions(path: '/api/v1/sharing'),
      error: error,
    );

const _memberDto = SharingMemberDto(
  id: 1,
  contact: '@misha',
  status: SharingStatus.pending,
  canLogCare: true,
  plantIds: [10, 11],
);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const SharingInviteCreateRequest(plantIds: [1], inviteeContact: '@x'),
    );
  });

  late _MockApi api;
  late _MockSharingClient sharing;
  late SharingRepositoryImpl repo;

  setUp(() {
    api = _MockApi();
    sharing = _MockSharingClient();
    when(() => api.sharing).thenReturn(sharing);
    repo = SharingRepositoryImpl(api);
  });

  group('getMembers', () {
    test('should_return_success_with_mapped_members', () async {
      when(() => sharing.listSharingMembers(extras: any(named: 'extras')))
          .thenAnswer(
        (_) async => const SharingMembersResponse(members: [_memberDto]),
      );

      final result = await repo.getMembers();

      final list = (result as Success).value as List<SharingMember>;
      expect(list, hasLength(1));
      expect(list.first.contact, '@misha');
      expect(list.first.status, SharingMemberStatus.pending);
      expect(list.first.plantIds, [10, 11]);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => sharing.listSharingMembers(extras: any(named: 'extras')))
          .thenAnswer((_) async => const SharingMembersResponse(members: []));

      await repo.getMembers();

      final captured = verify(() =>
              sharing.listSharingMembers(extras: captureAny(named: 'extras')))
          .captured
          .single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_network_when_DioException_carries_it', () async {
      when(() => sharing.listSharingMembers(extras: any(named: 'extras')))
          .thenThrow(_dioWith(const ApiError.network()));

      final result = await repo.getMembers();

      expect((result as Failure).error, const ApiError.network());
    });

    test('should_return_failure_unknown_when_DioException_error_not_ApiError',
        () async {
      when(() => sharing.listSharingMembers(extras: any(named: 'extras')))
          .thenThrow(_dioWith('plain string'));

      final result = await repo.getMembers();

      expect((result as Failure).error, const ApiError.unknown());
    });
  });

  group('invite', () {
    test('should_return_success_and_pass_request_fields', () async {
      when(() => sharing.createSharingInvite(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _memberDto);

      final result = await repo.invite(
        plantIds: [10, 11],
        inviteeContact: '@misha',
        canLogCare: true,
      );

      expect(result, isA<Success<SharingMember>>());
      final body = verify(() => sharing.createSharingInvite(
            body: captureAny(named: 'body'),
            extras: any(named: 'extras'),
          )).captured.single as SharingInviteCreateRequest;
      expect(body.plantIds, [10, 11]);
      expect(body.inviteeContact, '@misha');
      expect(body.canLogCare, isTrue);
    });

    test('should_send_user_authScope_in_extras', () async {
      when(() => sharing.createSharingInvite(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenAnswer((_) async => _memberDto);

      await repo.invite(
        plantIds: [10],
        inviteeContact: '@x',
        canLogCare: false,
      );

      final captured = verify(() => sharing.createSharingInvite(
            body: any(named: 'body'),
            extras: captureAny(named: 'extras'),
          )).captured.single as Map<String, dynamic>;
      expect(captured[kAuthScopeExtraKey], AuthScope.user);
    });

    test('should_return_failure_badRequest_when_backend_rejects', () async {
      when(() => sharing.createSharingInvite(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.badRequest(message: 'empty')));

      final result = await repo.invite(
        plantIds: [10],
        inviteeContact: '',
        canLogCare: false,
      );

      expect((result as Failure).error,
          const ApiError.badRequest(message: 'empty'));
    });

    test('should_return_failure_notFound_when_plant_not_owned', () async {
      when(() => sharing.createSharingInvite(
            body: any(named: 'body'),
            extras: any(named: 'extras'),
          )).thenThrow(_dioWith(const ApiError.notFound()));

      final result = await repo.invite(
        plantIds: [999],
        inviteeContact: '@x',
        canLogCare: false,
      );

      expect((result as Failure).error, const ApiError.notFound());
    });
  });
}
