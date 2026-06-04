import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/widgets/auth_primary_button.dart';
import 'push_priming_controller.dart';
import 'widgets/push_notification_preview.dart';
import 'widgets/push_priming_hero.dart';

/// Экран 27 «Онбординг — разрешение на пуши» (`PushPermissionScreen`).
///
/// Мягкий прайминг перед системным запросом разрешений: объясняем ценность
/// пушей и спрашиваем согласие. Вход — после «С возвращением» (09).
///
/// ВАЖНО: реальный системный `requestPermissions` и регистрация push-токена
/// (`POST /api/v1/devices {pushToken, platform}`) здесь НЕ выполняются — они
/// появятся отдельной задачей после решения по push-стеку (README §9 #3) и
/// эндпоинта на бэкенде (backend #187). Сейчас экран фиксирует только намерение
/// пользователя (через [PushPrimingController]) и уводит на главную.
class PushPermissionScreen extends ConsumerWidget {
  const PushPermissionScreen({super.key});

  Future<void> _allow(WidgetRef ref) async {
    await ref.read(pushPrimingControllerProvider.notifier).allow();
  }

  Future<void> _postpone(WidgetRef ref) async {
    await ref.read(pushPrimingControllerProvider.notifier).postpone();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final decision = ref.watch(pushPrimingControllerProvider);
    final busy = decision.isLoading;

    Future<void> done(Future<void> Function() action) async {
      await action();
      if (!context.mounted) return;
      context.go('/home');
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Skip-ссылка «Позже» вверху справа.
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _SkipLink(
                    label: l10n.pushPrimingSkip,
                    onTap: busy ? null : () => done(() => _postpone(ref)),
                  ),
                ],
              ),
            ),
            const Expanded(child: PushPrimingHero()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  _Title(c: c, l10n: l10n),
                  const SizedBox(height: 10),
                  Text(
                    l10n.pushPrimingSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: c.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: PushNotificationPreview(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
              child: Column(
                children: [
                  AuthPrimaryButton(
                    label: l10n.pushPrimingAllow,
                    icon: Icons.notifications_active_rounded,
                    enabled: !busy,
                    onTap: () => done(() => _allow(ref)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.pushPrimingFootnote,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: c.inkMute),
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

/// Заголовок с серифным акцентом-курсивом на последнем слове
/// («Я напомню *вовремя*»).
class _Title extends StatelessWidget {
  const _Title({required this.c, required this.l10n});

  final PcColors c;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final base = AppTheme.serif(fontSize: 38, color: c.ink);
    final accent = AppTheme.serif(
      fontSize: 38,
      fontStyle: FontStyle.italic,
      color: c.primary,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: l10n.pushPrimingTitleLead, style: base),
          TextSpan(text: l10n.pushPrimingTitleAccent, style: accent),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _SkipLink extends StatelessWidget {
  const _SkipLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}
