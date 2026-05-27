import '../../../l10n/app_localizations.dart';
import '../../plant_card/domain/care_event_kind.dart';

/// UI-обвязка для выбора [CareEventKind] в sheet отметки ухода: подпись-глагол
/// действия («Полить»/«Опрыскать»/«Удобрить»), в отличие от
/// `CareEventKindL10n.doneLabel` («Полито»/«Опрыскано»), который описывает уже
/// выполненный уход в дневнике.
///
/// Без бизнес-логики — только перевод enum в строку (иконка берётся из
/// `CareEventKindL10n.icon`). `unknown` в sheet не предлагается, но даём
/// нейтральный fallback, чтобы не падать.
extension CareEventKindActionL10n on CareEventKind {
  String actionLabel(AppLocalizations l10n) => switch (this) {
        CareEventKind.water => l10n.careKindWater,
        CareEventKind.spray => l10n.careKindSpray,
        CareEventKind.fertilize => l10n.careKindFertilize,
        CareEventKind.unknown => l10n.careActionUnknown,
      };
}
