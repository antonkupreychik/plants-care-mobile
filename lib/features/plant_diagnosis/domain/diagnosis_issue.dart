import 'package:freezed_annotation/freezed_annotation.dart';

import 'diagnosis_severity.dart';

part 'diagnosis_issue.freezed.dart';

/// Одна выявленная проблема растения (источник — [DiagnosisIssueDto]).
///
/// Чистый Dart. [code] — семантический код для иконок/цветов в UI
/// (`UNDERWATERED`, `UNDERFED`, `LOW_HUMIDITY`, …); [title] — локализованный
/// заголовок, пришедший с backend (показываем как есть, l10n на клиенте
/// не нужна).
@freezed
abstract class DiagnosisIssue with _$DiagnosisIssue {
  const factory DiagnosisIssue({
    /// Семантический код проблемы (строка, не enum — forward-совместимость).
    required String code,

    /// Серьёзность проблемы.
    required DiagnosisSeverity severity,

    /// Человекочитаемый заголовок (локализован на стороне backend).
    required String title,
  }) = _DiagnosisIssue;
}
