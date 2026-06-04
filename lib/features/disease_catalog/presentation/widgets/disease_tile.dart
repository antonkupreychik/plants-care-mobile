import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../domain/disease.dart';

/// Строка списка справочника болезней (issue #68): название + первые ~60
/// символов симптомов (превью). Тап открывает [Disease] деталь.
class DiseaseTile extends StatelessWidget {
  const DiseaseTile({super.key, required this.disease, required this.onTap});

  final Disease disease;
  final VoidCallback onTap;

  /// Длина превью симптомов в строке списка.
  static const int _previewLength = 60;

  String get _symptomsPreview {
    final s = disease.symptoms.trim();
    if (s.length <= _previewLength) return s;
    return '${s.substring(0, _previewLength).trimRight()}…';
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.line),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disease.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _symptomsPreview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: c.inkSoft,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, size: 20, color: c.inkMute),
            ],
          ),
        ),
      ),
    );
  }
}
