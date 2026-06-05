import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository_provider.dart';
import 'profile_summary_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_header_skeleton.dart';
import 'widgets/profile_stats.dart';
import 'widgets/settings_row.dart';

/// Экран «Я» (таб 4, branch `/profile`, экран 13).
///
/// Состав сверху вниз: шапка профиля (аватар/имя/email/«С нами с …») и блок
/// статистики из `profileSummary` (`GET /api/v1/me`); секция «Справочники»
/// (болезни и вредители, каталог видов); секция «Ещё» (навигация по настройкам)
/// с деструктивной строкой «Выйти».
///
/// Загрузка профиля: skeleton на время `profileSummary`; ошибка — тихая
/// деградация (шапка/статы скрыты, навигация остаётся рабочей).
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
    final summary = ref.watch(profileSummaryProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 110),
          children: [
            // Шапка + статистика. Тихая деградация на ошибке: блок скрыт,
            // секции навигации ниже остаются доступными.
            summary.when(
              loading: () => const ProfileHeaderSkeleton(),
              error: (error, stack) => const SizedBox.shrink(),
              data: (s) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(summary: s),
                  const SizedBox(height: 20),
                  ProfileStats(summary: s),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Секция «Справочники».
            _SectionLabel(text: l10n.profileSectionReferences),
            const SizedBox(height: 10),
            _SectionCard(
              children: [
                // Болезни и вредители → экран #68 (push поверх shell).
                SettingsRow(
                  title: l10n.profileDiseasesTitle,
                  icon: Icons.coronavirus_outlined,
                  onTap: () => context.push('/profile/diseases'),
                ),
                // Каталог видов → переключение на таб «Каталог».
                SettingsRow(
                  title: l10n.profileCatalogTitle,
                  icon: Icons.eco_outlined,
                  divider: true,
                  onTap: () => context.go('/catalog'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Секция «Ещё».
            _SectionLabel(text: l10n.profileSectionMore),
            const SizedBox(height: 10),
            _SectionCard(
              children: [
                // Поиск → экран #69 (push поверх shell).
                SettingsRow(
                  title: l10n.profileSearchTitle,
                  icon: Icons.search_rounded,
                  onTap: () => context.push('/search'),
                ),
                SettingsRow(
                  title: l10n.profileRoomsTitle,
                  icon: Icons.home_outlined,
                  divider: true,
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
                // Экран 25 «Режим отпуска» → push поверх shell.
                SettingsRow(
                  title: l10n.profileVacationTitle,
                  icon: Icons.beach_access_outlined,
                  divider: true,
                  onTap: () => context.push('/profile/vacation'),
                ),
                // Экран 35 «Сезонные интервалы» → push поверх shell.
                SettingsRow(
                  title: l10n.profileSeasonalTitle,
                  icon: Icons.wb_sunny_outlined,
                  divider: true,
                  onTap: () => context.push('/profile/seasonal'),
                ),
                // Экран 38 «Язык приложения» → push поверх shell.
                SettingsRow(
                  title: l10n.languageScreenTitle,
                  icon: Icons.language_outlined,
                  divider: true,
                  onTap: () => context.push('/profile/language'),
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
          ],
        ),
      ),
    );
  }
}

/// Плашка-секции со скруглением 22 и border `line`; внутри — строки
/// [SettingsRow], разделённые их собственными `divider`.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
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
