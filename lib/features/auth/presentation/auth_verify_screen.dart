import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/env/app_config.dart';
import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_verify_controller.dart';
import 'widgets/auth_primary_button.dart';

/// Экран обмена magic-link токена на сессию (deep link `/auth/verify?token=…`).
///
/// Если [token] непуст — подписывается на `authVerifyControllerProvider(token)`
/// и рисует loading/error; по успеху уходит на `/home`. Если токена нет:
/// в dev-сборке показывает ручной ввод токена (единственный способ проверить
/// флоу без письма), в prod — короткую ошибку с возвратом ко входу.
class AuthVerifyScreen extends ConsumerWidget {
  const AuthVerifyScreen({required this.token, super.key});

  /// Opaque-токен из ссылки письма (`?token=…`); `null`/пусто — ссылки нет.
  final String? token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final hasToken = token != null && token!.isNotEmpty;

    if (!hasToken) {
      final isDev = ref.watch(appConfigProvider).isDev;
      return Scaffold(
        backgroundColor: c.bg,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: isDev
                  ? const _DevTokenForm()
                  : _VerifyMessage(
                      icon: Icons.link_off_rounded,
                      title: l10n.authVerifyError,
                      actionLabel: l10n.authVerifyRetry,
                      onAction: () => context.go('/auth/welcome'),
                    ),
            ),
          ),
        ),
      );
    }

    // Успех: сессия поднята — уходим на главную (router-guard тоже подхватит).
    ref.listen<AsyncValue<void>>(authVerifyControllerProvider(token!),
        (prev, next) {
      if (next is AsyncData) {
        context.go('/home');
      }
    });

    final state = ref.watch(authVerifyControllerProvider(token!));

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
            child: switch (state) {
              AsyncError(:final error) => _VerifyMessage(
                  icon: Icons.error_outline_rounded,
                  title: l10n.authVerifyError,
                  message: l10n.messageForError(error),
                  actionLabel: l10n.authVerifyRetry,
                  onAction: () => context.go('/auth/welcome'),
                ),
              // loading и краткое окно data (до перехода) — брендовый сплеш.
              _ => const _VerifySplash(),
            },
          ),
        ),
      ),
    );
  }
}

/// Брендовый сплеш проверки токена: логотип + спиннер + «проверяем ссылку».
class _VerifySplash extends StatelessWidget {
  const _VerifySplash();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: c.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(Icons.eco_rounded, size: 28, color: c.surface),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(strokeWidth: 2.6, color: c.primary),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.authVerifying,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: c.inkSoft),
        ),
      ],
    );
  }
}

/// Сообщение об ошибке/невалидной ссылке с CTA возврата.
class _VerifyMessage extends StatelessWidget {
  const _VerifyMessage({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
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
            child: Icon(icon, size: 30, color: c.terracotta),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.serif(fontSize: 28, color: c.ink),
        ),
        if (message != null) ...[
          const SizedBox(height: 10),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.4, color: c.inkSoft),
          ),
        ],
        const SizedBox(height: 24),
        AuthPrimaryButton(label: actionLabel, onTap: onAction),
      ],
    );
  }
}

/// Dev-хук: ручной ввод токена и переход на `/auth/verify?token=…`.
///
/// Доступен только в dev-сборке (`AppConfig.isDev`). Единственный способ
/// прогнать verify-флоу без реального письма с magic link.
class _DevTokenForm extends StatefulWidget {
  const _DevTokenForm();

  @override
  State<_DevTokenForm> createState() => _DevTokenFormState();
}

class _DevTokenFormState extends State<_DevTokenForm> {
  final TextEditingController _controller = TextEditingController();
  String _value = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final token = _value.trim();
    if (token.isEmpty) return;
    context.go('/auth/verify?token=${Uri.encodeQueryComponent(token)}');
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'DEV',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.96,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.authDevTokenLabel,
          style: AppTheme.serif(fontSize: 28, color: c.ink),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          onChanged: (v) => setState(() => _value = v),
          onSubmitted: (_) => _submit(),
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.go,
          style: AppTheme.serif(fontSize: 20, color: c.ink),
          decoration: InputDecoration(
            hintText: l10n.authDevTokenLabel,
            hintStyle: AppTheme.serif(fontSize: 20, color: c.inkMute),
            filled: true,
            fillColor: c.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: c.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: c.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: c.primary),
            ),
          ),
        ),
        const SizedBox(height: 20),
        AuthPrimaryButton(
          label: l10n.authVerifyRetry,
          enabled: _value.trim().isNotEmpty,
          onTap: _submit,
        ),
      ],
    );
  }
}
