import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';

/// Поле поиска по каталогу с дебаунсом ввода.
///
/// Сырой ввод НЕ дёргает state на каждый символ: `onChanged` перезапускает
/// [Timer] на [debounce], и только по его истечении вызывается [onSubmitted]
/// с обрезанным текстом (UI-забота по контракту провайдеров). Кнопка очистки
/// сбрасывает поле и сразу шлёт пустой запрос (таймер отменяется).
class CatalogSearchField extends StatefulWidget {
  const CatalogSearchField({
    super.key,
    required this.initialValue,
    required this.onSubmitted,
    this.debounce = const Duration(milliseconds: 350),
  });

  /// Текущее committed-значение запроса (для синхронизации поля при входе).
  final String initialValue;

  /// Вызывается с «успокоившимся» текстом (уже trim'нутым).
  final ValueChanged<String> onSubmitted;

  final Duration debounce;

  @override
  State<CatalogSearchField> createState() => _CatalogSearchFieldState();
}

class _CatalogSearchFieldState extends State<CatalogSearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce, () {
      widget.onSubmitted(value.trim());
    });
    // Перерисовываем для кнопки очистки (показ/скрытие по наличию текста).
    setState(() {});
  }

  void _clear() {
    _debounceTimer?.cancel();
    _controller.clear();
    widget.onSubmitted('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final hasText = _controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 18, color: c.inkSoft),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                _debounceTimer?.cancel();
                widget.onSubmitted(value.trim());
              },
              style: TextStyle(fontSize: 14, color: c.ink),
              cursorColor: c.primary,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: l10n.catalogSearchHint,
                hintStyle: TextStyle(fontSize: 14, color: c.inkMute),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (hasText)
            Semantics(
              button: true,
              label: l10n.catalogSearchClear,
              child: InkResponse(
                onTap: _clear,
                radius: 24,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.close_rounded, size: 18, color: c.inkSoft),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
