// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telegram_auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State-слой экрана 08 «Вход через Telegram».
///
/// Жизненный цикл:
/// 1. `build` → `POST /auth/telegram/start`: создаёт сессию, открывает deep link
///    бота во внешнем приложении ([LinkLauncher]), запускает обратный отсчёт
///    ресенда из `resendAfterSec`. Ошибка старта → фаза `startFailed`.
/// 2. Пользователь вводит цифры ([appendDigit]/[removeDigit]); по заполнению
///    кода контроллер сам зовёт verify ([_verify]).
/// 3. verify-исход ([TelegramVerifyOutcome]) раскладывается:
///    - success → сессия поднята (data-слой), router-guard уводит; состояние не
///      трогаем;
///    - `invalid_code`/`too_many_attempts`/`session_expired` → инлайн-ошибка
///      ([TelegramCodeError]) + сброс буфера; для протухших сессий UI предложит
///      ресенд;
///    - прочее → дженерик-ошибка (как invalidCode по UX: чистим буфер).
///
/// [resend] / [retryStart] перезапускают старт (новый sessionId).
///
/// autoDispose: при уходе с экрана буфер и таймер сбрасываются. Таймер
/// освобождается в `ref.onDispose` (утечка периодического таймера — реальный баг).
///
/// UI читает `ref.watch(telegramAuthControllerProvider)` ([TelegramAuthState]).

@ProviderFor(TelegramAuthController)
final telegramAuthControllerProvider = TelegramAuthControllerProvider._();

/// State-слой экрана 08 «Вход через Telegram».
///
/// Жизненный цикл:
/// 1. `build` → `POST /auth/telegram/start`: создаёт сессию, открывает deep link
///    бота во внешнем приложении ([LinkLauncher]), запускает обратный отсчёт
///    ресенда из `resendAfterSec`. Ошибка старта → фаза `startFailed`.
/// 2. Пользователь вводит цифры ([appendDigit]/[removeDigit]); по заполнению
///    кода контроллер сам зовёт verify ([_verify]).
/// 3. verify-исход ([TelegramVerifyOutcome]) раскладывается:
///    - success → сессия поднята (data-слой), router-guard уводит; состояние не
///      трогаем;
///    - `invalid_code`/`too_many_attempts`/`session_expired` → инлайн-ошибка
///      ([TelegramCodeError]) + сброс буфера; для протухших сессий UI предложит
///      ресенд;
///    - прочее → дженерик-ошибка (как invalidCode по UX: чистим буфер).
///
/// [resend] / [retryStart] перезапускают старт (новый sessionId).
///
/// autoDispose: при уходе с экрана буфер и таймер сбрасываются. Таймер
/// освобождается в `ref.onDispose` (утечка периодического таймера — реальный баг).
///
/// UI читает `ref.watch(telegramAuthControllerProvider)` ([TelegramAuthState]).
final class TelegramAuthControllerProvider
    extends $NotifierProvider<TelegramAuthController, TelegramAuthState> {
  /// State-слой экрана 08 «Вход через Telegram».
  ///
  /// Жизненный цикл:
  /// 1. `build` → `POST /auth/telegram/start`: создаёт сессию, открывает deep link
  ///    бота во внешнем приложении ([LinkLauncher]), запускает обратный отсчёт
  ///    ресенда из `resendAfterSec`. Ошибка старта → фаза `startFailed`.
  /// 2. Пользователь вводит цифры ([appendDigit]/[removeDigit]); по заполнению
  ///    кода контроллер сам зовёт verify ([_verify]).
  /// 3. verify-исход ([TelegramVerifyOutcome]) раскладывается:
  ///    - success → сессия поднята (data-слой), router-guard уводит; состояние не
  ///      трогаем;
  ///    - `invalid_code`/`too_many_attempts`/`session_expired` → инлайн-ошибка
  ///      ([TelegramCodeError]) + сброс буфера; для протухших сессий UI предложит
  ///      ресенд;
  ///    - прочее → дженерик-ошибка (как invalidCode по UX: чистим буфер).
  ///
  /// [resend] / [retryStart] перезапускают старт (новый sessionId).
  ///
  /// autoDispose: при уходе с экрана буфер и таймер сбрасываются. Таймер
  /// освобождается в `ref.onDispose` (утечка периодического таймера — реальный баг).
  ///
  /// UI читает `ref.watch(telegramAuthControllerProvider)` ([TelegramAuthState]).
  TelegramAuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telegramAuthControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telegramAuthControllerHash();

  @$internal
  @override
  TelegramAuthController create() => TelegramAuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelegramAuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelegramAuthState>(value),
    );
  }
}

String _$telegramAuthControllerHash() =>
    r'407484541b60d530e8534faef7bfff958593f856';

/// State-слой экрана 08 «Вход через Telegram».
///
/// Жизненный цикл:
/// 1. `build` → `POST /auth/telegram/start`: создаёт сессию, открывает deep link
///    бота во внешнем приложении ([LinkLauncher]), запускает обратный отсчёт
///    ресенда из `resendAfterSec`. Ошибка старта → фаза `startFailed`.
/// 2. Пользователь вводит цифры ([appendDigit]/[removeDigit]); по заполнению
///    кода контроллер сам зовёт verify ([_verify]).
/// 3. verify-исход ([TelegramVerifyOutcome]) раскладывается:
///    - success → сессия поднята (data-слой), router-guard уводит; состояние не
///      трогаем;
///    - `invalid_code`/`too_many_attempts`/`session_expired` → инлайн-ошибка
///      ([TelegramCodeError]) + сброс буфера; для протухших сессий UI предложит
///      ресенд;
///    - прочее → дженерик-ошибка (как invalidCode по UX: чистим буфер).
///
/// [resend] / [retryStart] перезапускают старт (новый sessionId).
///
/// autoDispose: при уходе с экрана буфер и таймер сбрасываются. Таймер
/// освобождается в `ref.onDispose` (утечка периодического таймера — реальный баг).
///
/// UI читает `ref.watch(telegramAuthControllerProvider)` ([TelegramAuthState]).

abstract class _$TelegramAuthController extends $Notifier<TelegramAuthState> {
  TelegramAuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TelegramAuthState, TelegramAuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TelegramAuthState, TelegramAuthState>,
              TelegramAuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
