// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
///
/// Codegen (Riverpod 3) генерирует переменную **`localeProvider`**.
///
/// Контракт для ui-builder:
/// - `ref.watch(localeProvider)` → `AsyncValue<Locale>`
/// - `ref.read(localeProvider.notifier).setLanguage(AppLanguage.en)`
/// - `AppLanguageFromLocale.fromLocale(locale)` → текущий язык из локали

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
///
/// Codegen (Riverpod 3) генерирует переменную **`localeProvider`**.
///
/// Контракт для ui-builder:
/// - `ref.watch(localeProvider)` → `AsyncValue<Locale>`
/// - `ref.read(localeProvider.notifier).setLanguage(AppLanguage.en)`
/// - `AppLanguageFromLocale.fromLocale(locale)` → текущий язык из локали
final class LocaleNotifierProvider
    extends $AsyncNotifierProvider<LocaleNotifier, Locale> {
  /// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
  ///
  /// Codegen (Riverpod 3) генерирует переменную **`localeProvider`**.
  ///
  /// Контракт для ui-builder:
  /// - `ref.watch(localeProvider)` → `AsyncValue<Locale>`
  /// - `ref.read(localeProvider.notifier).setLanguage(AppLanguage.en)`
  /// - `AppLanguageFromLocale.fromLocale(locale)` → текущий язык из локали
  LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();
}

String _$localeNotifierHash() => r'14b4581012396c3384b8815c0287399f59170123';

/// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
///
/// Codegen (Riverpod 3) генерирует переменную **`localeProvider`**.
///
/// Контракт для ui-builder:
/// - `ref.watch(localeProvider)` → `AsyncValue<Locale>`
/// - `ref.read(localeProvider.notifier).setLanguage(AppLanguage.en)`
/// - `AppLanguageFromLocale.fromLocale(locale)` → текущий язык из локали

abstract class _$LocaleNotifier extends $AsyncNotifier<Locale> {
  FutureOr<Locale> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Locale>, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Locale>, Locale>,
              AsyncValue<Locale>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
