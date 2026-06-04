// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой фичи «Месячный отчёт» (экран 14).
///
/// Контракт для ui-builder:
/// - [currentReportMonthProvider] → строка `YYYY-MM` текущего месяца (из
///   `clockProvider`, в локальной TZ пользователя).
/// - [selectedReportMonthProvider] → строка `YYYY-MM` выбранного месяца;
///   по умолчанию — текущий месяц. Переключается через [SelectedReportMonthNotifier].
/// - [monthlyReportProvider]`(month)` → `AsyncValue<MonthlyReport>` (family по
///   строке `YYYY-MM`). Экран дёргает
///   `monthlyReportProvider(ref.watch(selectedReportMonthProvider))`.
///
/// В `AsyncError` лежит типизированный [ApiError] (см. [_unwrap]) — UI маппит
/// его в текст через `AppLocalizations`. Empty-state экрана определяется по
/// `report.isEmpty`; общий процент вовремя — `report.onTimePct` (nullable).
/// Текущий месяц отчёта в формате `YYYY-MM`, посчитанный из `clockProvider`
/// (UTC → локальная TZ пользователя). Не используем `DateTime.now()` напрямую
/// (FLUTTER.md «Время»: тестируемость через инжектируемый Clock).

@ProviderFor(currentReportMonth)
final currentReportMonthProvider = CurrentReportMonthProvider._();

/// State-слой фичи «Месячный отчёт» (экран 14).
///
/// Контракт для ui-builder:
/// - [currentReportMonthProvider] → строка `YYYY-MM` текущего месяца (из
///   `clockProvider`, в локальной TZ пользователя).
/// - [selectedReportMonthProvider] → строка `YYYY-MM` выбранного месяца;
///   по умолчанию — текущий месяц. Переключается через [SelectedReportMonthNotifier].
/// - [monthlyReportProvider]`(month)` → `AsyncValue<MonthlyReport>` (family по
///   строке `YYYY-MM`). Экран дёргает
///   `monthlyReportProvider(ref.watch(selectedReportMonthProvider))`.
///
/// В `AsyncError` лежит типизированный [ApiError] (см. [_unwrap]) — UI маппит
/// его в текст через `AppLocalizations`. Empty-state экрана определяется по
/// `report.isEmpty`; общий процент вовремя — `report.onTimePct` (nullable).
/// Текущий месяц отчёта в формате `YYYY-MM`, посчитанный из `clockProvider`
/// (UTC → локальная TZ пользователя). Не используем `DateTime.now()` напрямую
/// (FLUTTER.md «Время»: тестируемость через инжектируемый Clock).

final class CurrentReportMonthProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// State-слой фичи «Месячный отчёт» (экран 14).
  ///
  /// Контракт для ui-builder:
  /// - [currentReportMonthProvider] → строка `YYYY-MM` текущего месяца (из
  ///   `clockProvider`, в локальной TZ пользователя).
  /// - [selectedReportMonthProvider] → строка `YYYY-MM` выбранного месяца;
  ///   по умолчанию — текущий месяц. Переключается через [SelectedReportMonthNotifier].
  /// - [monthlyReportProvider]`(month)` → `AsyncValue<MonthlyReport>` (family по
  ///   строке `YYYY-MM`). Экран дёргает
  ///   `monthlyReportProvider(ref.watch(selectedReportMonthProvider))`.
  ///
  /// В `AsyncError` лежит типизированный [ApiError] (см. [_unwrap]) — UI маппит
  /// его в текст через `AppLocalizations`. Empty-state экрана определяется по
  /// `report.isEmpty`; общий процент вовремя — `report.onTimePct` (nullable).
  /// Текущий месяц отчёта в формате `YYYY-MM`, посчитанный из `clockProvider`
  /// (UTC → локальная TZ пользователя). Не используем `DateTime.now()` напрямую
  /// (FLUTTER.md «Время»: тестируемость через инжектируемый Clock).
  CurrentReportMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentReportMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentReportMonthHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentReportMonth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentReportMonthHash() =>
    r'3fb5d63a054053c65767eea93a62263f65786531';

/// Notifier выбранного месяца отчёта (экран 14).
///
/// Начальное состояние — текущий месяц из [currentReportMonthProvider].
/// Переключение строго ограничено:
/// - назад: не более [_kMaxMonthsBack] месяцев от текущего;
/// - вперёд: не дальше текущего месяца (нет будущих месяцев).
///
/// Кодген генерирует **`selectedReportMonthProvider`**.

