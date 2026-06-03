import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/care/care_task_l10n.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../today_view.dart';

/// Свёрнутая секция «Выполнено» экрана 03 «Сегодня».
///
/// Collapsed: одна карточка-сводка «N выполнено сегодня» + подпись с последней
/// отметкой («Колючка · полит в 7:42») и шеврон. Tap — раскрывает список
/// выполненных задач (анимированно). Tap по строке выполненной задачи —
/// [onTaskTap] (открывает sheet ухода 06, чтобы можно было перелогировать).
///
/// Stateful: коллапс — локальное UI-состояние секции, а не доменные данные
/// (FLUTTER.md: UI-состояние без своего провайдера, если оно эфемерно).
class TodayDoneSection extends StatefulWidget {
  const TodayDoneSection({
    super.key,
    required this.items,
    required this.onTaskTap,
  });

  /// Выполненные задачи, отсортированы по `doneAt` убыванию (последняя сверху).
  final List<TodayTaskItem> items;
  final void Function(TodayTaskItem item) onTaskTap;

  @override
  State<TodayDoneSection> createState() => _TodayDoneSectionState();
}

class _TodayDoneSectionState extends State<TodayDoneSection> {
  bool _expanded = false;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final last = widget.items.first;

    return Container(
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Semantics(
            button: true,
            expanded: _expanded,
            label: _expanded ? l10n.todayDoneCollapse : l10n.todayDoneExpand,
            child: InkWell(
              onTap: _toggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c.primarySoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.check_rounded, size: 16, color: c.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.todayDoneTitle(widget.items.length),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: c.ink,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            _subtitle(l10n, last),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: c.inkSoft),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: c.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 180),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                for (final item in widget.items)
                  _DoneRow(
                    item: item,
                    onTap: () => widget.onTaskTap(item),
                  ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _subtitle(AppLocalizations l10n, TodayTaskItem item) {
    final time = DateFormat.Hm(l10n.localeName).format(item.task.doneAt!.toLocal());
    return l10n.todayDoneSubtitle(
      item.task.plantName,
      item.task.type.doneLabel(l10n).toLowerCase(),
      time,
    );
  }
}

/// Строка одной выполненной задачи внутри раскрытой секции.
class _DoneRow extends StatelessWidget {
  const _DoneRow({required this.item, required this.onTap});

  final TodayTaskItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final task = item.task;
    final time = DateFormat.Hm(l10n.localeName).format(task.doneAt!.toLocal());

    return Semantics(
      button: true,
      label: '${task.plantName}, ${task.type.doneLabel(l10n)}',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Icon(task.type.icon, size: 16, color: c.inkSoft),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task.plantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: c.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.careDonePast(task.type.doneLabel(l10n).toLowerCase(), time),
                style: TextStyle(fontSize: 11, color: c.inkSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
