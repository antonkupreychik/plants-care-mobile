import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import 'decorative_leaves.dart';
import 'empty_pot_illustration.dart';
import 'starter_ideas.dart';

/// Пустое состояние таба «Сад» (экран 10 «Пустой сад»).
///
/// Обогащённый inline empty-state: карточка-приглашение (декоративные листья,
/// иллюстрация горшка, eyebrow, серифный заголовок, подпись, две кнопки) +
/// блок «Идеи на старт» под ней. Без хедера и bottom-nav — их даёт
/// [HomeScreen]. Чисто presentation, без данных backend.
class GardenEmpty extends StatelessWidget {
  const GardenEmpty({
    super.key,
    required this.onAdd,
    required this.onRecognizePhoto,
    required this.onOpenCatalog,
  });

  /// PRIMARY «Добавить растение» → мастер добавления (экран 04).
  final VoidCallback onAdd;

  /// SECONDARY «Распознать по фото» → coming soon.
  final VoidCallback onRecognizePhoto;

  /// Тап по стартовому виду → каталог.
  final VoidCallback onOpenCatalog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EmptyCard(onAdd: onAdd, onRecognizePhoto: onRecognizePhoto),
        const SizedBox(height: 18),
        StarterIdeas(onOpenCatalog: onOpenCatalog),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.onAdd, required this.onRecognizePhoto});

  final VoidCallback onAdd;
  final VoidCallback onRecognizePhoto;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: c.line),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            const DecorativeLeaves(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 18),
                      child: EmptyPotIllustration(size: 160),
                    ),
                  ),
                  Text(
                    l10n.homeGardenEmptyEyebrow.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.7,
                      color: c.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.homeGardenEmptyHeading,
                    textAlign: TextAlign.center,
                    style: AppTheme.serif(fontSize: 30, color: c.ink),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Text(
                        l10n.homeGardenEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: c.inkSoft,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: Text(l10n.homeAddPlant),
                    style: FilledButton.styleFrom(
                      backgroundColor: c.fab,
                      foregroundColor: c.fabInk,
                      minimumSize: const Size.fromHeight(52),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: onRecognizePhoto,
                    icon: const Icon(Icons.photo_camera_outlined, size: 18),
                    label: Text(l10n.homeRecognizeByPhoto),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: c.ink,
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: c.line),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
