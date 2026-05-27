import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/env/app_config.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Первый экран каркаса. Пока — приветственная заглушка, доказывающая, что
/// собрано: тема из токенов (light/dark), шрифты (Instrument Serif +
/// Plus Jakarta Sans), SVG-иллюстрация и проброс конфигурации из `--dart-define`.
///
/// Реальная «Главная — Мой сад» (01) с данными `GET /today` + `/plants`
/// делается на шаге фич (после сборки каркаса) через flutter-coder.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                l10n.homeOverline,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: c.inkMute,
                ),
              ),
              const Spacer(),
              Center(
                child: SvgPicture.asset(
                  'assets/illustrations/monstera.svg',
                  width: 168,
                  height: 168,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  l10n.appTitle,
                  style: AppTheme.serif(fontSize: 52, color: c.ink),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  l10n.homeSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: c.inkSoft,
                  ),
                ),
              ),
              const Spacer(),
              _BuildInfoCard(config: config, colors: c),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Карточка-индикатор: показывает, что проброс flavor + API URL из
/// `--dart-define` работает (MADR-010). Уйдёт, когда появится реальная Главная.
class _BuildInfoCard extends StatelessWidget {
  const _BuildInfoCard({required this.config, required this.colors});

  final AppConfig config;
  final PcColors colors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                l10n.buildOk,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: l10n.fieldFlavor,
            value: config.flavor.name,
            colors: colors,
          ),
          _InfoRow(label: l10n.fieldApi, value: config.apiUrl, colors: colors),
          _InfoRow(
            label: l10n.fieldDevAuth,
            value: config.chatId == null
                ? '—'
                : 'chat ${config.chatId} · user ${config.userId ?? "—"}',
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.colors,
  });

  final String label;
  final String value;
  final PcColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: colors.inkMute),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.inkSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
