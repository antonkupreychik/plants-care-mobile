import '../../../core/error/result.dart';

/// Контракт data-слоя мастера «Взять черенок» (экран 18).
///
/// Уникальное для фичи — создание ростка, привязанного к родителю через
/// `parentPlantId` (`POST /plants`, scope user). Имя родителя и прочая деталь
/// приходят через переиспользуемый `plantDetailProvider` карточки растения —
/// здесь не дублируем `GET /plants/{id}`.
///
/// Методы возвращают `Future<Result<T>>` и НЕ бросают наружу (MADR-011).
abstract interface class TakeCuttingRepository {
  /// Создать росток-потомок (`POST /plants` с `parentPlantId`).
  ///
  /// Возвращает id созданной записи (`PlantDto.id`), чтобы UI мог
  /// инвалидировать сад и навигировать на карточку ростка.
  ///
  /// Тип размножения и дата среза в `POST /plants` не уходят (backend-поля
  /// пока нет; см. [PropagationMethod]) — собираются в состоянии мастера, но
  /// на сервер из них уходит только связь `parentPlantId`.
  Future<Result<int>> createCutting({
    required String name,
    required int parentPlantId,
  });
}
