import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/error/result.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/plant_template.dart';
import 'plant_template_create_sheet.dart';
import 'plant_template_instantiate_sheet.dart';
import 'plant_templates_controller.dart';
import 'widgets/plant_template_list_tile.dart';

/// Экран «Шаблоны растений» — список шаблонов + действия CRUD.
///
/// Состояния `plantTemplatesControllerProvider`:
/// loading → skeleton; error → [ErrorState] с retry; empty → пустое состояние
/// с кнопкой создать; data → ленивый список шаблонов.
///
/// Создание шаблона — через [showPlantTemplateCreateSheet] (sheet, MADR-005).
/// Инстанцирование — через [showPlantTemplateInstantiateSheet].
/// Удаление — диалог подтверждения, затем delete.
class PlantTemplatesScreen extends ConsumerStatefulWidget {
  const PlantTemplatesScreen({super.key});

  @override
  ConsumerState<PlantTemplatesScreen> createState() =>
      _PlantTemplatesScreenState();
}

class _PlantTemplatesScreenState extends ConsumerState<PlantTemplatesScreen> {
  /// ID шаблонов с активным флоу удаления — защита от двойного тапа.
  final Set<int> _deleting = <int>{};

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(plantTemplatesControllerProvider);

    void openCreate() => showPlantTemplateCreateSheet(context);

    Future<void> deleteTemplate(PlantTemplate template) async {
      if (_deleting.contains(template.id)) return;
      setState(() => _deleting.add(template.id));
      try {
        await _confirmAndDelete(context, template);
      } finally {
        if (mounted) {
          setState(() => _deleting.remove(template.id));
        } else {
          _deleting.remove(template.id);
        }
      }
    }

    Future<void> instantiateTemplate(PlantTemplate template) async {
      await showPlantTemplateInstantiateSheet(context, template: template);
    }

    return Scaffold(
      backgroundColor: c.bg,
      floatingActionButton: async.hasValue
          ? _AddTemplateFab(
              label: l10n.plantTemplatesAdd,
              onPressed: openCreate,
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () => const _PlantTemplatesLoading(),
          error: (error, _) => _PlantTemplatesError(
            message: l10n.messageForError(error),
            onRetry: () =>
                ref.invalidate(plantTemplatesControllerProvider),
          ),
          data: (templates) => _PlantTemplatesContent(
            templates: templates,
            onAdd: openCreate,
            onInstantiate: instantiateTemplate,
            onDelete: deleteTemplate,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndDelete(
    BuildContext context,
    PlantTemplate template,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final notifier =
        ref.read(plantTemplatesControllerProvider.notifier);

    final confirmed = await _confirmDelete(context, template);
    if (confirmed != true || !context.mounted) return;

    final result = await notifier.delete(template.id);
    if (!context.mounted) return;

    switch (result) {
      case Success():
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.plantTemplatesDeleted)),
          );
      case Failure(:final error):
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.messageForError(error))),
          );
    }
  }

  Future<bool?> _confirmDelete(
    BuildContext context,
    PlantTemplate template,
  ) {
    final l10n = AppLocalizations.of(context);
    final c = Theme.of(context).extension<PcColors>()!;
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text(l10n.plantTemplatesDeleteConfirmTitle),
        content: Text(
          l10n.plantTemplatesDeleteConfirmMessage(template.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.plantTemplatesDeleteConfirmCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: c.terracotta,
            ),
            child: Text(l10n.plantTemplatesDeleteConfirmDelete),
          ),
        ],
      ),
    );
  }
}

// ─── Шапка ────────────────────────────────────────────────────────────────────

class _PlantTemplatesHeader extends StatelessWidget {
  const _PlantTemplatesHeader({this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackButton(label: l10n.plantTemplatesBack),
        const SizedBox(height: 14),
        Text(
          l10n.plantTemplatesOverline.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
            color: c.inkSoft,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.plantTemplatesTitle,
          style: AppTheme.serif(fontSize: 40, color: c.ink),
        ),
        if (count != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.plantTemplatesCount(count!),
            style: TextStyle(fontSize: 14, color: c.inkSoft),
          ),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () =>
              context.canPop() ? context.pop() : context.go('/profile'),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
          ),
        ),
      ),
    );
  }
}

// ─── Контент состояний ────────────────────────────────────────────────────────

class _PlantTemplatesContent extends StatelessWidget {
  const _PlantTemplatesContent({
    required this.templates,
    required this.onAdd,
    required this.onInstantiate,
    required this.onDelete,
  });

  final List<PlantTemplate> templates;
  final VoidCallback onAdd;
  final ValueChanged<PlantTemplate> onInstantiate;
  final ValueChanged<PlantTemplate> onDelete;

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        children: [
          const _PlantTemplatesHeader(count: 0),
          const SizedBox(height: 24),
          _PlantTemplatesEmpty(onAdd: onAdd),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 120),
      itemCount: templates.length + 1,
      separatorBuilder: (_, index) =>
          SizedBox(height: index == 0 ? 20 : 8),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _PlantTemplatesHeader(count: templates.length);
        }
        final template = templates[index - 1];
        return PlantTemplateListTile(
          template: template,
          onInstantiate: () => onInstantiate(template),
          onDelete: () => onDelete(template),
        );
      },
    );
  }
}

class _PlantTemplatesEmpty extends StatelessWidget {
  const _PlantTemplatesEmpty({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Icon(Icons.bookmarks_outlined, size: 36, color: c.leaf),
          const SizedBox(height: 14),
          Text(
            l10n.plantTemplatesEmptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.plantTemplatesEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: c.inkSoft,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          _AddTemplateButton(label: l10n.plantTemplatesAdd, onPressed: onAdd),
        ],
      ),
    );
  }
}

class _AddTemplateButton extends StatelessWidget {
  const _AddTemplateButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: c.fab,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 20, color: c.fabInk),
                const SizedBox(width: 8),
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

class _AddTemplateFab extends StatelessWidget {
  const _AddTemplateFab({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: c.fab,
      foregroundColor: c.fabInk,
      icon: const Icon(Icons.add_rounded),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Loading ──────────────────────────────────────────────────────────────────

class _PlantTemplatesLoading extends StatelessWidget {
  const _PlantTemplatesLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      children: [
        const _PlantTemplatesHeader(),
        const SizedBox(height: 24),
        for (var i = 0; i < 4; i++) ...[
          const _TemplateTileSkeleton(),
          if (i < 3) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _TemplateTileSkeleton extends StatelessWidget {
  const _TemplateTileSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          SkeletonBox(width: 40, height: 40, radius: 12),
          const SizedBox(width: 12),
          const Expanded(child: SkeletonBox(width: 120, height: 16)),
          const SizedBox(width: 8),
          SkeletonBox(width: 24, height: 24, radius: 12),
          const SizedBox(width: 4),
          SkeletonBox(width: 24, height: 24, radius: 12),
        ],
      ),
    );
  }
}

// ─── Error ────────────────────────────────────────────────────────────────────

class _PlantTemplatesError extends StatelessWidget {
  const _PlantTemplatesError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      children: [
        const _PlantTemplatesHeader(),
        const SizedBox(height: 24),
        ErrorState(
          message: message,
          retryLabel: l10n.retry,
          onRetry: onRetry,
        ),
      ],
    );
  }
}
