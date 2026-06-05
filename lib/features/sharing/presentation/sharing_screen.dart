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
import '../../home/domain/plant.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/sharing_member.dart';
import 'sharing_controller.dart';
import 'widgets/sharing_member_tile.dart';
import 'widgets/sharing_plant_select_tile.dart';

/// Экран 26 «Совместный уход»: список текущих соухаживающих + форма
/// приглашения (контакт, выбор растений, право отмечать уход), push
/// `/profile/sharing`.
///
/// Список соухаживающих — `sharingControllerProvider`
/// (`AsyncValue<List<SharingMember>>`): loading → skeleton, error → блок с
/// retry, empty → заглушка, data → список. Форма приглашения берёт растения из
/// `homePlantsProvider` (свои состояния loading/error/empty). Отправка вызывает
/// `invite` и матчит `Result`: success → SnackBar + сброс формы, failure →
/// inline-ошибка по типу `ApiError`.
class SharingScreen extends ConsumerStatefulWidget {
  const SharingScreen({super.key});

  @override
  ConsumerState<SharingScreen> createState() => _SharingScreenState();
}

class _SharingScreenState extends ConsumerState<SharingScreen> {
  final TextEditingController _contact = TextEditingController();

  /// id выбранных растений для приглашения.
  final Set<int> _selectedPlantIds = <int>{};

  bool _canLogCare = true;
  bool _submitting = false;
  bool _submitted = false;
  String? _submitError;

  String get _trimmedContact => _contact.text.trim();
  bool get _contactValid => _trimmedContact.isNotEmpty;
  bool get _plantsValid => _selectedPlantIds.isNotEmpty;
  bool get _formValid => _contactValid && _plantsValid;

  @override
  void dispose() {
    _contact.dispose();
    super.dispose();
  }

  void _togglePlant(int id) {
    setState(() {
      if (!_selectedPlantIds.add(id)) _selectedPlantIds.remove(id);
      if (_submitError != null) _submitError = null;
    });
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (!_formValid || _submitting) return;

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final result = await ref.read(sharingControllerProvider.notifier).invite(
          plantIds: _selectedPlantIds.toList(growable: false),
          inviteeContact: _trimmedContact,
          canLogCare: _canLogCare,
        );

    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    switch (result) {
      case Success():
        // Сброс формы: приглашение появилось в списке выше (рефетч в контроллере).
        setState(() {
          _submitting = false;
          _submitted = false;
          _contact.clear();
          _selectedPlantIds.clear();
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.sharingInviteSuccess)));
      case Failure(:final error):
        setState(() {
          _submitting = false;
          _submitError = l10n.messageForError(error);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    final membersAsync = ref.watch(sharingControllerProvider);
    final plantsAsync = ref.watch(homePlantsProvider);

    final showContactError = _submitted && !_contactValid;
    final showPlantsError = _submitted && !_plantsValid;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _Header(),
                  ),
                  const SizedBox(height: 18),

                  // Секция «Помогают сейчас».
                  _SectionLabel(text: l10n.sharingCurrentLabel),
                  const SizedBox(height: 10),
                  membersAsync.when(
                    loading: () => const _MembersLoading(),
                    error: (error, _) => ErrorState(
                      message: l10n.messageForError(error),
                      retryLabel: l10n.retry,
                      onRetry: () =>
                          ref.invalidate(sharingControllerProvider),
                    ),
                    data: (members) => members.isEmpty
                        ? const _MembersEmpty()
                        : _MembersList(members: members),
                  ),
                  const SizedBox(height: 22),

                  // Секция «Пригласить» — поле контакта.
                  _SectionLabel(text: l10n.sharingInviteLabel),
                  const SizedBox(height: 10),
                  _ContactField(
                    controller: _contact,
                    hasError: showContactError,
                    onChanged: (_) {
                      if (_submitError != null || _submitted) {
                        setState(() {
                          _submitError = null;
                        });
                      }
                    },
                  ),
                  if (showContactError) ...[
                    const SizedBox(height: 6),
                    _InlineError(text: l10n.sharingContactError),
                  ],
                  const SizedBox(height: 22),

                  // Секция выбора растений.
                  _SelectPlantsLabel(count: _selectedPlantIds.length),
                  const SizedBox(height: 10),
                  _PlantsSection(
                    plantsAsync: plantsAsync,
                    selectedIds: _selectedPlantIds,
                    onToggle: _togglePlant,
                    onRetry: () => ref.invalidate(homePlantsProvider),
                  ),
                  if (showPlantsError) ...[
                    const SizedBox(height: 6),
                    _InlineError(text: l10n.sharingNoPlantsError),
                  ],
                  const SizedBox(height: 18),

                  // Право отмечать уход.
                  _PermissionRow(
                    value: _canLogCare,
                    onChanged: (v) => setState(() => _canLogCare = v),
                  ),

                  if (_submitError != null) ...[
                    const SizedBox(height: 16),
                    _SubmitError(message: _submitError!),
                  ],
                ],
              ),
            ),
            _SubmitBar(
              submitting: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Шапка: кнопка «назад» + overline по центру, серифный заголовок и подзаголовок.
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _BackButton(label: l10n.sharingBack),
            Expanded(
              child: Text(
                l10n.sharingOverline.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                  color: c.inkSoft,
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
        const SizedBox(height: 12),
        Text(l10n.sharingTitle, style: AppTheme.serif(fontSize: 34, color: c.ink)),
        const SizedBox(height: 4),
        Text(
          l10n.sharingSubtitle,
          style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.5),
        ),
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
          // Стек пуст (deep link) — уходим на /profile.
          onTap: () => context.canPop() ? context.pop() : context.go('/profile'),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.ink),
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: c.inkSoft,
        ),
      ),
    );
  }
}

