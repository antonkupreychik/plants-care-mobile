import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/tokens.dart';

/// Плавающая нижняя навигация приложения (MADR-005).
///
/// Визуальный контейнер с 4 табами (Сад / График / Каталог / Профиль). Живёт
/// overlay над активным branch'ем в `AppShell`. Активный таб определяется
/// [currentIndex] (= `StatefulNavigationShell.currentIndex`).
///
/// Сад/График навигируют по branch'ам ([onSelectGarden]/[onSelectSchedule]),
/// Каталог/Профиль ещё не реализованы — тап вызывает [onComingSoon].
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelectGarden,
    required this.onSelectSchedule,
    required this.onComingSoon,
  });

  /// Индекс активного branch'а (0 — Сад, 1 — График).
  final int currentIndex;
  final VoidCallback onSelectGarden;
  final VoidCallback onSelectSchedule;
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
            active: currentIndex == 0,
            onTap: onSelectGarden,
          ),
          _NavItem(
            icon: Icons.calendar_today_rounded,
            label: l10n.navSchedule,
            active: currentIndex == 1,
            onTap: onSelectSchedule,
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
