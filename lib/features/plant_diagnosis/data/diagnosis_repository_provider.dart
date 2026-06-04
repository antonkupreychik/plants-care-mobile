import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_provider.dart';
import '../domain/diagnosis_repository.dart';
import 'diagnosis_repository_impl.dart';

part 'diagnosis_repository_provider.g.dart';

/// DI-точка для [DiagnosisRepository] (MADR-004: граф провайдеров = DI).
///
/// В тестах подменяется через
/// `diagnosisRepositoryProvider.overrideWith(...)`.
@riverpod
DiagnosisRepository diagnosisRepository(Ref ref) =>
    DiagnosisRepositoryImpl(ref.watch(plantsCareApiProvider));
