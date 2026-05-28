import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/plant_illustration.dart';
import 'widgets/auth_social_button.dart';

/// Экран 07 «Welcome / Войти» — ВИЗУАЛЬНАЯ ЗАГЛУШКА входа (превью-флоу).
///
/// Реального auth/сети/токена тут нет (см. задача auth-stubs). Кнопки:
/// «Google» / «гость» → coming-soon (SnackBar), «Telegram» → продолжение
/// превью-флоу на экран ввода кода (`/auth/code`). Кнопка «назад» уводит из
/// флоу обратно (в профиль), откуда экран и открыли.
class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    void comingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _BrandBar(),
            const _WelcomeIllustration(),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.authWelcomeOverline.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.96,
                      color: c.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.authWelcomeTitle,
                    style: AppTheme.serif(fontSize: 40, color: c.ink),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.authWelcomeSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: c.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 22),
                  AuthSocialButton(
                    label: l10n.authContinueGoogle,
                    icon: Icons.account_circle_outlined,
                    onTap: comingSoon,
                  ),
                  const SizedBox(height: 10),
                  AuthSocialButton(
                    label: l10n.authContinueTelegram,
                    icon: Icons.send_rounded,
                    accent: true,
                    onTap: () => context.push('/auth/code'),
                  ),
                  const SizedBox(height: 6),
                  const _OrDivider(),
                  const SizedBox(height: 6),
                  _GuestButton(label: l10n.authContinueGuest, onTap: comingSoon),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      l10n.authTerms,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: c.inkMute,
                      ),
                    ),
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

/// Верхняя плашка бренда: логотип + название + метка языка + кнопка «назад».
class _BrandBar extends StatelessWidget {
  const _BrandBar();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 28, 0),
      child: Row(
        children: [
          _BackButton(label: l10n.authBack),
          const SizedBox(width: 8),
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
            l10n.authBrand,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.17,
              color: c.ink,
            ),
          ),
          const Spacer(),
          Text(
            l10n.authLocale,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}

/// Иллюстрация-сад: монстера по центру с растениями вокруг (как в дизайне 07).
class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: const [
          Positioned(
            bottom: 0,
            child: PlantIllustration(speciesName: 'monstera', size: 200),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            child: PlantIllustration(speciesName: 'fern', size: 120),
          ),
          Positioned(
            bottom: 0,
            right: 24,
            child: PlantIllustration(speciesName: 'succulent', size: 110),
          ),
        ],
      ),
    );
  }
}

/// Разделитель «или» между основными способами входа и гостевым.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(child: Divider(color: c.line, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            l10n.authOr,
            style: TextStyle(fontSize: 12, color: c.inkSoft),
          ),
        ),
        Expanded(child: Divider(color: c.line, height: 1)),
      ],
    );
  }
}

/// Текстовая кнопка «Зайти как гость» (без фона).
class _GuestButton extends StatelessWidget {
  const _GuestButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Кнопка возврата в шапке (выход из превью-флоу обратно в профиль).
class _BackButton extends StatelessWidget {
  const _BackButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.canPop() ? context.pop() : context.go('/home'),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
          ),
        ),
      ),
    );
  }
}
