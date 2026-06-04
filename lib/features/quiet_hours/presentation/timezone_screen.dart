import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/known_timezone.dart';
import 'quiet_hours_controller.dart';
import 'timezone_options_provider.dart';

/// Экран 37 «Выбор таймзоны».
///
/// Потребляет `timezoneOptionsProvider` (список `KnownTimezone`) и
/// `quietHoursControllerProvider` (для выбранной таймзоны = `draft.timezone`).
/// Поиск локальный (фильтр по city/iana). Тап по строке →
/// `setTimezone(iana)` + `save()`; успех → pop назад на 23, ошибка
/// (невалидный IANA → 400) → снэкбар, экран НЕ закрывается.
class TimezoneScreen extends ConsumerStatefulWidget {
  const TimezoneScreen({super.key});

  @override
  ConsumerState<TimezoneScreen> createState() => _TimezoneScreenState();
}

class _TimezoneScreenState extends ConsumerState<TimezoneScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  bool _saving = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSelect(String iana) async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(quietHoursControllerProvider.notifier);
    controller.setTimezone(iana);

    setState(() => _saving = true);
    final error = await controller.save();
    if (!mounted) return;

    if (error == null) {
      _pop();
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.messageForError(error))));
    }
  }

  void _pop() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final options = ref.watch(timezoneOptionsProvider);
    // Выбранная определяется драфтом (может быть null при loading/error — тогда
    // галочки нет, выбор всё равно доступен).
    final selectedIana = ref.watch(
      quietHoursControllerProvider.select((s) => s.value?.draft.timezone),
    );

    final filtered = _filter(options, _query);

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(),
            _SearchField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? _EmptyResult(query: _query)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 40),
                      children: [
                        _SectionLabel(text: l10n.timezoneSectionRussia),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: c.line),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              for (var i = 0; i < filtered.length; i++)
                                _TimezoneTile(
                                  option: filtered[i],
                                  selected:
                                      filtered[i].ianaId == selectedIana,
                                  divider: i > 0,
                                  enabled: !_saving,
                                  onTap: () => _onSelect(filtered[i].ianaId),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Локальная фильтрация по городу/IANA (регистронезависимо).
  static List<KnownTimezone> _filter(List<KnownTimezone> all, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return [
      for (final tz in all)
        if (tz.city.toLowerCase().contains(q) ||
            tz.ianaId.toLowerCase().contains(q))
          tz,
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: Row(
            children: [
              _BackButton(tooltip: l10n.timezoneBack),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  l10n.timezoneOverline.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: l10n.timezoneTitleLead),
                TextSpan(
                  text: l10n.timezoneTitleAccent,
                  style: AppTheme.serif(
                    fontSize: 32,
                    color: c.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(text: l10n.timezoneTitleTail),
              ],
            ),
            style: AppTheme.serif(fontSize: 32, color: c.ink),
          ),
        ),
      ],
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 15, color: c.ink),
        decoration: InputDecoration(
          hintText: l10n.timezoneSearchHint,
          hintStyle: TextStyle(fontSize: 15, color: c.inkMute),
          prefixIcon: Icon(Icons.search_rounded, size: 20, color: c.inkSoft),
          filled: true,
          fillColor: c.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: c.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: c.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: c.primary),
          ),
        ),
      ),
    );
  }
}

class _TimezoneTile extends StatelessWidget {
  const _TimezoneTile({
    required this.option,
    required this.selected,
    required this.divider,
    required this.enabled,
    required this.onTap,
  });

  final KnownTimezone option;
  final bool selected;
  final bool divider;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: option.city,
      child: Material(
        color: selected ? c.primarySoft : Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: divider ? Border(top: BorderSide(color: c.line)) : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option.city,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.ianaId,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: c.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  option.gmtLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: c.inkSoft,
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 8),
                  Semantics(
                    label: l10n.timezoneSelectedHint,
                    child: Icon(
                      Icons.check_rounded,
                      size: 20,
                      color: c.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 36, color: c.inkMute),
            const SizedBox(height: 12),
            Text(
              l10n.timezoneEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: c.inkSoft),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: c.inkSoft,
      ),
    );
  }
}
