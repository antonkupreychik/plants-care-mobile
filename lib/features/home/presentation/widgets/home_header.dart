import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Шапка главного: логотип-лист + название слева, иконки поиск/уведомления
/// справа, ниже — дата и серифное приветствие (без имени пользователя —
/// провайдера профиля пока нет, см. отчёт).
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.now, required this.onComingSoon});

  final DateTime now;
  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final dateLabel = DateFormat.MMMMEEEEd(l10n.localeName).format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.eco_rounded, size: 20, color: c.surface),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.appTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                color: c.ink,
              ),
            ),
            const Spacer(),
            _HeaderIconButton(
              icon: Icons.search_rounded,
              tooltip: l10n.homeSearchTooltip,
              onPressed: onComingSoon,
            ),
            const SizedBox(width: 6),
            _HeaderIconButton(
              icon: Icons.notifications_none_rounded,
              tooltip: l10n.homeNotificationsTooltip,
              onPressed: onComingSoon,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          dateLabel.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.homeGreeting,
          style: AppTheme.serif(
            fontSize: 38,
            fontStyle: FontStyle.italic,
            color: c.primary,
          ),
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(icon, size: 20, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}
