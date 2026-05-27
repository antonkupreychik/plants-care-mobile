import 'package:freezed_annotation/freezed_annotation.dart';

import 'api_error.dart';

part 'result.freezed.dart';

/// Результат операции data/domain (MADR-011). Репозитории и use cases
/// возвращают `Future<Result<T>>` и НЕ бросают наружу — ошибка видна в типе.
@freezed
sealed class Result<T> with _$Result<T> {
  const Result._();

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(ApiError error) = Failure<T>;

  bool get isSuccess => this is Success<T>;

  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Failure<T>() => null,
      };
}
