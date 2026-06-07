// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Флаг гостевого аккаунта из `GET /api/v1/me`.
///
/// Используется баннером конвертации на Home-экране. Провайдер инвалидируется
/// после успешной конвертации (баннер исчезает). При ошибке возвращает `null`
/// (баннер тихо скрывается — не блокируем пользователя).
///
/// Не переиспользует [profileSummaryProvider], чтобы инвалидация баннера не
/// сбрасывала всю шапку профиля.

@ProviderFor(meIsGuest)
final meIsGuestProvider = MeIsGuestProvider._();

/// Флаг гостевого аккаунта из `GET /api/v1/me`.
///
/// Используется баннером конвертации на Home-экране. Провайдер инвалидируется
/// после успешной конвертации (баннер исчезает). При ошибке возвращает `null`
/// (баннер тихо скрывается — не блокируем пользователя).
///
/// Не переиспользует [profileSummaryProvider], чтобы инвалидация баннера не
/// сбрасывала всю шапку профиля.

final class MeIsGuestProvider
    extends $FunctionalProvider<AsyncValue<bool?>, bool?, FutureOr<bool?>>
    with $FutureModifier<bool?>, $FutureProvider<bool?> {
  /// Флаг гостевого аккаунта из `GET /api/v1/me`.
  ///
  /// Используется баннером конвертации на Home-экране. Провайдер инвалидируется
  /// после успешной конвертации (баннер исчезает). При ошибке возвращает `null`
  /// (баннер тихо скрывается — не блокируем пользователя).
  ///
  /// Не переиспользует [profileSummaryProvider], чтобы инвалидация баннера не
  /// сбрасывала всю шапку профиля.
  MeIsGuestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meIsGuestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meIsGuestHash();

  @$internal
  @override
  $FutureProviderElement<bool?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool?> create(Ref ref) {
    return meIsGuest(ref);
  }
}

String _$meIsGuestHash() => r'87f85b5256f9168c3cb61686d27ccc59786ad32c';
