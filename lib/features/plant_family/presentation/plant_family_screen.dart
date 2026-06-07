import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/plant_family.dart';
import 'plant_family_providers.dart';
import 'widgets/family_connector.dart';
import 'widgets/family_empty.dart';
import 'widgets/family_member_node.dart';

/// Экран 18 «Родословная / размножение».
///
/// Показывает родословную растения — материнское растение (родитель) и прямые
/// потомки/отводки — из [plantFamilyProvider] (`GET /plants/{id}/family`).
/// Многоуровневый обход семьи: тап по члену → его карточка (02) → оттуда его
/// родословная. Backend разворачивает один уровень в каждую сторону.
///
/// Имя текущего растения (для шапки/визуализации) опционально приходит через
/// `extra` роутера (как в `editSchedule`); если его нет — шапка показывает
/// только overline.
///
/// Состояния: loading (индикатор), error (баннер + retry → invalidate),
/// empty (нет родителя и отводков → [FamilyEmpty]), data (визуализация).
class PlantFamilyScreen extends ConsumerWidget {
  const PlantFamilyScreen({super.key, required this.plantId, this.plantName});

  final int plantId;

  /// Имя текущего растения (опционально, для шапки и узла «это растение»).
  final String? plantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final family = ref.watch(plantFamilyProvider(plantId));

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(plantName: plantName),
            Expanded(
              child: family.when(
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                error: (error, _) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  child: ErrorState(
                    message: l10n.messageForError(error),
                    retryLabel: l10n.retry,
                    onRetry: () =>
                        ref.invalidate(plantFamilyProvider(plantId)),
                  ),
                ),
                data: (family) => _DataView(
                  plantId: plantId,
                  plantName: plantName,
                  family: family,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: «назад», overline «Родословная» + имя растения (если известно).
class _TopBar extends StatelessWidget {
  const _TopBar({required this.plantName});

  final String? plantName;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final hasName = plantName != null && plantName!.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Row(
        children: [
          _BackButton(
            tooltip: l10n.plantCardBack,
            onPressed: () => _onBack(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  l10n.plantFamilyOverline.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: c.inkSoft,
                  ),
                ),
                if (hasName) ...[
                  const SizedBox(height: 2),
                  Text(
                    plantName!.trim(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.serif(fontSize: 20, color: c.ink),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

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
          onTap: onPressed,
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

/// Содержимое: визуализация «родитель → это растение» + список отводков, либо
/// empty-состояние, если связей нет.
class _DataView extends StatelessWidget {
  const _DataView({
    required this.plantId,
    required this.plantName,
    required this.family,
  });

  final int plantId;
  final String? plantName;
  final PlantFamily family;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (!family.hasRelations) {
      return const SingleChildScrollView(child: FamilyEmpty());
    }

    final currentName = (plantName != null && plantName!.trim().isNotEmpty)
        ? plantName!.trim()
        : l10n.plantFamilyCurrentLabel;

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 40),
      children: [
        // Заголовок секции.
        Text(
          l10n.plantFamilyTitle,
          style: AppTheme.serif(fontSize: 28),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.plantFamilySubtitle,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).extension<PcColors>()!.inkSoft,
          ),
        ),
        const SizedBox(height: 24),

        // Линия «родитель → это растение». Родитель кликабелен (обход семьи).
        _LineageRow(
          plantId: plantId,
          currentName: currentName,
          parent: family.parent,
        ),

        // Прямые потомки/отводки.
        if (family.children.isNotEmpty) ...[
          const SizedBox(height: 28),
          _ChildrenSection(plantId: plantId, family: family),
        ],
      ],
    );
  }
}

/// Ряд «родитель (если есть) → стрелка → текущее растение».
class _LineageRow extends StatelessWidget {
  const _LineageRow({
    required this.plantId,
    required this.currentName,
    required this.parent,
  });

  final int plantId;
  final String currentName;
  final PlantFamilyMember? parent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (parent != null) ...[
            FamilyMemberNode(
              name: parent!.name,
              roleLabel: l10n.plantFamilyParentLabel,
              onTap: () => _openMember(context, parent!.id),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14, left: 4, right: 4),
              child: FamilyConnector(),
            ),
          ],
          FamilyMemberNode(
            name: currentName,
            roleLabel: l10n.plantFamilyCurrentLabel,
            isCurrent: true,
          ),
        ],
      ),
    );
  }
}

/// Секция прямых потомков: счётчик + сетка узлов (каждый кликабелен).
class _ChildrenSection extends StatelessWidget {
  const _ChildrenSection({required this.plantId, required this.family});

  final int plantId;
  final PlantFamily family;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.plantFamilyChildrenLabel.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: c.inkSoft,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.plantFamilyChildrenCount(family.children.length),
              style: TextStyle(fontSize: 12, color: c.inkMute),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final child in family.children)
              FamilyMemberNode(
                name: child.name,
                roleLabel: l10n.plantFamilyChildLabel,
                onTap: () => _openMember(context, child.id),
              ),
          ],
        ),
      ],
    );
  }
}

/// Навигация в карточку другого члена семьи (обход дерева). Используем `push`,
/// чтобы стек «карточка → родословная → карточка члена» был обратимым.
void _openMember(BuildContext context, int memberId) {
  context.pushNamed(
    'plantCard',
    pathParameters: {'id': '$memberId'},
  );
}
