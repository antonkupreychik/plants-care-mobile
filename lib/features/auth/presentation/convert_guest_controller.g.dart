// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_guest_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Контроллер экрана конвертации гостевого аккаунта.
///
/// Контракт для ui-builder:
/// - провайдер `convertGuestControllerProvider` → [ConvertGuestState];
/// - [convertWithEmail] — конвертация через email magic-link;
/// - [convertWithGoogle] / [convertWithApple] — социальные провайдеры;
/// - По успеху Google/Apple: router-guard сам уведёт, `status = converted`;
///   инвалидирует [meIsGuestProvider] чтобы баннер исчез.
/// - По email success: `status = emailSent` (показываем «проверьте почту»).
/// - При ошибке: `error` заполнен, `inProgress` сброшен.

@ProviderFor(ConvertGuestController)
final convertGuestControllerProvider = ConvertGuestControllerProvider._();

/// Контроллер экрана конвертации гостевого аккаунта.
///
/// Контракт для ui-builder:
/// - провайдер `convertGuestControllerProvider` → [ConvertGuestState];
/// - [convertWithEmail] — конвертация через email magic-link;
/// - [convertWithGoogle] / [convertWithApple] — социальные провайдеры;
/// - По успеху Google/Apple: router-guard сам уведёт, `status = converted`;
///   инвалидирует [meIsGuestProvider] чтобы баннер исчез.
/// - По email success: `status = emailSent` (показываем «проверьте почту»).
/// - При ошибке: `error` заполнен, `inProgress` сброшен.
final class ConvertGuestControllerProvider
    extends $NotifierProvider<ConvertGuestController, ConvertGuestState> {
  /// Контроллер экрана конвертации гостевого аккаунта.
  ///
  /// Контракт для ui-builder:
  /// - провайдер `convertGuestControllerProvider` → [ConvertGuestState];
  /// - [convertWithEmail] — конвертация через email magic-link;
  /// - [convertWithGoogle] / [convertWithApple] — социальные провайдеры;
  /// - По успеху Google/Apple: router-guard сам уведёт, `status = converted`;
  ///   инвалидирует [meIsGuestProvider] чтобы баннер исчез.
  /// - По email success: `status = emailSent` (показываем «проверьте почту»).
  /// - При ошибке: `error` заполнен, `inProgress` сброшен.
  ConvertGuestControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'convertGuestControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$convertGuestControllerHash();

  @$internal
  @override
  ConvertGuestController create() => ConvertGuestController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConvertGuestState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConvertGuestState>(value),
    );
  }
}

String _$convertGuestControllerHash() =>
    r'a5665fe55a918e5f1887e5d6d739a31ab74d8208';

/// Контроллер экрана конвертации гостевого аккаунта.
///
/// Контракт для ui-builder:
/// - провайдер `convertGuestControllerProvider` → [ConvertGuestState];
/// - [convertWithEmail] — конвертация через email magic-link;
/// - [convertWithGoogle] / [convertWithApple] — социальные провайдеры;
/// - По успеху Google/Apple: router-guard сам уведёт, `status = converted`;
///   инвалидирует [meIsGuestProvider] чтобы баннер исчез.
/// - По email success: `status = emailSent` (показываем «проверьте почту»).
/// - При ошибке: `error` заполнен, `inProgress` сброшен.

abstract class _$ConvertGuestController extends $Notifier<ConvertGuestState> {
  ConvertGuestState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ConvertGuestState, ConvertGuestState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConvertGuestState, ConvertGuestState>,
              ConvertGuestState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
