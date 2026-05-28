import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_code_controller.dart';
import 'widgets/auth_code_cells.dart';
import 'widgets/auth_keypad.dart';
import 'widgets/auth_primary_button.dart';

/// Экран 08 «Ввод кода из Telegram» — UI поверх готового
/// [authCodeControllerProvider] (визуальная заглушка превью-флоу).
///
/// Рисует 6 ячеек кода из `state.code`, цифровую клавиатуру (append/remove),
/// обратный отсчёт ресенда и CTA «Продолжить», активный только при
/// `state.isComplete` → переход на экран приветствия (`/auth/welcome-back`).
/// Никакой верификации/сети тут нет.
class AuthCodeScreen extends ConsumerWidget {
  const AuthCodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(authCodeControllerProvider);
    final notifier = ref.read(authCodeControllerProvider.notifier);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              backLabel: l10n.authBack,
              step: l10n.authCodeStepIndicator,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
                children: [
                  Text(
                    l10n.authCodeOverline.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.96,
                      color: c.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.authCodeTitle,
                    textAlign: TextAlign.center,
                    style: AppTheme.serif(fontSize: 30, color: c.ink),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authCodeSubtitle(l10n.authCodeBot),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: c.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthCodeCells(code: s.code),
                  const SizedBox(height: 18),
                  _ResendRow(
                    canResend: s.canResend,
                    seconds: s.resendSeconds,
                    onResend: notifier.resend,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: AuthKeypad(
                onDigit: notifier.appendDigit,
                onBackspace: notifier.removeDigit,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 16),
              child: AuthPrimaryButton(
                label: l10n.authContinue,
                enabled: s.isComplete,
                onTap: () => context.push('/auth/welcome-back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка экрана: кнопка «назад» + индикатор шага по центру.
class _Header extends StatelessWidget {
  const _Header({required this.backLabel, required this.step});

  final String backLabel;
  final String step;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: backLabel,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () =>
                    context.canPop() ? context.pop() : context.go('/home'),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            step,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.inkSoft,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// Строка ресенда: отсчёт mm:ss (пока `!canResend`) либо кликабельная подпись
/// повторной отправки кода.
class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.canResend,
    required this.seconds,
    required this.onResend,
  });

  final bool canResend;
  final int seconds;
  final VoidCallback onResend;

  String _mmss(int total) {
    final m = (total ~/ 60).toString().padLeft(1, '0');
    final s = (total % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    if (!canResend) {
      return Text(
        l10n.authResendIn(_mmss(seconds)),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, color: c.inkSoft),
      );
    }

    return Center(
      child: Semantics(
        button: true,
        label: l10n.authResend,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onResend,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: Text(
                l10n.authResend,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
