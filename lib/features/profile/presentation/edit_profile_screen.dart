import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/api_error_l10n.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/error_state.dart';
import '../../../l10n/app_localizations.dart';
import 'edit_profile_controller.dart';
import 'edit_profile_state.dart';

/// Экран «Редактировать профиль» (issue #148).
///
/// Вход: кнопка «Редактировать» в шапке [ProfileScreen] →
/// `context.push('/profile/edit')`.
///
/// Роут: `/profile/edit` (на `_rootNavigatorKey`, без таб-бара).
///
/// Форма:
/// - ИМЯ — read-only (PATCH /me не меняет имя, отображаем для контекста).
/// - НАЧАЛО ТИХИХ ЧАСОВ — `HH:mm`, текстовое поле.
/// - КОНЕЦ ТИХИХ ЧАСОВ — `HH:mm`, текстовое поле.
/// - ТАЙМЗОНА — IANA-идентификатор, текстовое поле.
///
/// «Сохранить» активно только при `isDirty && isValid`. После успеха — pop +
/// снэкбар, [profileSummaryProvider] инвалидируется (делает контроллер).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _quietHoursStartCtrl;
  late final TextEditingController _quietHoursEndCtrl;
  late final TextEditingController _timezoneCtrl;
  bool _initialized = false;

  @override
  void dispose() {
    _quietHoursStartCtrl.dispose();
    _quietHoursEndCtrl.dispose();
    _timezoneCtrl.dispose();
    super.dispose();
  }

  /// Инициализируем поля один раз, когда данные впервые загрузились.
  void _initFields(EditProfileState state) {
    if (_initialized) return;
    _initialized = true;
    _quietHoursStartCtrl =
        TextEditingController(text: state.draft.quietHoursStart);
    _quietHoursEndCtrl =
        TextEditingController(text: state.draft.quietHoursEnd);
    _timezoneCtrl = TextEditingController(text: state.draft.timezone);

    _quietHoursStartCtrl.addListener(() {
      ref
          .read(editProfileControllerProvider.notifier)
          .setQuietHoursStart(_quietHoursStartCtrl.text);
    });
    _quietHoursEndCtrl.addListener(() {
      ref
          .read(editProfileControllerProvider.notifier)
          .setQuietHoursEnd(_quietHoursEndCtrl.text);
    });
    _timezoneCtrl.addListener(() {
      ref
          .read(editProfileControllerProvider.notifier)
          .setTimezone(_timezoneCtrl.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = Theme.of(context).extension<PcColors>()!;

    final asyncState = ref.watch(editProfileControllerProvider);

    // Слушаем submitStatus для pop / snackbar.
    ref.listen(editProfileControllerProvider, (prev, next) {
      final s = next.value;
      if (s == null) return;
      if (s.submitStatus == EditProfileSubmitStatus.success) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.editProfileSuccessSnackbar)),
          );
        if (context.canPop()) context.pop();
      } else if (s.submitStatus == EditProfileSubmitStatus.failure &&
          s.submitError != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.messageForError(s.submitError))),
          );
      }
    });

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: asyncState.when(
          loading: () => _buildLoading(context, l10n, c),
          error: (error, _) => _buildError(context, l10n, error),
          data: (state) {
            _initFields(state);
            return _buildForm(context, l10n, c, state);
          },
        ),
      ),
    );
  }

  Widget _buildLoading(
    BuildContext context,
    AppLocalizations l10n,
    PcColors c,
  ) {
    return Column(
      children: [
        _AppBar(
          l10n: l10n,
          c: c,
          canSave: false,
          isSubmitting: false,
          onSave: null,
        ),
        const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }

  Widget _buildError(
    BuildContext context,
    AppLocalizations l10n,
    Object error,
  ) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: ErrorState(
        message: l10n.messageForError(error),
        retryLabel: l10n.retry,
        onRetry: () => ref.invalidate(editProfileControllerProvider),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    AppLocalizations l10n,
    PcColors c,
    EditProfileState state,
  ) {
    return Column(
      children: [
        _AppBar(
          l10n: l10n,
          c: c,
          canSave: state.canSave,
          isSubmitting: state.isSubmitting,
          onSave: state.canSave && !state.isSubmitting
              ? () =>
                  ref.read(editProfileControllerProvider.notifier).submit()
              : null,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ИМЯ (read-only)
                _SectionLabel(label: l10n.editProfileNameLabel, c: c),
                const SizedBox(height: 8),
                _ReadOnlyField(
                  value: state.draft.displayName ?? l10n.profileAnonymous,
                  hint: l10n.editProfileNameReadOnlyHint,
                  c: c,
                ),
                const SizedBox(height: 20),

                // НАЧАЛО ТИХИХ ЧАСОВ
                _SectionLabel(
                  label: l10n.editProfileQuietHoursStartLabel,
                  c: c,
                ),
                const SizedBox(height: 8),
                _ProfileTextField(
                  controller: _quietHoursStartCtrl,
                  hintText: l10n.editProfileTimeHint,
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 20),

                // КОНЕЦ ТИХИХ ЧАСОВ
                _SectionLabel(
                  label: l10n.editProfileQuietHoursEndLabel,
                  c: c,
                ),
                const SizedBox(height: 8),
                _ProfileTextField(
                  controller: _quietHoursEndCtrl,
                  hintText: l10n.editProfileTimeHint,
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 20),

                // ТАЙМЗОНА
                _SectionLabel(label: l10n.editProfileTimezoneLabel, c: c),
                const SizedBox(height: 8),
                _ProfileTextField(
                  controller: _timezoneCtrl,
                  hintText: l10n.editProfileTimezoneHint,
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Шапка экрана: «← Редактировать профиль» слева, «Сохранить» справа.
class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.l10n,
    required this.c,
    required this.canSave,
    required this.isSubmitting,
    required this.onSave,
  });

  final AppLocalizations l10n;
  final PcColors c;
  final bool canSave;
  final bool isSubmitting;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: c.ink),
            tooltip: l10n.editProfileTitle,
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
          Expanded(
            child: Text(
              l10n.editProfileTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: c.ink,
              ),
            ),
          ),
          if (isSubmitting)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: onSave,
              child: Text(
                l10n.editProfileSave,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: canSave ? null : Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Заголовок секции формы.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.c,
  });

  final String label;
  final PcColors c;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: c.inkSoft,
      ),
    );
  }
}

/// Текстовое поле формы.
class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<PcColors>()!;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 15, color: c.ink),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: c.inkMute),
        filled: true,
        fillColor: c.surface,
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
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

/// Поле только для чтения (имя пользователя).
class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.value,
    required this.hint,
    required this.c,
  });

  final String value;
  final String hint;
  final PcColors c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: c.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.line.withValues(alpha: 0.5)),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 15, color: c.inkMute),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: TextStyle(fontSize: 11, color: c.inkMute),
        ),
      ],
    );
  }
}
