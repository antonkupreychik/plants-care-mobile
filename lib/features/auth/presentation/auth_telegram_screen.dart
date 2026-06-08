import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'telegram_auth_controller.dart';
import 'telegram_auth_state.dart';
import 'widgets/auth_code_cells.dart';
import 'widgets/auth_keypad.dart';
import 'widgets/auth_primary_button.dart';

/// Экран 08 «Вход через Telegram» — реальный флоу поверх
/// [telegramAuthControllerProvider].
///
/// Три состояния:
/// - [TelegramAuthPhase.starting] — брендовый сплеш (идёт `telegram/start` +
///   открытие deep link бота);
/// - [TelegramAuthPhase.startFailed] — ошибка старта + кнопка повтора;
/// - [TelegramAuthPhase.entering] — ячейки кода, цифровая клавиатура, обратный
///   отсчёт ресенда, инлайн-ошибки (неверный код / истёкшая сессия / лимит).
///
/// Код верифицируется автоматически по вводу последней цифры (контроллер).
/// Успех ловится через router-guard (сессия поднята) и переходом на экран 09
/// «С возвращением». `userNotFound` уводит на Welcome с поясняющим текстом.
class AuthTelegramScreen extends ConsumerWidget {
  const AuthTelegramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(telegramAuthControllerProvider);

    ref.listen(telegramAuthControllerProvider, (prev, next) {
      // Успех → экран 09 «С возвращением» (guard-исключение пускает туда
      // авторизованного; иначе увело бы на /home).
      if (next.succeeded && (prev == null || !prev.succeeded)) {
        context.go('/auth/welcome-back');
        return;
      }
      // «Нет аккаунта» (telegram_user_not_found) → возврат на Welcome с тостом.
      if (next.userNotFound && (prev == null || !prev.userNotFound)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.authTelegramUserNotFound)),
          );
        context.go('/auth/welcome');
      }
    });

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: switch (s.phase) {
          TelegramAuthPhase.starting => const _StartingSplash(),
          TelegramAuthPhase.startFailed => _StartFailed(
              message: l10n.messageForError(s.startError) == l10n.errorGeneric
                  ? l10n.authTelegramStartError
                  : l10n.messageForError(s.startError),
              onRetry: () => ref
                  .read(telegramAuthControllerProvider.notifier)
                  .retryStart(),
            ),
          TelegramAuthPhase.entering => _CodeEntry(state: s),
        },
      ),
    );
  }
}

/// Брендовый сплеш на время `telegram/start` + открытия бота.
class _StartingSplash extends StatelessWidget {
  const _StartingSplash();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.send_rounded, size: 28, color: c.surface),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 2.6, color: c.primary),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.authTelegramStarting,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: c.inkSoft),
          ),
        ],
      ),
    );
  }
}

/// Ошибка старта входа + кнопки «повторить» / «назад».
class _StartFailed extends StatelessWidget {
  const _StartFailed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: c.surfaceWarm,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.wifi_off_rounded, size: 30, color: c.terracotta),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.4, color: c.ink),
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(
              label: l10n.authTelegramStartRetry,
              onTap: onRetry,
            ),
            const SizedBox(height: 8),
            _BackToWelcomeLink(label: l10n.authVerifyRetry),
          ],
        ),
      ),
    );
  }
}

/// Основная фаза: ввод кода.
class _CodeEntry extends ConsumerWidget {
  const _CodeEntry({required this.state});

  final TelegramAuthState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(telegramAuthControllerProvider.notifier);

    return Column(
      children: [
        _Header(backLabel: l10n.authBack, step: l10n.authCodeStepIndicator),
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
                style: TextStyle(fontSize: 14, height: 1.45, color: c.inkSoft),
              ),
              const SizedBox(height: 24),
              AuthCodeCells(code: state.code, length: state.codeLength),
              const SizedBox(height: 14),
              if (state.codeError != null)
                _InlineError(text: _codeErrorText(l10n, state.codeError!))
              else if (state.verifying)
                _VerifyingRow(label: l10n.authTelegramVerifying)
              else
                _ResendRow(
                  canResend: state.canResend,
                  seconds: state.resendSeconds,
                  onResend: notifier.resend,
                ),
              const SizedBox(height: 14),
              Text(
                l10n.authTelegramOpenBotHint,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, height: 1.4, color: c.inkMute),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: AuthKeypad(
            onDigit: notifier.appendDigit,
            onBackspace: notifier.removeDigit,
          ),
        ),
      ],
    );
  }

  String _codeErrorText(AppLocalizations l10n, TelegramCodeError e) =>
      switch (e) {
        TelegramCodeError.invalidCode => l10n.authTelegramErrorInvalidCode,
        TelegramCodeError.sessionExpired =>
          l10n.authTelegramErrorSessionExpired,
        TelegramCodeError.tooManyAttempts =>
          l10n.authTelegramErrorTooManyAttempts,
      };
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
                onTap: () => context.canPop()
                    ? context.pop()
                    : context.go('/auth/welcome'),
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

/// Инлайн-сообщение об ошибке ввода кода (под ячейками).
class _InlineError extends StatelessWidget {
  const _InlineError({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13, height: 1.35, color: c.terracotta),
    );
  }
}

/// Индикатор проверки кода (вместо строки ресенда, пока идёт verify).
class _VerifyingRow extends StatelessWidget {
  const _VerifyingRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.primary),
        ),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 13, color: c.inkSoft)),
      ],
    );
  }
}

/// Строка ресенда: отсчёт mm:ss либо кликабельная подпись повторной отправки.
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

/// Вторичная ссылка «Вернуться ко входу» (на экране ошибки старта).
class _BackToWelcomeLink extends StatelessWidget {
  const _BackToWelcomeLink({required this.label});

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
          onTap: () => context.go('/auth/welcome'),
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
