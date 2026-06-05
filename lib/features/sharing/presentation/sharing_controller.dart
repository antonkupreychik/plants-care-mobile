import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/sharing_repository_provider.dart';
import '../domain/sharing_member.dart';

part 'sharing_controller.g.dart';

/// State-слой фичи «Совместный уход» (экран 26).
///
/// Список соухаживающих — `AsyncValue<List<SharingMember>>` (loading / error /
/// data); в `AsyncError` лежит типизированный `ApiError` (репозиторий вернул
/// `Failure`, разворачиваем броском). UI читает через
/// `ref.watch(sharingControllerProvider)`.
///
/// Контракт для ui-builder — [invite] возвращает `Future<Result<SharingMember>>`
/// (НЕ `void`, FLUTTER.md: ошибку не глотаем). UI матчит
/// `Success`/`Failure(:final error)` и рисует баннер/тост по типу `ApiError`
/// через `AppLocalizations`. На успех список рефетчится (новое приглашение
/// появляется со статусом `PENDING`).
@riverpod
class SharingController extends _$SharingController {
  @override
  Future<List<SharingMember>> build() async {
    final result = await ref.watch(sharingRepositoryProvider).getMembers();
    return switch (result) {
      Success(:final value) => value,
      Failure(:final error) => throw error,
    };
  }

  /// Пригласить соухаживающего. На успех — рефетч списка.
  ///
  /// [plantIds] — минимум одно растение, [inviteeContact] — непустой контакт
  /// (валидацию формы делает UI; здесь — сквозной вызов). Backend вернёт 400
  /// при пустом наборе/контакте и 404, если растение не принадлежит юзеру.
  Future<Result<SharingMember>> invite({
    required List<int> plantIds,
    required String inviteeContact,
    required bool canLogCare,
  }) async {
    final result = await ref.read(sharingRepositoryProvider).invite(
          plantIds: plantIds,
          inviteeContact: inviteeContact,
          canLogCare: canLogCare,
        );
    if (result is Success<SharingMember>) await _refresh();
    return result;
  }

  /// Перечитать список соухаживающих (loading → data/error).
  Future<void> _refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(sharingRepositoryProvider).getMembers();
      return switch (result) {
        Success(:final value) => value,
        Failure(:final error) => throw error,
      };
    });
  }
}
