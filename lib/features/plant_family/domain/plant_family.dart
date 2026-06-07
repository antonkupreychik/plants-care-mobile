import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_family.freezed.dart';

/// Один узел родословной — короткое представление растения (источник:
/// `PlantFamilyMemberDto`).
///
/// Чистый Dart, иммутабельно. Несёт ровно то, что отдаёт backend для обхода
/// семьи: идентификатор (для навигации в карточку 02) и имя.
@freezed
abstract class PlantFamilyMember with _$PlantFamilyMember {
  const factory PlantFamilyMember({
    /// Идентификатор растения-узла (навигация в карточку `plants/:id`).
    required int id,

    /// Отображаемое имя растения.
    required String name,
  }) = _PlantFamilyMember;
}

/// Родословная растения (экран 18): материнское растение и прямые потомки
/// (отводки). Источник — `GET /plants/{id}/family` (`PlantFamilyResponse`).
///
/// Backend отдаёт ровно один уровень в каждую сторону: [parent] (или `null`,
/// если растение — корень своей семьи) и прямые [children]. Многоуровневый
/// обход дерева делается навигацией по узлам (тап по члену → его карточка →
/// его родословная), сервер рекурсию не разворачивает.
@freezed
abstract class PlantFamily with _$PlantFamily {
  const factory PlantFamily({
    /// Материнское растение, от которого получен текущий отводок. `null` —
    /// текущее растение не является чьим-то потомком (корень семьи).
    PlantFamilyMember? parent,

    /// Прямые потомки/отводки текущего растения, в порядке backend.
    required List<PlantFamilyMember> children,
  }) = _PlantFamily;

  const PlantFamily._();

  /// Есть ли вообще связи (родитель или хотя бы один потомок). `false` —
  /// одиночное растение без родословной (UI рисует empty-состояние).
  bool get hasRelations => parent != null || children.isNotEmpty;
}
