import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/result.dart';
import '../data/profile_repository_provider.dart';
import '../domain/profile_summary.dart';

part 'profile_summary_provider.g.dart';

/// Сводка профиля для шапки и статистики экрана «Я» (`GET /api/v1/me`).
///
/// `AsyncValue` даёт экрану три состояния: loading (skeleton), error (тихая
/// деградация — шапка/статы скрыты, навигация работает), data. На ошибке
/// бросаем [ApiError] из [Result.failure], чтобы попасть в ветку
/// `AsyncValue.error` — экран её не показывает баннером, а просто прячет блок.
@riverpod
Future<ProfileSummary> profileSummary(Ref ref) async {
  final result = await ref.watch(profileRepositoryProvider).getSummary();
  return switch (result) {
    Success(:final value) => value,
    Failure(:final error) => throw error,
  };
}
