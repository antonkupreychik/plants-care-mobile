// Бандлер многофайловой OpenAPI-спеки backend (`api/openapi/`) в единый
// `api/openapi.bundled.json` для swagger_parser (MADR-007).
//
// Зачем свой: спека `plants-care` разбита через $ref на resources/*.yaml и
// _common/*.yaml с кастомными top-level ключами (`#/paths/<Key>`,
// `#/schemas/<X>`), а swagger_parser ждёт единый документ. Внешние bundler'ы
// (redocly/swagger-cli) тянутся как произвольные npm-пакеты — не используем.
//
// Допущения (проверены по факту на спеке): нет allOf/oneOf/anyOf/discriminator;
// имена схем/параметров/ответов глобально уникальны. Поэтому собираем
// components по имени и переписываем все $ref на `#/components/...`.
//
// Запуск: dart run tool/bundle_openapi.dart
import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

const _srcDir = 'api/openapi';
const _outFile = 'api/openapi.bundled.json';

void main() {
  final root = _load('$_srcDir/openapi.yaml');

  // 1. Собираем components по имени из исходных файлов.
  final schemas = <String, dynamic>{};
  final resourceFiles = Directory('$_srcDir/resources')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.yaml'))
      .toList();
  for (final f in resourceFiles) {
    final doc = _load(f.path);
    _mergeSchemas(schemas, doc['schemas']);
  }
  _mergeSchemas(schemas, _load('$_srcDir/_common/errors.yaml')['schemas']);

  final parameters =
      Map<String, dynamic>.from(_load('$_srcDir/_common/parameters.yaml'));
  final responses =
      Map<String, dynamic>.from(_load('$_srcDir/_common/responses.yaml'));

  // 2. Резолвим root paths ($ref → ./resources/X.yaml#/paths/<Key>).
  final outPaths = <String, dynamic>{};
  (root['paths'] as Map).forEach((path, refObj) {
    final ref = (refObj as Map)[r'$ref'] as String;
    final hash = ref.indexOf('#');
    final file = ref.substring(0, hash); // ./resources/X.yaml
    final key = ref.substring(hash + 1).split('/').last; // Collection / Item / ...
    final resDoc = _load('$_srcDir/${file.replaceFirst('./', '')}');
    outPaths[path] = (resDoc['paths'] as Map)[key];
  });

  // 3. Сборка документа.
  final bundled = <String, dynamic>{
    'openapi': root['openapi'],
    'info': root['info'],
    if (root['servers'] != null) 'servers': root['servers'],
    if (root['tags'] != null) 'tags': root['tags'],
    'paths': outPaths,
    'components': {
      'parameters': parameters,
      'responses': responses,
      'schemas': schemas,
    },
  };

  // 4. Переписываем все $ref на локальные #/components/...
  final rewritten = _rewrite(bundled);

  File(_outFile).writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(rewritten),
  );

  final p = (rewritten['paths'] as Map).length;
  final s = ((rewritten['components'] as Map)['schemas'] as Map).length;
  stdout.writeln('Bundled → $_outFile  (paths: $p, schemas: $s)');
}

Map<String, dynamic> _load(String path) =>
    _plain(loadYaml(File(path).readAsStringSync())) as Map<String, dynamic>;

void _mergeSchemas(Map<String, dynamic> into, dynamic from) {
  if (from is Map) {
    from.forEach((k, v) => into[k.toString()] = v);
  }
}

dynamic _plain(dynamic v) {
  if (v is YamlMap) {
    return {for (final e in v.entries) e.key.toString(): _plain(e.value)};
  }
  if (v is YamlList) return [for (final e in v) _plain(e)];
  return v;
}

dynamic _rewrite(dynamic node) {
  if (node is Map) {
    final out = <String, dynamic>{};
    node.forEach((k, v) {
      if (k == r'$ref' && v is String) {
        out[k] = _remap(v);
      } else {
        out[k] = _rewrite(v);
      }
    });
    return out;
  }
  if (node is List) return [for (final e in node) _rewrite(e)];
  return node;
}

/// Любой внешний/локальный $ref → ссылка на собранные components по имени.
String _remap(String ref) {
  final hash = ref.indexOf('#');
  final filePart = hash >= 0 ? ref.substring(0, hash) : '';
  final frag = hash >= 0 ? ref.substring(hash + 1) : '';

  if (frag.startsWith('/schemas/')) {
    return '#/components/schemas/${frag.substring('/schemas/'.length)}';
  }
  if (filePart.endsWith('parameters.yaml')) {
    return '#/components/parameters/${frag.replaceFirst('/', '')}';
  }
  if (filePart.endsWith('responses.yaml')) {
    return '#/components/responses/${frag.replaceFirst('/', '')}';
  }
  if (frag.startsWith('/components/')) return '#$frag';
  return ref; // неизвестная форма — оставляем как есть (всплывёт при валидации)
}
