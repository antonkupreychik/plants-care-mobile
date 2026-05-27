import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Выбор ботанической SVG-иллюстрации по виду растения (BACKEND-GAPS G6).
///
/// У backend нет поля иллюстрации — UI подбирает один из 5 ассетов по
/// [Plant.speciesName] (латинское или русское имя), дефолт — `monstera`.
/// Цвета у ассетов «запечены» под светлую тему (компромисс каркаса:
/// исходные SVG из дизайна параметризованы темой, тут — статичные файлы).
enum PlantArt {
  monstera('assets/illustrations/monstera.svg'),
  fern('assets/illustrations/fern.svg'),
  succulent('assets/illustrations/succulent.svg'),
  pothos('assets/illustrations/pothos.svg'),
  cactus('assets/illustrations/cactus.svg');

  const PlantArt(this.asset);

  final String asset;

  /// Сопоставляет имя вида (латиница/кириллица, регистронезависимо) с одним
  /// из 5 ассетов. Нераспознанное / пустое имя → [PlantArt.monstera].
  static PlantArt fromSpecies(String? speciesName) {
    final s = speciesName?.toLowerCase().trim() ?? '';
    if (s.isEmpty) return PlantArt.monstera;

    bool has(List<String> keys) => keys.any(s.contains);

    if (has(const ['fern', 'папоротник', 'nephrolepis', 'asplenium'])) {
      return PlantArt.fern;
    }
    if (has(const [
      'succulent',
      'суккулент',
      'echeveria',
      'эхеверия',
      'sedum',
      'седум',
      'crassula',
      'haworthia',
    ])) {
      return PlantArt.succulent;
    }
    if (has(const [
      'pothos',
      'эпипремнум',
      'epipremnum',
      'scindapsus',
      'сциндапсус',
      'потос',
    ])) {
      return PlantArt.pothos;
    }
    if (has(const [
      'cactus',
      'кактус',
      'cactaceae',
      'opuntia',
      'mammillaria',
    ])) {
      return PlantArt.cactus;
    }
    if (has(const ['monstera', 'монстера', 'deliciosa'])) {
      return PlantArt.monstera;
    }
    return PlantArt.monstera;
  }
}

/// Рендер иллюстрации вида растения через [flutter_svg].
class PlantIllustration extends StatelessWidget {
  const PlantIllustration({
    super.key,
    required this.speciesName,
    this.size = 100,
  });

  final String? speciesName;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      PlantArt.fromSpecies(speciesName).asset,
      width: size,
      height: size,
    );
  }
}
