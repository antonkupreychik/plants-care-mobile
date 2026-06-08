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
  /// [xUiCatalogVersion] - Версия каталога SDUI-блоков, поддерживаемая клиентом. Сервер.
  /// использует её для выдачи совместимого набора блоков. Если не.
  /// передана — сервер отдаёт актуальную версию.
  @GET('/api/v1/ui/{screen}')
  Future<ScreenLayout> getUiScreen({
    @Path('screen') required String screen,
    @Header('X-UI-Catalog-Version') int? xUiCatalogVersion,
    @Extras() Map<String, dynamic>? extras,
  });
}
