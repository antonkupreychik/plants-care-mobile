import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/settings_row.dart';

/// Экран «Профиль» (таб 4, branch `/profile`).
///
/// МИНИМАЛЬНЫЙ экран настроек под дизайн-язык (`screens-v4.jsx`, блок «Ещё»):
/// секция со скруглением 22 и border `line`, внутри строки [SettingsRow].
/// В объёме — единственная рабочая строка «Дома и места» → push `/profile/rooms`
/// (управление комнатами). Прочие строки дизайна (Язык, Тема, Выйти и т.д.) —
/// вне объёма задачи и не добавлены.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  SettingsRow(
                    title: l10n.profileArchiveTitle,
                    icon: Icons.inventory_2_outlined,
                    divider: true,
                    onTap: () => context.push('/profile/archive'),
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
