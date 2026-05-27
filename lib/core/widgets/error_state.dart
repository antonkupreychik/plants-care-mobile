import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Аккуратное состояние ошибки секции: текст (уже локализованный по типу
/// [ApiError] вызывающим кодом) + кнопка «повторить» (обычно
/// `ref.invalidate(provider)`).
///
/// Текст НЕ берётся из `error.toString()` — вызывающий маппит [ApiError]
/// в строку через `AppLocalizations` и передаёт сюда готовый [message].
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.compact = false,
  });

  /// Уже локализованный текст ошибки.
  final String message;

  /// Локализованная подпись кнопки повтора.
  final String retryLabel;
  final VoidCallback onRetry;

  /// Компактный вариант для маленьких секций (без крупной иконки).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!compact) ...[
            Icon(Icons.cloud_off_rounded, size: 32, color: c.inkMute),
            const SizedBox(height: 12),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: c.inkSoft, height: 1.4),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(retryLabel),
            style: TextButton.styleFrom(
              foregroundColor: c.primary,
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
}
