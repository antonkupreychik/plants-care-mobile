import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import 'delete_account_notifier.dart';

/// Экран удаления аккаунта (Apple/Google Store requirement).
///
/// Показывает предупреждение о необратимости, список удаляемых данных, чекбокс
/// подтверждения и кнопку «Удалить аккаунт». Перед вызовом API открывает
/// финальный диалог-подтверждение.
///
/// После успешного `DELETE /api/v1/me` + `signOut` router-guard (MADR-008)
/// уводит на `/auth/welcome` — навигацию здесь не делаем явно.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = Theme.of(context).extension<PcColors>()!;
    final state = ref.watch(deleteAccountProvider);
    final isLoading = state.isLoading;

    // Показываем снэкбар при ошибке.
    ref.listen(deleteAccountProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deleteAccountErrorSnack)),
        );
      }
    });

    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.deleteAccountScreenTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: c.ink,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
          children: [
            // Иконка предупреждения.
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: c.terracotta.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 32,
                  color: c.terracotta,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Заголовок предупреждения.
            Text(
              l10n.deleteAccountWarningTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: c.terracotta,
              ),
            ),
            const SizedBox(height: 16),

            // Описание удаляемых данных (требование сторов).
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.line),
              ),
              child: Text(
                l10n.deleteAccountWarningBody,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: c.inkSoft,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Чекбокс подтверждения.
            _ConfirmCheckbox(
              confirmed: _confirmed,
              label: l10n.deleteAccountConfirmLabel,
              onChanged: isLoading
                  ? null
                  : (v) => setState(() => _confirmed = v ?? false),
            ),
            const SizedBox(height: 28),

            // Кнопка «Удалить аккаунт» — активна только если чекбокс отмечен.
            _DeleteButton(
              label: l10n.deleteAccountCta,
              enabled: _confirmed && !isLoading,
              loading: isLoading,
              onPressed: () => _onDeleteTap(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteTap(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAccountDialogTitle),
        content: Text(l10n.deleteAccountDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.deleteAccountDialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deleteAccountDialogConfirm,
              style: TextStyle(
                color: Theme.of(context).extension<PcColors>()!.terracotta,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(deleteAccountProvider.notifier).deleteAccount();
  }
}

/// Чекбокс с меткой «Я понимаю, что данные будут удалены».
class _ConfirmCheckbox extends StatelessWidget {
  const _ConfirmCheckbox({
    required this.confirmed,
    required this.label,
    required this.onChanged,
  });

  final bool confirmed;
  final String label;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onChanged == null ? null : () => onChanged!(!confirmed),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: confirmed,
              onChanged: onChanged,
              activeColor: c.terracotta,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: c.ink,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Кнопка «Удалить аккаунт» с деструктивным стилем и индикатором загрузки.
class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    required this.label,
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: c.terracotta,
          disabledBackgroundColor: c.terracotta.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
