import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/api_error.dart';

part 'telegram_auth_state.freezed.dart';

/// Длина кода Telegram по умолчанию (до ответа start). Backend подтверждает
/// фактическую длину в `codeLength` — UI рисует ячейки по [TelegramAuthState.codeLength].
const int kTelegramCodeLength = 6;

/// Фаза экрана 08 «Вход через Telegram».
enum TelegramAuthPhase {
  /// Идёт `POST /auth/telegram/start` (создаём сессию + открываем deep link).
  starting,

  /// Старт не удался (сеть/backend) — экран показывает ошибку и кнопку повтора.
  startFailed,

  /// Есть активная сессия — пользователь вводит код (основная фаза).
  entering,
}

/// Доменно-значимая ошибка ввода кода, показываемая на самом экране 08 (инлайн,
/// без ухода). `null` — ошибки нет.
enum TelegramCodeError {
  /// `invalid_code` (401) — код не совпал.
  invalidCode,

  /// `too_many_attempts` (429) — лимит исчерпан, сессия погашена; нужен ресенд.
  tooManyAttempts,

  /// `session_expired` (410) — сессия истекла; нужен ресенд (новый sessionId).
  sessionExpired,
}

/// UI-состояние экрана 08 «Вход через Telegram» (`TelegramAuthController`).
///
/// Держит фазу, активную сессию (`sessionId`/`codeLength`/обратный отсчёт
/// ресенда), буфер введённых цифр и флаги верификации/ошибок. freezed-immutable,
/// мутируется только контроллером. Успешная верификация состояния не меняет —
/// сессия поднимается в data-слое, router-guard уводит с экрана.
@freezed
abstract class TelegramAuthState with _$TelegramAuthState {
  const factory TelegramAuthState({
    @Default(TelegramAuthPhase.starting) TelegramAuthPhase phase,

    /// Идентификатор сессии входа из `telegram/start` (`null` до старта).
    String? sessionId,

    /// Длина ожидаемого кода (из `codeLength`).
    @Default(kTelegramCodeLength) int codeLength,

    /// Введённые цифры, 0..[codeLength], только '0'..'9'.
    @Default('') String code,

    /// Секунд до возможности повторно запросить код. 0 → можно ресендить.
    @Default(0) int resendSeconds,

    /// Идёт `POST /auth/telegram/verify` (UI блокирует ввод/клавиатуру).
    @Default(false) bool verifying,

    /// Доменная ошибка ввода кода (инлайн на экране), `null` — нет.
    TelegramCodeError? codeError,

    /// Ошибка старта (фаза [TelegramAuthPhase.startFailed]) — для текста ретрая.
    ApiError? startError,

    /// `telegram_user_not_found` (404) — к Telegram-аккаунту не привязан юзер.
    /// Экран по этому флагу уводит на Welcome с поясняющим текстом про бота
    /// (`ref.listen` на переход в `true`). Регистрации/создания юзера в этом
    /// флоу нет — это вход существующих.
    @Default(false) bool userNotFound,

    /// Код подтверждён, сессия поднята. Экран по переходу флага в `true` уводит
    /// на экран 09 «С возвращением» (`/auth/welcome-back`) — guard-исключение,
    /// иначе авторизованного увело бы сразу на `/home`.
    @Default(false) bool succeeded,
  }) = _TelegramAuthState;

  const TelegramAuthState._();

  /// Код набран полностью (можно/нужно верифицировать).
  bool get isComplete => code.length == codeLength;

  /// Можно повторно запросить код (таймер досчитал до нуля) и мы в фазе ввода.
  bool get canResend =>
      phase == TelegramAuthPhase.entering && resendSeconds == 0 && !verifying;

  /// Идёт стартовый запрос (брендовый сплеш).
  bool get isStarting => phase == TelegramAuthPhase.starting;
}
