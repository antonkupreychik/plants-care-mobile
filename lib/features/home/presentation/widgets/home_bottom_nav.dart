import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Нижняя навигация (визуальная). go_router пока знает только `/home`, поэтому
/// активна вкладка «Сад», остальные инертны (тап → snackbar «скоро»).
/// Заменится `StatefulShellRoute` в следующих фичах.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key, required this.onComingSoon});

  final VoidCallback onComingSoon;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: c.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: l10n.navGarden,
            active: true,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.calendar_today_rounded,
            label: l10n.navSchedule,
            active: false,
            onTap: onComingSoon,
          ),
          _NavItem(
            icon: Icons.eco_outlined,
            label: l10n.navCatalog,
            active: false,
            onTap: onComingSoon,
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: l10n.navProfile,
            active: false,
            onTap: onComingSoon,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final fg = active ? c.primary : c.inkSoft;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Material(
        color: active ? c.primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minWidth: 56, minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: fg),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
