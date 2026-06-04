import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../disease_catalog_providers.dart';

/// Поле поиска по справочнику болезней с дебаунсом ввода (issue #68).
///
/// Сырой ввод не дёргает state на каждый символ: `onChanged` перезапускает
/// [Timer] на [debounce] (400 мс по AC), и только по его истечении вызывается
/// [onSubmitted]. Запросы короче [kDiseaseSearchMinLength] символов в строку
/// поиска не коммитятся как фильтр (отдаём пустую строку → весь список), так
/// порог «минимум 2 символа» соблюдается. Кнопка очистки сбрасывает поле.
class DiseaseSearchField extends StatefulWidget {
  const DiseaseSearchField({
    super.key,
    required this.initialValue,
    required this.onSubmitted,
    this.debounce = const Duration(milliseconds: 400),
  });

  /// Текущее committed-значение запроса (для синхронизации поля при входе).
  final String initialValue;

  /// Вызывается с «успокоившимся» текстом (trim'нутым). Если он короче
  /// [kDiseaseSearchMinLength] — приходит пустая строка (фильтр снят).
  final ValueChanged<String> onSubmitted;

  final Duration debounce;

  @override
  State<DiseaseSearchField> createState() => _DiseaseSearchFieldState();
}

class _DiseaseSearchFieldState extends State<DiseaseSearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _commit(String value) {
    final trimmed = value.trim();
    // Меньше порога — фильтр снимаем (показываем весь список), не дёргаем поиск.
    widget.onSubmitted(
      trimmed.length < kDiseaseSearchMinLength ? '' : trimmed,
    );
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce, () => _commit(value));
    setState(() {}); // показ/скрытие кнопки очистки
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
                _commit(value);
              },
              style: TextStyle(fontSize: 14, color: c.ink),
              cursorColor: c.primary,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: l10n.diseaseCatalogSearchHint,
                hintStyle: TextStyle(fontSize: 14, color: c.inkMute),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (hasText)
            Semantics(
              button: true,
              label: l10n.diseaseCatalogSearchClear,
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
