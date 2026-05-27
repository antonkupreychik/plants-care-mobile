import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Общая шапка шага мастера: кнопка «назад/закрыть», индикатор «Шаг N из M»,
/// опциональная кнопка «пропустить», прогресс-полоса по шагам.
class WizardHeader extends StatelessWidget {
  const WizardHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.onBack,
    this.onSkip,
  });

  /// 1-based номер текущего шага.
  final int step;
  final int totalSteps;

  /// Назад: на первом шаге — закрыть мастер, иначе — предыдущая страница.
  final VoidCallback onBack;

  /// «Пропустить» (только шаг выбора вида). null → кнопка не показывается.
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final isFirst = step <= 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _CircleIconButton(
              icon: isFirst ? Icons.close_rounded : Icons.arrow_back_rounded,
              label: isFirst ? l10n.addPlantClose : l10n.addPlantBack,
              onPressed: onBack,
            ),
            Expanded(
              child: Center(
                child: Text(
                  l10n.addPlantStepIndicator(step, totalSteps),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: c.inkSoft,
                  ),
                ),
              ),
            ),
            // Симметрия: либо «Пропустить», либо невидимый спейсер 44dp.
            if (onSkip != null)
              _SkipButton(onPressed: onSkip!)
            else
              const SizedBox(width: 44, height: 44),
          ],
        ),
        const SizedBox(height: 14),
        _ProgressBar(step: step, totalSteps: totalSteps),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.step, required this.totalSteps});

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Row(
      children: [
        for (var i = 1; i <= totalSteps; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i <= step ? c.primary : c.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (i != totalSteps) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: label,
      child: Material(
        color: c.surface,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: label,
              child: Icon(icon, size: 20, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      label: l10n.addPlantSkip,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(
          l10n.addPlantSkip,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Серифный заголовок шага + надзаголовок-капс и подпись.
class WizardStepTitle extends StatelessWidget {
  const WizardStepTitle({
    super.key,
    required this.overline,
    required this.title,
    required this.subtitle,
  });

  final String overline;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overline.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: AppTheme.serif(fontSize: 32, color: c.ink)),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

/// Нижняя панель действий шага: основная кнопка + опциональная вторичная.
///
/// Основная кнопка умеет показывать прогресс ([primaryLoading]) и блокироваться
/// ([primaryEnabled]) — используется и для «Далее», и для «Добавить».
class WizardActionBar extends StatelessWidget {
  const WizardActionBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIcon = Icons.arrow_forward_rounded,
    this.primaryEnabled = true,
    this.primaryLoading = false,
    this.secondaryLabel,
    this.onSecondary,
  });

  final String primaryLabel;
  final VoidCallback onPrimary;
  final IconData primaryIcon;
  final bool primaryEnabled;
  final bool primaryLoading;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (secondaryLabel != null && onSecondary != null) ...[
          _SecondaryButton(label: secondaryLabel!, onPressed: onSecondary!),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: _PrimaryButton(
            label: primaryLabel,
            icon: primaryIcon,
            enabled: primaryEnabled,
            loading: primaryLoading,
            onPressed: onPrimary,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final active = enabled && !loading;
    return Semantics(
      button: true,
      enabled: active,
      label: label,
      child: Material(
        color: active ? c.fab : c.inkMute,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: active ? onPressed : null,
          child: SizedBox(
            height: 56,
            child: Center(
              child: loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(c.fabInk),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: c.fabInk,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(icon, size: 18, color: c.fabInk),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.line),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
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
