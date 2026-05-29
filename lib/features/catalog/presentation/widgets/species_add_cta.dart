import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Закреплённая снизу кнопка «Добавить в мой сад» с градиентом-подложкой
/// (по дизайну v5 — блок CTA). Фон кнопки `c.ink`, текст/иконка `c.surface`.
///
/// Подложка — вертикальный градиент от `bg` (низ) к прозрачному (верх), чтобы
/// CTA читалась поверх прокручиваемого контента. Высоту низа поднимает SafeArea
/// вызывающей стороны через [bottomInset].
class SpeciesAddCta extends StatelessWidget {
  const SpeciesAddCta({
    super.key,
    required this.onPressed,
    this.bottomInset = 0,
  });

  final VoidCallback onPressed;

  /// Дополнительный отступ снизу (системный safe-area).
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.bg.withValues(alpha: 0), c.bg],
          stops: const [0, 0.28],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 18 + bottomInset),
        child: Material(
          color: c.ink,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 20, color: c.surface),
                  const SizedBox(width: 10),
                  Text(
                    l10n.speciesAddToGarden,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.surface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