@ProviderFor(SelectedReportMonthNotifier)
final selectedReportMonthProvider = SelectedReportMonthNotifierProvider._();

/// Notifier выбранного месяца отчёта (экран 14).
///
/// Начальное состояние — текущий месяц из [currentReportMonthProvider].
/// Переключение строго ограничено:
/// - назад: не более [_kMaxMonthsBack] месяцев от текущего;
/// - вперёд: не дальше текущего месяца (нет будущих месяцев).
///
/// Кодген генерирует **`selectedReportMonthProvider`**.
final class SelectedReportMonthNotifierProvider
    extends $NotifierProvider<SelectedReportMonthNotifier, String> {
  /// Notifier выбранного месяца отчёта (экран 14).
  ///
  /// Начальное состояние — текущий месяц из [currentReportMonthProvider].
  /// Переключение строго ограничено:
  /// - назад: не более [_kMaxMonthsBack] месяцев от текущего;
  /// - вперёд: не дальше текущего месяца (нет будущих месяцев).
  ///
  /// Кодген генерирует **`selectedReportMonthProvider`**.
  SelectedReportMonthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedReportMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedReportMonthNotifierHash();

  @$internal
  @override
  SelectedReportMonthNotifier create() => SelectedReportMonthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedReportMonthNotifierHash() =>
    r'39f15bfd4a58b69096d6e15f6c3b3eb88ef0b1a4';

/// Notifier выбранного месяца отчёта (экран 14).
///
/// Начальное состояние — текущий месяц из [currentReportMonthProvider].
/// Переключение строго ограничено:
/// - назад: не более [_kMaxMonthsBack] месяцев от текущего;
/// - вперёд: не дальше текущего месяца (нет будущих месяцев).
///
/// Кодген генерирует **`selectedReportMonthProvider`**.

abstract class _$SelectedReportMonthNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Месячный отчёт за [month] (`YYYY-MM`, scope user). Family по строке месяца —
/// ui-builder может листать предыдущие месяцы, передавая нужный `YYYY-MM`
/// (валидацию «не в будущее» делает UI/notifier выбора месяца, отдельно).

@ProviderFor(monthlyReport)
final monthlyReportProvider = MonthlyReportFamily._();

/// Месячный отчёт за [month] (`YYYY-MM`, scope user). Family по строке месяца —
/// ui-builder может листать предыдущие месяцы, передавая нужный `YYYY-MM`
/// (валидацию «не в будущее» делает UI/notifier выбора месяца, отдельно).

final class MonthlyReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlyReport>,
          MonthlyReport,
          FutureOr<MonthlyReport>
        >
    with $FutureModifier<MonthlyReport>, $FutureProvider<MonthlyReport> {
  /// Месячный отчёт за [month] (`YYYY-MM`, scope user). Family по строке месяца —
  /// ui-builder может листать предыдущие месяцы, передавая нужный `YYYY-MM`
  /// (валидацию «не в будущее» делает UI/notifier выбора месяца, отдельно).
  MonthlyReportProvider._({
    required MonthlyReportFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'monthlyReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyReportHash();

  @override
  String toString() {
    return r'monthlyReportProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MonthlyReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlyReport> create(Ref ref) {
    final argument = this.argument as String;
    return monthlyReport(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyReportHash() => r'66e39296ecff7efb47ad50767d98e573a6264d44';

/// Месячный отчёт за [month] (`YYYY-MM`, scope user). Family по строке месяца —
/// ui-builder может листать предыдущие месяцы, передавая нужный `YYYY-MM`
/// (валидацию «не в будущее» делает UI/notifier выбора месяца, отдельно).

final class MonthlyReportFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MonthlyReport>, String> {
  MonthlyReportFamily._()
    : super(
        retry: null,
        name: r'monthlyReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Месячный отчёт за [month] (`YYYY-MM`, scope user). Family по строке месяца —
  /// ui-builder может листать предыдущие месяцы, передавая нужный `YYYY-MM`
  /// (валидацию «не в будущее» делает UI/notifier выбора месяца, отдельно).

  MonthlyReportProvider call(String month) =>
      MonthlyReportProvider._(argument: month, from: this);

  @override
  String toString() => r'monthlyReportProvider';
}
