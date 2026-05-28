import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Цифровая клавиатура экрана 08: 1–9, 0 и backspace.
///
/// Колбэки [onDigit] / [onBackspace] идут в `AuthCodeController`
/// (appendDigit/removeDigit). Каждая клавиша — тап-зона ≥ 56dp, помечена
/// [Semantics]. Пустая ячейка (левый-нижний угол) — невидимая распорка для
/// выравнивания сетки 3×4.
class AuthKeypad extends StatelessWidget {
  const AuthKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  static const List<List<String>> _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '<'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in _rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                for (final key in row)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _Key(
                        value: key,
                        onDigit: onDigit,
                        onBackspace: onBackspace,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.value,
    required this.onDigit,
    required this.onBackspace,
  });

  /// Цифра ('0'..'9'), '<' (backspace) или '' (пустая распорка).
  final String value;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);

    if (value.isEmpty) {
      return const SizedBox(height: 56);
    }

    final isBackspace = value == '<';
    final label = isBackspace
        ? l10n.authKeypadBackspace
        : l10n.authKeypadDigit(value);

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isBackspace ? onBackspace : () => onDigit(value),
          child: SizedBox(
            height: 56,
            child: isBackspace
                ? Icon(Icons.backspace_outlined, size: 22, color: c.ink)
                : Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: c.ink,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
