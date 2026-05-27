import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

/// Карточка описания вида (длинный текст). Содержимое — с backend, как пришло.
class SpeciesDescriptionCard extends StatelessWidget {
  const SpeciesDescriptionCard({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.all(18),
      child: Text(
        description,
        style: TextStyle(fontSize: 15, height: 1.5, color: c.ink),
      ),
    );
  }
}
