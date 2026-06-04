import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/app_language.dart';
import 'language_providers.dart';

/// Экран 38 «Язык приложения» (issue #34).
///
/// Потребляет `localeProvider` → `AsyncValue<Locale>`:
/// - loading → список со skeleton-галочками (ни один не выбран);
/// - error → список с `AppLanguage.ru` выбранным по умолчанию (graceful fallback);
/// - data → обычный render по текущей локали.
///
/// Тап → `ref.read(localeProvider.notifier).setLanguage(language)`.
/// Смена языка немедленно обновляет `locale` в `MaterialApp` через `app.dart`.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final localeAsync = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _LanguageHeader(backLabel: l10n.languageBack),
            Expanded(
              child: localeAsync.when(
                loading: () => _LanguageBody(
                  subtitle: l10n.languageScreenSubtitle,
                  hint: l10n.languageScreenHint,
                  selectedLanguage: null,
                  isLoading: true,
                  onSelect: (_) {},
                ),
                error: (e, st) => _LanguageBody(
                  subtitle: l10n.languageScreenSubtitle,
                  hint: l10n.languageScreenHint,
                  selectedLanguage: AppLanguage.ru,
                  isLoading: false,
                  onSelect: (lang) => ref
                      .read(localeProvider.notifier)
                      .setLanguage(lang),
                ),
                data: (locale) => _LanguageBody(
                  subtitle: l10n.languageScreenSubtitle,
                  hint: l10n.languageScreenHint,
                  selectedLanguage: AppLanguageFromLocale.fromLocale(locale),
                  isLoading: false,
                  onSelect: (lang) => ref
                      .read(localeProvider.notifier)
                      .setLanguage(lang),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: кнопка «назад» (arrow_back_rounded) и центрированный
/// «ЯЗЫК · LANGUAGE» (uppercase, inkSoft). Аналог шапки quiet_hours_screen.
class _LanguageHeader extends StatelessWidget {
  const _LanguageHeader({required this.backLabel});

  final String backLabel;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          _BackButton(tooltip: backLabel),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'ЯЗЫК · LANGUAGE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
                color: c.inkSoft,
              ),
            ),
          ),
          // Балансирующий спейсер справа = ширина кнопки «назад» (44dp).
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.tooltip});

  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
          child: SizedBox(
            width: 44,
            height: 44,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Icon(Icons.arrow_back_rounded, size: 22, color: c.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// Контент экрана: заголовок + подзаголовок + список + hint.
class _LanguageBody extends StatelessWidget {
  const _LanguageBody({
    required this.subtitle,
    required this.hint,
    required this.selectedLanguage,
    required this.isLoading,
    required this.onSelect,
  });

  final String subtitle;
  final String hint;

  /// null в состоянии loading (skeleton-галочки, ни один не выделен).
  final AppLanguage? selectedLanguage;
  final bool isLoading;
  final ValueChanged<AppLanguage> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 40),
      children: [
        _TitleBlock(subtitle: subtitle),
        const SizedBox(height: 18),
        _LanguageList(
          selectedLanguage: selectedLanguage,
          isLoading: isLoading,
          onSelect: onSelect,
        ),
        const SizedBox(height: 16),
        _HintText(hint: hint),
      ],
    );
  }
}

/// Серифный заголовок «Язык *приложения*» + подзаголовок.
///
/// Оба слова берутся из локализации — при переключении на English
/// показывает «App *language*».
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: l10n.languageScreenTitleLead,
                style: AppTheme.serif(fontSize: 32, color: c.ink),
              ),
              TextSpan(
                text: l10n.languageScreenTitleAccent,
                style: AppTheme.serif(
                  fontSize: 32,
                  color: c.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
        ),
      ],
    );
  }
}

/// Карточка списка языков (borderRadius 22, border line).
class _LanguageList extends StatelessWidget {
  const _LanguageList({
    required this.selectedLanguage,
    required this.isLoading,
    required this.onSelect,
  });

  final AppLanguage? selectedLanguage;
  final bool isLoading;
  final ValueChanged<AppLanguage> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final languages = AppLanguage.values;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < languages.length; i++)
            _LanguageRow(
              language: languages[i],
              isSelected: !isLoading && languages[i] == selectedLanguage,
              isLoading: isLoading,
              showDivider: i > 0,
              onTap: isLoading ? null : () => onSelect(languages[i]),
            ),
        ],
      ),
    );
  }
}

/// Строка языка: слева nativeName + englishName, справа — галочка/кружок/skeleton.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.isSelected,
    required this.isLoading,
    required this.showDivider,
    required this.onTap,
  });

  final AppLanguage language;
  final bool isSelected;
  final bool isLoading;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final nativeColor = isSelected ? c.primary : c.ink;
    final bgColor = isSelected ? c.primarySoft : Colors.transparent;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${language.nativeName} — ${language.englishName}',
      child: Material(
        color: bgColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              border: showDivider
                  ? Border(top: BorderSide(color: c.line))
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language.nativeName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: nativeColor,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        language.englishName,
                        style: TextStyle(fontSize: 11, color: c.inkSoft),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (isLoading)
                  SkeletonBox(
                    width: 20,
                    height: 20,
                    radius: 10,
                  )
                else if (isSelected)
                  Icon(Icons.check_rounded, size: 18, color: c.primary)
                else
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: c.line, width: 2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Hint-текст внизу экрана (inkMute, 12px).
class _HintText extends StatelessWidget {
  const _HintText({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      hint,
      style: TextStyle(fontSize: 12, color: c.inkMute, height: 1.5),
    );
  }
}
