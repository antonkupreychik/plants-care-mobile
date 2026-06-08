import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/plant_illustration.dart';
import '../../profile/domain/profile_summary.dart';
import '../../profile/presentation/profile_summary_provider.dart';
import 'widgets/auth_primary_button.dart';

/// Экран 09 «С возвращением» — пост-логин celebration после Telegram-входа.
///
/// Имя и аватар берутся из профиля (`GET /api/v1/me` через
/// [profileSummaryProvider]). Деградация мягкая: пока грузится — запасное имя и
/// initials-плейсхолдер, при ошибке — то же (вход не блокируем). CTA зависит от
/// числа растений: есть растения → «В мой сад» (`/home`), нет → «Добавить первое
/// растение» (`/home/add`); пока неизвестно — показываем «добавить» (онбординг
/// нового входа). Оба — `context.go` (выходим из auth-стека в приложение).
class AuthWelcomeBackScreen extends ConsumerWidget {
  const AuthWelcomeBackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(profileSummaryProvider);

    final ProfileSummary? profile = summary.value;
    // Имя: из профиля, иначе запасное (граница профиля недоступна → не блокируем).
    final name = (profile?.name?.trim().isNotEmpty ?? false)
        ? profile!.name!.trim()
        : l10n.authWelcomeBackName;
    // CTA: растения есть → в сад; нет/неизвестно → добавить первое.
    final hasPlants = (profile?.plantsTotal ?? 0) > 0;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
                children: [
                  _Avatar(name: name, avatarUrl: profile?.avatar),
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
                    l10n.authWelcomeBackTitle(name),
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
                    label: hasPlants
                        ? l10n.authGoToGarden
                        : l10n.authAddFirstPlant,
                    icon: hasPlants ? Icons.yard_outlined : Icons.add_rounded,
                    onTap: () =>
                        context.go(hasPlants ? '/home' : '/home/add'),
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

/// Аватар: фото из профиля (если есть), иначе кружок с инициалом имени +
/// бейдж-галочка «привязано». Сбой загрузки фото → initials-фолбэк.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final initial =
        name.trim().isNotEmpty ? name.characters.first.toUpperCase() : '?';

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
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: c.surface,
                shape: BoxShape.circle,
                border: Border.all(color: c.bg, width: 3),
              ),
              child: (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? Image.network(
                      avatarUrl!,
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _Initial(initial: initial),
                    )
                  : _Initial(initial: initial),
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

/// Инициал имени в центре аватара (плейсхолдер без фото).
class _Initial extends StatelessWidget {
  const _Initial({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Center(
      child: Text(
        initial,
        style: AppTheme.serif(fontSize: 40, color: c.primary),
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