/// Заголовок секции выбора растений со счётчиком выбранных справа.
class _SelectPlantsLabel extends StatelessWidget {
  const _SelectPlantsLabel({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.sharingSelectPlantsLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: c.inkSoft,
            ),
          ),
          if (count > 0)
            Text(
              l10n.sharingSelectedCount(count),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  const _MembersList({required this.members});

  final List<SharingMember> members;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < members.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          SharingMemberTile(member: members[i]),
        ],
      ],
    );
  }
}

class _MembersEmpty extends StatelessWidget {
  const _MembersEmpty();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Icon(Icons.group_outlined, size: 32, color: c.leaf),
          const SizedBox(height: 12),
          Text(
            l10n.sharingEmptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.sharingEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _MembersLoading extends StatelessWidget {
  const _MembersLoading();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Column(
      children: [
        for (var i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: c.line),
            ),
            child: const Row(
              children: [
                SkeletonBox(width: 40, height: 40, radius: 20),
                SizedBox(width: 12),
                Expanded(child: SkeletonBox(width: 120, height: 14)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ContactField extends StatelessWidget {
  const _ContactField({
    required this.controller,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: 14, color: c.ink),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline_rounded, size: 20, color: c.inkSoft),
        hintText: l10n.sharingContactHint,
        hintStyle: TextStyle(fontSize: 14, color: c.inkMute),
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: _border(c.line),
        enabledBorder: _border(hasError ? c.terracotta : c.line),
        focusedBorder: _border(hasError ? c.terracotta : c.primary),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: color),
      );
}

/// Секция выбора растений: матчит состояния `homePlantsProvider`.
class _PlantsSection extends StatelessWidget {
  const _PlantsSection({
    required this.plantsAsync,
    required this.selectedIds,
    required this.onToggle,
    required this.onRetry,
  });

  final AsyncValue<List<Plant>> plantsAsync;
  final Set<int> selectedIds;
  final ValueChanged<int> onToggle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return plantsAsync.when(
      loading: () => Column(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: c.line),
              ),
              padding: const EdgeInsets.all(11),
              child: const Row(
                children: [
                  SkeletonBox(width: 42, height: 42, radius: 13),
                  SizedBox(width: 12),
                  Expanded(child: SkeletonBox(width: 100, height: 14)),
                ],
              ),
            ),
          ],
        ],
      ),
      error: (_, _) => _PlantsMessage(text: l10n.sharingPlantsLoadError, onRetry: onRetry),
      data: (plants) => plants.isEmpty
          ? _PlantsMessage(text: l10n.sharingNoPlantsAvailable)
          : Column(
              children: [
                for (var i = 0; i < plants.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  SharingPlantSelectTile(
                    plant: plants[i],
                    selected: selectedIds.contains(plants[i].id),
                    onToggle: () => onToggle(plants[i].id),
                  ),
                ],
              ],
            ),
    );
  }
}

class _PlantsMessage extends StatelessWidget {
  const _PlantsMessage({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.inkSoft, height: 1.4),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sharingPermissionTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  l10n.sharingPermissionHint,
                  style: TextStyle(fontSize: 11, color: c.inkSoft),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: c.primary,
          ),
        ],
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(text, style: TextStyle(fontSize: 12, color: c.terracotta)),
    );
  }
}

class _SubmitError extends StatelessWidget {
  const _SubmitError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.surfaceWarm,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.line),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: c.terracotta),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13, color: c.ink, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

/// Нижняя закреплённая панель с кнопкой отправки приглашения.
class _SubmitBar extends StatelessWidget {
  const _SubmitBar({required this.submitting, required this.onPressed});

  final bool submitting;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      color: c.bg,
      child: Semantics(
        button: true,
        enabled: !submitting,
        label: l10n.sharingSubmit,
        child: Material(
          color: c.ink,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: submitting ? null : onPressed,
            child: SizedBox(
              height: 56,
              child: Center(
                child: submitting
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(c.surface),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_rounded, size: 18, color: c.surface),
                          const SizedBox(width: 8),
                          Text(
                            l10n.sharingSubmit,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: c.surface,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
