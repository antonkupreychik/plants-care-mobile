import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Экран 32 «Пустая лента»: дружелюбная иллюстрация (succulent + солнце),
/// серифный заголовок «Пока тихо», успокаивающий текст и чип «сад в порядке».
///
/// Переиспользуется внутри экрана 24, когда `state.isEmpty`. Тексты — через
/// [AppLocalizations] (ru-only, ARB). Поддерживает pull-to-refresh:
/// рендерится внутри прокручиваемой области вызывающим экраном.
class NotificationsEmpty extends StatelessWidget {
  const NotificationsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Illustration(),
            const SizedBox(height: 18),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: l10n.notificationsEmptyTitleLead),
                  TextSpan(
                    text: l10n.notificationsEmptyTitleAccent,
                    style: AppTheme.serif(
                      fontSize: 30,
                      color: c.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: AppTheme.serif(fontSize: 30, color: c.ink),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.notificationsEmptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: c.inkSoft),
            ),
            const SizedBox(height: 18),
            _CalmChip(label: l10n.notificationsEmptyChip),
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: c.primarySoft.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          ExcludeSemantics(
            child: SvgPicture.asset(
              'assets/illustrations/succulent.svg',
              width: 130,
              height: 130,
            ),
          ),
          // Тёплое «солнце» в правом верхнем углу — растениям хорошо.
          Positioned(
            right: 16,
            top: 22,
            child: Icon(Icons.wb_sunny_rounded, size: 30, color: c.terracotta),
          ),
        ],
      ),
    );
  }
}

class _CalmChip extends StatelessWidget {
  const _CalmChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: c.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
