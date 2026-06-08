import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/plant_illustration.dart';
import 'auth_guest_controller.dart';
import 'auth_social_controller.dart';
import 'auth_social_state.dart';
import 'widgets/auth_brand_bar.dart';
import 'widgets/auth_social_button.dart';

/// Экран 07 «Welcome / Войти».
///
/// Социальный вход (Google — обе платформы, Apple — только iOS) проводится
/// через `authSocialControllerProvider`: по нажатию — `google()` / `apple()`,
/// по успеху навигацию делает router-guard (сессия поднята), отмена ошибку не
/// ставит. Email-кнопка ведёт на `/auth/email`, «гость» — через
/// [authGuestControllerProvider] запускает `POST /auth/guest`.
class AuthWelcomeScreen extends ConsumerWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    final socialState = ref.watch(authSocialControllerProvider);
    final socialController = ref.read(authSocialControllerProvider.notifier);
    final guestState = ref.watch(authGuestControllerProvider);
    final guestController = ref.read(authGuestControllerProvider.notifier);

    // Кнопки заблокированы, если идёт любой запрос (social или guest).
    final isBusy = socialState.isBusy || guestState.isLoading;

    // Показываем ошибку гостевого входа через snackbar.
    ref.listen(authGuestControllerProvider, (prev, next) {
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.messageForError(next.error))),
          );
      }
    });

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const AuthBrandBar(fallbackRoute: '/home'),
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
                    label: l10n.authContinueTelegram,
                    icon: Icons.send_rounded,
                    accent: true,
                    onTap: isBusy ? null : () => context.push('/auth/code'),
                  ),
                  const SizedBox(height: 10),
                  AuthSocialButton(
                    label: l10n.authContinueGoogle,
                    icon: Icons.account_circle_outlined,
                    loading: socialState.inProgress == SocialProvider.google,
                    onTap: isBusy ? null : socialController.google,
                  ),
                  if (Platform.isIOS) ...[
                    const SizedBox(height: 10),
                    AuthSocialButton(
                      label: l10n.authContinueApple,
                      icon: Icons.apple,
                      loading: socialState.inProgress == SocialProvider.apple,
                      onTap: isBusy ? null : socialController.apple,
                    ),
                  ],
                  if (socialState.error != null) ...[
                    const SizedBox(height: 10),
                    _SocialErrorText(
                      text: l10n.messageForError(socialState.error),
                    ),
                  ],
                  const SizedBox(height: 10),
                  AuthSocialButton(
                    label: l10n.authEmailTitle,
                    icon: Icons.mail_outline_rounded,
                    onTap: isBusy ? null : () => context.push('/auth/email'),
                  ),
                  const SizedBox(height: 6),
                  const _OrDivider(),
                  const SizedBox(height: 6),
                  _GuestButton(
                    label: l10n.authContinueGuest,
                    loading: guestState.isLoading,
                    onTap: isBusy ? null : guestController.signInAsGuest,
                  ),
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

/// Текст ошибки социального входа под кнопками.
class _SocialErrorText extends StatelessWidget {
  const _SocialErrorText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: c.terracotta),
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

/// Текстовая кнопка «Продолжить без аккаунта» (без фона).
///
/// При [loading] = true показывает индикатор загрузки вместо текста.
/// При [onTap] = null (любой запрос в полёте) — некликабельна.
class _GuestButton extends StatelessWidget {
  const _GuestButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool loading;

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
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: c.ink,
                    ),
                  )
                : Text(
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
