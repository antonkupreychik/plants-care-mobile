// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
///
/// Контракт для ui-builder:
/// - `ref.watch(localeNotifierProvider)` → `AsyncValue<Locale>`:
///   - loading → начальная загрузка (FlutterSecureStorage);
///   - data → текущая [Locale];
///   - error → не ожидается (graceful fallback к ru в репозитории).
/// - `ref.read(localeNotifierProvider.notifier).setLanguage(AppLanguage.en)` — переключить язык.
/// - `AppLanguage.fromLocale(locale)` — получить [AppLanguage] из текущей локали.
///
/// Пример подключения к MaterialApp:
/// ```dart
/// locale: ref.watch(localeNotifierProvider).valueOrNull,
/// supportedLocales: AppLocalizations.supportedLocales,
/// localizationsDelegates: AppLocalizations.localizationsDelegates,
/// ```

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
///
/// Контракт для ui-builder:
/// - `ref.watch(localeNotifierProvider)` → `AsyncValue<Locale>`:
///   - loading → начальная загрузка (FlutterSecureStorage);
///   - data → текущая [Locale];
///   - error → не ожидается (graceful fallback к ru в репозитории).
/// - `ref.read(localeNotifierProvider.notifier).setLanguage(AppLanguage.en)` — переключить язык.
/// - `AppLanguage.fromLocale(locale)` — получить [AppLanguage] из текущей локали.
///
/// Пример подключения к MaterialApp:
/// ```dart
/// locale: ref.watch(localeNotifierProvider).valueOrNull,
/// supportedLocales: AppLocalizations.supportedLocales,
/// localizationsDelegates: AppLocalizations.localizationsDelegates,
/// ```
final class LocaleNotifierProvider
    extends $AsyncNotifierProvider<LocaleNotifier, Locale> {
  /// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
  ///
  /// Контракт для ui-builder:
  /// - `ref.watch(localeNotifierProvider)` → `AsyncValue<Locale>`:
  ///   - loading → начальная загрузка (FlutterSecureStorage);
  ///   - data → текущая [Locale];
  ///   - error → не ожидается (graceful fallback к ru в репозитории).
  /// - `ref.read(localeNotifierProvider.notifier).setLanguage(AppLanguage.en)` — переключить язык.
  /// - `AppLanguage.fromLocale(locale)` — получить [AppLanguage] из текущей локали.
  ///
  /// Пример подключения к MaterialApp:
  /// ```dart
  /// locale: ref.watch(localeNotifierProvider).valueOrNull,
  /// supportedLocales: AppLocalizations.supportedLocales,
  /// localizationsDelegates: AppLocalizations.localizationsDelegates,
  /// ```
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

String _$localeNotifierHash() => r'b22866b1bfd70c6a65f0bfa7d0e19e4be4964fd7';

/// Notifier локали приложения. Живёт всё время работы приложения (keepAlive).
///
/// Контракт для ui-builder:
/// - `ref.watch(localeNotifierProvider)` → `AsyncValue<Locale>`:
///   - loading → начальная загрузка (FlutterSecureStorage);
///   - data → текущая [Locale];
///   - error → не ожидается (graceful fallback к ru в репозитории).
/// - `ref.read(localeNotifierProvider.notifier).setLanguage(AppLanguage.en)` — переключить язык.
/// - `AppLanguage.fromLocale(locale)` — получить [AppLanguage] из текущей локали.
///
/// Пример подключения к MaterialApp:
/// ```dart
/// locale: ref.watch(localeNotifierProvider).valueOrNull,
/// supportedLocales: AppLocalizations.supportedLocales,
/// localizationsDelegates: AppLocalizations.localizationsDelegates,
/// ```

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
