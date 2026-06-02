import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_email_controller.dart';
import 'auth_email_state.dart';
import 'widgets/auth_brand_bar.dart';
import 'widgets/auth_primary_button.dart';

/// Экран ввода email для запроса magic link (вход срез 2).
///
/// Потребляет `authEmailControllerProvider` ([AuthEmailState]): синкает ввод
/// через `setEmail`, гейтит CTA по `canSubmit`, при `submitting` крутит
/// индикатор. По `linkSent` переключается на состояние «проверьте почту».
class AuthEmailScreen extends ConsumerStatefulWidget {
  const AuthEmailScreen({super.key});

  @override
  ConsumerState<AuthEmailScreen> createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends ConsumerState<AuthEmailScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final state = ref.watch(authEmailControllerProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const AuthBrandBar(fallbackRoute: '/auth/welcome'),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: state.linkSent
                  ? _LinkSentView(email: state.email)
                  : _EmailForm(controller: _controller, state: state),
            ),
          ],
        ),
      ),
    );
  }
}

/// Форма ввода email с CTA «получить ссылку».
class _EmailForm extends ConsumerWidget {
  const _EmailForm({required this.controller, required this.state});

  final TextEditingController controller;
  final AuthEmailState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(authEmailControllerProvider.notifier);

    // Ошибку формата показываем только после ввода (не пугаем пустым полем).
    final showFormatError = state.email.isNotEmpty && !state.isValidEmail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.authEmailTitle.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.96,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.authEmailTitle,
          style: AppTheme.serif(fontSize: 36, color: c.ink),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.authEmailSubtitle,
          style: TextStyle(fontSize: 14, height: 1.4, color: c.inkSoft),
        ),
        const SizedBox(height: 24),
        _SectionLabel(text: l10n.authEmailLabel),
        const SizedBox(height: 8),
        _EmailField(
          controller: controller,
          hasError: showFormatError,
          enabled: !state.submitting,
          onChanged: notifier.setEmail,
          onSubmitted: (_) {
            if (state.canSubmit) notifier.submit();
          },
        ),
        if (showFormatError) ...[
          const SizedBox(height: 6),
          _ErrorText(text: l10n.authEmailInvalid),
        ],
        if (state.error != null) ...[
          const SizedBox(height: 6),
          _ErrorText(text: l10n.messageForError(state.error)),
        ],
        const SizedBox(height: 24),
        AuthPrimaryButton(
          label: l10n.authSendLink,
          enabled: state.canSubmit,
          onTap: notifier.submit,
        ),
        if (state.submitting) ...[
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: c.primary),
            ),
          ),
        ],
      ],
    );
  }
}

/// Состояние «проверьте почту»: конверт + введённый адрес.
class _LinkSentView extends StatelessWidget {
  const _LinkSentView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: c.surfaceWarm,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.mark_email_unread_outlined, size: 30, color: c.primary),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.authLinkSentTitle,
          style: AppTheme.serif(fontSize: 32, color: c.ink),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.authLinkSentSubtitle,
          style: TextStyle(fontSize: 14, height: 1.45, color: c.inkSoft),
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
    );
  }
}

/// Overline-метка над секцией (как в add_plant).
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

/// Поле ввода email с подсветкой ошибки (паттерн `_NameField` из add_plant).
class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.hasError,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool hasError;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final borderColor = hasError ? c.terracotta : c.line;
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.go,
      autocorrect: false,
      enableSuggestions: false,
      style: AppTheme.serif(fontSize: 22, color: c.ink),
      decoration: InputDecoration(
        hintText: l10n.authEmailHint,
        hintStyle: AppTheme.serif(fontSize: 22, color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: hasError ? c.terracotta : c.primary),
        ),
      ),
    );
  }
}

/// Текст ошибки под полем.
class _ErrorText extends StatelessWidget {
  const _ErrorText({required this.text});

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
