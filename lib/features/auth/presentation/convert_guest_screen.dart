import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/presentation/me_provider.dart';
import 'convert_guest_controller.dart';
import 'convert_guest_state.dart';
import 'widgets/auth_brand_bar.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_social_button.dart';

/// Экран конвертации гостевого аккаунта в реальный (issue #74).
///
/// Три варианта: email magic-link, Google, Apple (iOS only).
/// Email → `POST /auth/guest/convert { provider: EMAIL, email }` → «проверьте почту».
/// Google/Apple → `POST /auth/guest/convert { provider, idToken }` → конвертация.
///
/// После успешной конвертации инвалидирует [meIsGuestProvider] → баннер исчезает.
/// Ошибка 409 (email занят) → понятное сообщение через `messageForError`.
///
/// Роут: `/profile/convert-guest`.
class ConvertGuestScreen extends ConsumerWidget {
  const ConvertGuestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(convertGuestControllerProvider);

    // После конвертации Google/Apple — инвалидируем isGuest и уходим назад.
    ref.listen(convertGuestControllerProvider, (prev, next) {
      if (next.status == ConvertStatus.converted &&
          prev?.status != ConvertStatus.converted) {
        ref.invalidate(meIsGuestProvider);
        if (context.mounted) context.pop();
      }
    });

    return switch (state.status) {
      ConvertStatus.emailSent => _EmailSentView(email: state.email),
      _ => _ConvertOptionsView(state: state),
    };
  }
}

/// Основной экран с вариантами конвертации.
class _ConvertOptionsView extends ConsumerWidget {
  const _ConvertOptionsView({required this.state});

  final ConvertGuestState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(convertGuestControllerProvider.notifier);
    final isBusy = state.isBusy;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const AuthBrandBar(fallbackRoute: '/profile'),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Иконка замка
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: c.surfaceWarm,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.lock_outline_rounded,
                        size: 30, color: c.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.convertGuestScreenTitle,
                    style: AppTheme.serif(fontSize: 36, color: c.ink),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.convertGuestScreenSubtitle,
                    style:
                        TextStyle(fontSize: 14, height: 1.4, color: c.inkSoft),
                  ),
                  const SizedBox(height: 28),

                  // Email-конвертация
                  _ConvertEmailSection(
                    isBusy: isBusy,
                    isLoading: state.inProgress == ConvertProvider.email,
                    onSubmit: controller.convertWithEmail,
                    error: state.inProgress == ConvertProvider.email
                        ? null
                        : state.error,
                  ),

                  const SizedBox(height: 16),
                  _OrDivider(),
                  const SizedBox(height: 16),

                  // Google
                  AuthSocialButton(
                    label: l10n.authContinueGoogle,
                    icon: Icons.account_circle_outlined,
                    loading: state.inProgress == ConvertProvider.google,
                    onTap: isBusy ? null : controller.convertWithGoogle,
                  ),

                  // Apple — только iOS
                  if (Platform.isIOS) ...[
                    const SizedBox(height: 10),
                    AuthSocialButton(
                      label: l10n.authContinueApple,
                      icon: Icons.apple,
                      loading: state.inProgress == ConvertProvider.apple,
                      onTap: isBusy ? null : controller.convertWithApple,
                    ),
                  ],

                  // Ошибка (Google/Apple)
                  if (state.error != null &&
                      state.inProgress != ConvertProvider.email) ...[
                    const SizedBox(height: 10),
                    Text(
                      l10n.messageForError(state.error),
                      style: TextStyle(fontSize: 12, color: c.terracotta),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Секция ввода email внутри экрана конвертации.
class _ConvertEmailSection extends ConsumerStatefulWidget {
  const _ConvertEmailSection({
    required this.isBusy,
    required this.isLoading,
    required this.onSubmit,
    this.error,
  });

  final bool isBusy;
  final bool isLoading;
  final Future<void> Function(String email) onSubmit;
  final Object? error;

  @override
  ConsumerState<_ConvertEmailSection> createState() =>
      _ConvertEmailSectionState();
}

class _ConvertEmailSectionState extends ConsumerState<_ConvertEmailSection> {
  final _emailController = TextEditingController();
  String _email = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _isValidEmail => RegExp(
        r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(_email);

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final showFormatError = _email.isNotEmpty && !_isValidEmail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _emailController,
          enabled: !widget.isBusy,
          onChanged: (v) => setState(() => _email = v),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.go,
          autocorrect: false,
          enableSuggestions: false,
          style: AppTheme.serif(fontSize: 20, color: c.ink),
          decoration: InputDecoration(
            hintText: l10n.authEmailHint,
            hintStyle: AppTheme.serif(fontSize: 20, color: c.inkMute),
            filled: true,
            fillColor: c.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                  color: showFormatError ? c.terracotta : c.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                  color: showFormatError ? c.terracotta : c.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: showFormatError ? c.terracotta : c.primary,
              ),
            ),
          ),
        ),
        if (showFormatError) ...[
          const SizedBox(height: 4),
          Text(
            l10n.authEmailInvalid,
            style: TextStyle(fontSize: 12, color: c.terracotta),
          ),
        ],
        if (widget.error != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.messageForError(widget.error),
            style: TextStyle(fontSize: 12, color: c.terracotta),
          ),
        ],
        const SizedBox(height: 12),
        AuthPrimaryButton(
          label: l10n.authSendLink,
          enabled: _isValidEmail && !widget.isBusy,
          onTap: () {
            if (_isValidEmail && !widget.isBusy) widget.onSubmit(_email);
          },
        ),
        if (widget.isLoading) ...[
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2.4, color: c.primary),
            ),
          ),
        ],
      ],
    );
  }
}

/// Состояние «письмо отправлено».
class _EmailSentView extends StatelessWidget {
  const _EmailSentView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const AuthBrandBar(fallbackRoute: '/profile'),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: c.surfaceWarm,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.mark_email_unread_outlined,
                        size: 30, color: c.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.authLinkSentTitle,
                    style: AppTheme.serif(fontSize: 32, color: c.ink),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authLinkSentSubtitle,
                    style:
                        TextStyle(fontSize: 14, height: 1.45, color: c.inkSoft),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
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

/// Разделитель «или».
class _OrDivider extends StatelessWidget {
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
