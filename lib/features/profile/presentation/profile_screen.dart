import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository_provider.dart';
import 'widgets/settings_row.dart';

/// Экран «Профиль» (таб 4, branch `/profile`).
///
/// Экран настроек под дизайн-язык (`screens-v4.jsx`, блок «Ещё»): секция со
/// скруглением 22 и border `line`, внутри строки [SettingsRow]. Рабочие строки:
/// «Дома и места», «Архив», «Месячный отчёт», «Уведомления и время» (экран 23)
/// и деструктивная «Выйти» (выход из аккаунта, MADR-008). Прочие строки дизайна
/// (Язык, Тема) — вне объёма.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Подтверждение и выход: после `signOut` сбрасывается auth-статус, и
  /// router-guard (MADR-008) сам уводит на `/auth/welcome` — навигацию здесь не
  /// делаем (поэтому `context` после await не трогаем).
  Future<void> _confirmAndSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileSignOutConfirmTitle),
        content: Text(l10n.profileSignOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.profileSignOutConfirmCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.profileSignOutConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authRepositoryProvider).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 110),
          children: [
            Text(
              l10n.profileOverline.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: c.inkSoft,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.profileTitle,
              style: AppTheme.serif(fontSize: 40, color: c.ink),
            ),
            const SizedBox(height: 24),
            _SectionLabel(text: l10n.profileSectionMore),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: c.line),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SettingsRow(
                    title: l10n.profileRoomsTitle,
                    icon: Icons.home_outlined,
                    onTap: () => context.push('/profile/rooms'),
                  ),
                  // Экран 19 «Список покупок» → push поверх shell.
                  SettingsRow(
                    title: l10n.profileShoppingTitle,
                    icon: Icons.shopping_basket_outlined,
                    divider: true,
                    onTap: () => context.push('/profile/shopping'),
                  ),
                  SettingsRow(
                    title: l10n.profileArchiveTitle,
                    icon: Icons.inventory_2_outlined,
                    divider: true,
                    onTap: () => context.push('/profile/archive'),
                  ),
                  // Экран 14 «Месячный отчёт» → push поверх shell.
                  SettingsRow(
                    title: l10n.profileReportTitle,
                    icon: Icons.bar_chart_rounded,
                    divider: true,
                    onTap: () => context.push('/profile/report'),
                  ),
                  // Экран 23 «Тихие часы» (уведомления и время) → push поверх
                  // shell.
                  SettingsRow(
                    title: l10n.profileNotificationsTitle,
                    icon: Icons.notifications_none_rounded,
                    divider: true,
                    onTap: () => context.push('/profile/quiet-hours'),
                  ),
                  // Экран 38 «Язык приложения» → push поверх shell.
                  SettingsRow(
                    title: l10n.languageScreenTitle,
                    icon: Icons.language_outlined,
                    divider: true,
                    onTap: () => context.push('/profile/language'),
                  ),
                  // Справочник «Болезни и вредители» (issue #68) → push поверх
                  // shell.
                  SettingsRow(
                    title: l10n.diseaseCatalogTitle,
                    icon: Icons.bug_report_outlined,
                    divider: true,
                    onTap: () => context.push('/profile/diseases'),
                  ),
                  // Выход из аккаунта (MADR-008): сбрасывает токены/сессию,
                  // router-guard уводит на экран входа. Деструктивная строка.
                  SettingsRow(
                    title: l10n.profileSignOut,
                    icon: Icons.logout_rounded,
                    divider: true,
                    destructive: true,
                    onTap: () => _confirmAndSignOut(context, ref),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: c.inkSoft,
      ),
    );
  }
}
