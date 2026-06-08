import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/plant_template.dart';
import '../plant_template_care_type_l10n.dart';

/// Карточка одного шаблона в списке.
///
/// Показывает имя, правила ухода (тип + интервал), кнопки действий:
/// «Создать растение» и «Удалить».
class PlantTemplateListTile extends StatelessWidget {
  const PlantTemplateListTile({
    super.key,
    required this.template,
    required this.onInstantiate,
    required this.onDelete,
  });

  final PlantTemplate template;
  final VoidCallback onInstantiate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bookmarks_rounded, size: 20, color: c.leaf),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  template.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.eco_rounded, size: 20, color: c.leaf),
                tooltip: l10n.plantTemplatesActionInstantiate,
                onPressed: onInstantiate,
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    size: 20, color: c.terracotta),
                tooltip: l10n.plantTemplatesActionDelete,
                onPressed: onDelete,
              ),
            ],
          ),
          if (template.careRules.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: template.careRules
                  .where(
                    (r) => r.careType != PlantTemplateCareType.unknown,
                  )
                  .map(
                    (r) => _CareRuleChip(
                      label: l10n.plantTemplatesCareRule(
                        l10n.careTypeName(r.careType),
                        r.intervalDays,
                      ),
                      color: c,
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}

class _CareRuleChip extends StatelessWidget {
  const _CareRuleChip({required this.label, required this.color});

  final String label;
  final PcColors color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.primarySoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color.leaf,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
