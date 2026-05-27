import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/tokens.dart';
import '../widgets/app_bottom_nav.dart';

/// Каркас табов (MADR-005): держит активный branch [StatefulNavigationShell]
/// и общую плавающую нижнюю навигацию overlay над ним.
///
/// Branch 0 — Сад (`/home`), branch 1 — График (`/schedule`), branch 2 —
/// Каталог (`/catalog`), branch 3 — Профиль (`/profile`).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Повторный тап по активному табу — возврат к initialLocation branch'а.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;

    return Scaffold(
      backgroundColor: c.bg,
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: AppBottomNav(
              currentIndex: navigationShell.currentIndex,
              onSelectGarden: () => _goBranch(0),
              onSelectSchedule: () => _goBranch(1),
              onSelectCatalog: () => _goBranch(2),
              onSelectProfile: () => _goBranch(3),
            ),
          ),
        ],
      ),
    );
  }
}
