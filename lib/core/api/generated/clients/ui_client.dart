// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/screen_layout.dart';

part 'ui_client.g.dart';

@RestApi()
abstract class UiClient {
  factory UiClient(Dio dio, {String? baseUrl}) = _UiClient;

  /// SDUI-лейаут экрана.
  ///
  /// Возвращает декларативное описание экрана (Server-Driven UI, MADR-015):.
  /// идентификатор экрана, версию и упорядоченный список блоков. Блоки —.
  /// свободные JSON-объекты с полем `type`; backend их не типизирует.
  /// Клиент рендерит блоки через registry по полю `type`; неизвестные типы.
  /// пропускает (forward-compatibility).
  ///
  /// Заголовок `X-UI-Catalog-Version` (опционально) сообщает серверу версию.
  /// каталога блоков, которую понимает клиент, — сервер может отдать.
  /// совместимый набор блоков.
  ///
  /// [screen] - Идентификатор экрана (например, `home`).
  ///
  /// [locationId] - Необязательный серверный фильтр витрины по комнате (локации).
  /// Применяется экранами, поддерживающими фильтр по комнате (`home`).
  /// Отсутствие параметра или `null` = «Все комнаты» (фильтр не.
  /// применяется). При заданном `locationId` динамические блоки.
  /// (`location_chips.selectedLocationId`, `plant_grid`) гидрируются с.
  /// учётом выбранной комнаты; пустая комната даёт контекстный пустой.
  /// стейт `plant_grid` (см. словарь блоков, MADR-016), а не глобальный.
  /// `empty_state`. Аддитивно и обратносовместимо: старые клиенты.
  /// параметр не шлют и получают прежнее поведение «Все комнаты».
  ///
  ///
  /// [xUiCatalogVersion] - Версия каталога SDUI-блоков, поддерживаемая клиентом. Сервер.
  /// использует её для выдачи совместимого набора блоков. Если не.
  /// передана — сервер отдаёт актуальную версию.
  @GET('/api/v1/ui/{screen}')
  Future<ScreenLayout> getUiScreen({
    @Path('screen') required String screen,
    @Query('locationId') int? locationId,
    @Header('X-UI-Catalog-Version') int? xUiCatalogVersion,
    @Extras() Map<String, dynamic>? extras,
  });
}
