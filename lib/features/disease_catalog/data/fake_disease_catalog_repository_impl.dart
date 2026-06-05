import '../../../core/error/api_error.dart';
import '../../../core/error/result.dart';
import '../domain/disease.dart';
import '../domain/disease_repository.dart';

/// Заглушка [DiseaseCatalogRepository] до появления backend-эндпоинтов
/// (`plants-care#225`). Отдаёт несколько хардкодных распространённых
/// болезней/вредителей. Поиск — подстрока по названию ИЛИ симптомам,
/// регистронезависимо (как описано в AC issue #68).
///
/// Когда эндпоинты появятся — заменяется на `DiseaseCatalogRepositoryImpl`
/// поверх OpenAPI-клиента (меняется только провайдер, контракт тот же).
class FakeDiseaseCatalogRepositoryImpl implements DiseaseCatalogRepository {
  const FakeDiseaseCatalogRepositoryImpl();

  static const List<Disease> _diseases = [
    Disease(
      id: 1,
      name: 'Паутинный клещ',
      latinName: 'Tetranychus urticae',
      symptoms: 'Мелкие светлые точки на листьях, тонкая паутинка между '
          'листьями и в пазухах, листья желтеют и опадают.',
      treatment: 'Промыть растение под душем, изолировать от других. Обработать '
          'акарицидом (например, на основе абамектина) дважды с интервалом 7 дней.',
      prevention: 'Поддерживать влажность воздуха, регулярно опрыскивать, '
          'осматривать обратную сторону листьев.',
    ),
    Disease(
      id: 2,
      name: 'Щитовка',
      latinName: 'Diaspididae',
      symptoms: 'Коричневые или бежевые бугорки-«щитки» на стеблях и листьях, '
          'липкий налёт (падь), замедление роста.',
      treatment: 'Снять щитки механически ватной палочкой со спиртом, обработать '
          'системным инсектицидом. Повторять до полного исчезновения.',
      prevention: 'Карантин новых растений, регулярный осмотр стеблей и черешков.',
    ),
    Disease(
      id: 3,
      name: 'Мучнистый червец',
      latinName: 'Pseudococcidae',
      symptoms: 'Белый ватообразный налёт в пазухах листьев и на корнях, '
          'липкие выделения, деформация молодых побегов.',
      treatment: 'Удалить налёт спиртовым раствором, обработать инсектицидом. '
          'При поражении корней — пересадить со сменой грунта.',
      prevention: 'Не переувлажнять, не перекармливать азотом, осматривать '
          'пазухи листьев.',
    ),
    Disease(
      id: 4,
      name: 'Тля',
      latinName: 'Aphidoidea',
      symptoms: 'Скопления мелких зелёных или чёрных насекомых на молодых '
          'побегах и бутонах, скрученные деформированные листья, липкий налёт.',
      treatment: 'Смыть струёй воды или мыльным раствором, при сильном '
          'поражении — обработать инсектицидом.',
      prevention: 'Осматривать молодые побеги, не допускать загущения, '
          'проветривать помещение.',
    ),
  ];

  @override
  Future<Result<List<Disease>>> getAll() async =>
      const Result.success(_diseases);

  @override
  Future<Result<List<Disease>>> search(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const Result.success(_diseases);
    final matched = _diseases
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.symptoms.toLowerCase().contains(q))
        .toList();
    return Result.success(matched);
  }

  @override
  Future<Result<Disease>> getById(int id) async {
    for (final d in _diseases) {
      if (d.id == id) return Result.success(d);
    }
    return const Result.failure(ApiError.notFound());
  }
}
