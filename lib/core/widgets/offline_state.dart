import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';
import '../theme/tokens.dart';

/// Полноэкранное офлайн/ошибка-связи состояние (экран 29).
///
/// Переиспользуемое: все тексты прокидываются вызывающим уже локализованными
/// (как у [ErrorState]) — виджет не знает про `AppLocalizations`. Внутри:
/// опц. баннер «нет связи» → grayscale-иллюстрация с glyph «cloud-off» →
/// серифный заголовок (с опц. акцентным словом) и подпись → опц. строка
/// «последнее сохранённое» (dashed) → кнопка повтора.
///
/// [lastSavedLabel] = null → строка last-saved НЕ показывается (время не
/// фабрикуется: показываем её только когда вызывающий реально знает снапшот).
class OfflineState extends StatelessWidget {
  const OfflineState({
    super.key,
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.titleAccent,
    this.bannerTitle,
    this.bannerStatus,
    this.lastSavedLabel,
    this.illustrationAsset = 'assets/illustrations/fern.svg',
  });

  /// Серифный заголовок (обычная часть; при [titleAccent] — лид перед акцентом).
  final String title;

  /// Опц. акцентная часть заголовка (primary italic). null → весь заголовок
  /// рисуется цельным серифом.
  final String? titleAccent;

  /// Локализованная подпись.
  final String message;

  /// Подпись кнопки повтора.
  final String retryLabel;
  final VoidCallback onRetry;

  /// Заголовок офлайн-баннера. null (или null-статус) → баннер не показывается.
  final String? bannerTitle;

  /// Статус-метка справа в баннере (напр. «офлайн»).
  final String? bannerStatus;

  /// Локализованная строка «последнее сохранённое · {время}». null → скрыта.
  final String? lastSavedLabel;

  /// Ассет иллюстрации (рисуется в grayscale).
  final String illustrationAsset;

  // Матрица обесцвечивания (ITU-R BT.601) для эффекта «вне зоны».
  static const _grayscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final showBanner = bannerTitle != null && bannerStatus != null;

    return ColoredBox(
      color: c.bg,
      child: SafeArea(
        child: Column(
          children: [
            if (showBanner)
              _OfflineBanner(title: bannerTitle!, status: bannerStatus!),

            // Центр: grayscale-иллюстрация + cloud-off glyph + заголовок/подпись.
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Illustration(
                        asset: illustrationAsset,
                        filter: _grayscale,
                      ),
                      const SizedBox(height: 14),
                      _Title(
                        title: title,
                        accent: titleAccent,
                        ink: c.ink,
                        primary: c.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: c.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Низ: опц. last-saved (dashed) + кнопка повтора.
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (lastSavedLabel != null) ...[
                    _LastSavedRow(label: lastSavedLabel!),
                    const SizedBox(height: 12),
                  ],
                  _RetryButton(label: retryLabel, onRetry: onRetry),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.title, required this.status});

  final String title;
  final String status;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: c.terracotta.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.terracotta.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: c.terracotta,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.terracotta,
              ),
            ),
            const Spacer(),
            Text(status, style: TextStyle(fontSize: 11, color: c.inkSoft)),
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({required this.asset, required this.filter});

  final String asset;
  final ColorFilter filter;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Мягкий тёплый ореол за иллюстрацией.
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              color: c.surfaceWarm.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
          Opacity(
            opacity: 0.85,
            child: ColorFiltered(
              colorFilter: filter,
              child: ExcludeSemantics(
                child: SvgPicture.asset(asset, width: 150, height: 150),
              ),
            ),
          ),
          // cloud-off glyph в правом нижнем углу.
          Positioned(
            right: 12,
            bottom: 18,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.line),
              ),
              child: Icon(Icons.cloud_off_rounded, size: 24, color: c.inkSoft),
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
    required this.accent,
    required this.ink,
    required this.primary,
  });

  final String title;
  final String? accent;
  final Color ink;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final base = AppTheme.serif(fontSize: 32, color: ink);
    if (accent == null) {
      return Text(title, textAlign: TextAlign.center, style: base);
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: title),
          TextSpan(
            text: accent,
            style: AppTheme.serif(
              fontSize: 32,
              color: primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: base,
    );
  }
}

class _LastSavedRow extends StatelessWidget {
  const _LastSavedRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 14, color: c.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: c.inkSoft),
            ),
          ),
        ],
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({required this.label, required this.onRetry});

  final String label;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.fab,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onRetry,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded, size: 18, color: c.fabInk),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.fabInk,
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
