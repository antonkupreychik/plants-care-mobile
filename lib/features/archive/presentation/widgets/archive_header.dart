import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../archive_screen.dart';

/// Шапка экрана «Архив»: кнопка «назад», eyebrow «Архив · N растений»,
/// серифный заголовок «В памяти» и подпись.
///
/// [count] null → eyebrow со счётчиком скрыт (loading/error, число неизвестно).
class ArchiveHeader extends StatelessWidget {
  const ArchiveHeader({super.key, this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ArchiveBackButton(label: l10n.archiveBack),
        const SizedBox(height: 14),
        if (count != null) ...[
          Text(
            l10n.archiveEyebrow(count!).toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
              color: c.inkSoft,
            ),
          ),
          const SizedBox(height: 6),
        ],
        const ArchiveHeading(),
        const SizedBox(height: 8),
        Text(
          l10n.archiveSubtitle,
          style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

class _ArchiveBackButton extends StatelessWidget {
  const _ArchiveBackButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          // Стек пуст (deep link) — уходим на /profile.
          onTap: () => context.canPop() ? context.pop() : context.go('/profile'),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
          ),
        ),
      ),
    );
  }
}
