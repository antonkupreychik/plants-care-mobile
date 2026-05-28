import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/plant_illustration.dart';
import 'widgets/auth_primary_button.dart';

/// Экран 09 «С возвращением» — финал превью-флоу входа (визуальная заглушка).
///
/// Имя пользователя статично (`authWelcomeBackName`, заглушка). CTA «Добавить
/// первое растение» закрывает auth-флоу и уходит в мастер (`context.go`,
/// `/home/add`); вторичная ссылка «Я просто посмотрю» — на главную (`/home`).
/// Оба — `go`, т.к. выходим из превью-стека обратно в приложение.
class AuthWelcomeBackScreen extends StatelessWidget {
  const AuthWelcomeBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
                children: [
                  const _Avatar(),
                  const SizedBox(height: 16),
                  Text(
                    l10n.authWelcomeBackOverline.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.96,
                      color: c.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.authWelcomeBackTitle(l10n.authWelcomeBackName),
                    textAlign: TextAlign.center,
                    style: AppTheme.serif(fontSize: 40, color: c.ink),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      l10n.authWelcomeBackSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: c.inkSoft,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _PlantLineup(),
                  const SizedBox(height: 16),
                  const _FeatureChips(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
              child: Column(
                children: [
                  AuthPrimaryButton(
                    label: l10n.authAddFirstPlant,
                    icon: Icons.add_rounded,
                    onTap: () => context.go('/home/add'),
                  ),
                  const SizedBox(height: 8),
                  _GoHomeLink(label: l10n.authGoHome),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Аватар-плейсхолдер: кружок с инициалом + бейдж-галочка «привязано».
class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final initial = l10n.authWelcomeBackName.isNotEmpty
        ? l10n.authWelcomeBackName.characters.first
        : '?';

    return Center(
      child: SizedBox(
        width: 96,
        height: 96,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 92,
              height: 92,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.surface,
                shape: BoxShape.circle,
                border: Border.all(color: c.bg, width: 3),
              ),
              child: Text(
                initial,
                style: AppTheme.serif(fontSize: 40, color: c.primary),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: c.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.bg, width: 3),
                ),
                child: Icon(Icons.check_rounded, size: 14, color: c.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ряд растений-иллюстраций под приветствием.
class _PlantLineup extends StatelessWidget {
  const _PlantLineup();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PlantIllustration(speciesName: 'cactus', size: 90),
          PlantIllustration(speciesName: 'monstera', size: 130),
          PlantIllustration(speciesName: 'fern', size: 100),
        ],
      ),
    );
  }
}

/// Чипы «что внутри»: напоминания / дневник / календарь.
class _FeatureChips extends StatelessWidget {
  const _FeatureChips();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        _Chip(icon: Icons.notifications_none_rounded, label: l10n.authChipReminders),
        _Chip(icon: Icons.eco_outlined, label: l10n.authChipJournal),
        _Chip(icon: Icons.calendar_today_rounded, label: l10n.authChipCalendar),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// Вторичная ссылка «Я просто посмотрю» → на главную (выход из флоу).
class _GoHomeLink extends StatelessWidget {
  const _GoHomeLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => context.go('/home'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.inkSoft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
