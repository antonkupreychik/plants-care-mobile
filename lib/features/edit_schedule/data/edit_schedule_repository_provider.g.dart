// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_schedule_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI-точка для [EditScheduleRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `editScheduleRepositoryProvider.overrideWith(...)`.

@ProviderFor(editScheduleRepository)
final editScheduleRepositoryProvider = EditScheduleRepositoryProvider._();

/// DI-точка для [EditScheduleRepository] (MADR-004: граф провайдеров = DI).
/// В тестах подменяется через `editScheduleRepositoryProvider.overrideWith(...)`.

final class EditScheduleRepositoryProvider
    extends
        $FunctionalProvider<
          EditScheduleRepository,
          EditScheduleRepository,
          EditScheduleRepository
        >
    with $Provider<EditScheduleRepository> {
  /// DI-точка для [EditScheduleRepository] (MADR-004: граф провайдеров = DI).
  /// В тестах подменяется через `editScheduleRepositoryProvider.overrideWith(...)`.
  EditScheduleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editScheduleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editScheduleRepositoryHash();

  @$internal
  @override
  $ProviderElement<EditScheduleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EditScheduleRepository create(Ref ref) {
    return editScheduleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditScheduleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditScheduleRepository>(value),
    );
  }
}

String _$editScheduleRepositoryHash() =>
    r'd1c13acb6369c3076d9a880dd5a950ea1d476930';
