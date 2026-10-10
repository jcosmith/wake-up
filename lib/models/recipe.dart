import 'grind.dart';

enum BrewMethod {
  v60('V60', 'Pour over'),
  chemex('Chemex', 'Pour over'),
  kalita('Kalita Wave', 'Pour over'),
  clever('Clever Dripper', 'Immersion + filter'),
  drip('Drip machine', 'Automatic filter'),
  aeropress('AeroPress', 'Immersion + pressure'),
  frenchPress('French Press', 'Immersion'),
  mokaPot('Moka Pot', 'Stovetop'),
  espresso('Espresso', 'Pressure'),
  coldBrew('Cold Brew', 'Cold immersion'),
  icedPourOver('Iced Pour Over', 'Flash-chilled'),
  turkish('Turkish / Cezve', 'Boiled');

  const BrewMethod(this.label, this.style);

  final String label;
  final String style;
}

class BrewStep {
  const BrewStep({
    required this.at,
    required this.title,
    this.detail,
    this.pourTo,
  });

  /// When the step starts, measured from the start of the brew.
  final Duration at;
  final String title;
  final String? detail;

  /// Cumulative water on the scale by the end of this step, in grams, for the
  /// recipe's default dose. Null when the step involves no pouring.
  final double? pourTo;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.method,
    required this.source,
    required this.coffeeGrams,
    required this.waterGrams,
    required this.waterTempC,
    required this.grind,
    required this.totalTime,
    required this.steps,
    this.iceGrams = 0,
    this.grindOffsetMicrons = 0,
    this.summary,
    this.tips = const [],
  });

  final String id;
  final String name;
  final BrewMethod method;

  /// Where the recipe comes from, e.g. a James Hoffmann video.
  final String source;

  final double coffeeGrams;

  /// Total liquid used for brewing, ice excluded.
  final double waterGrams;

  /// Ice in the carafe (iced pour over) — part of the total dilution.
  final double iceGrams;

  /// Null means room temperature or cold water.
  final int? waterTempC;
  final GrindSize grind;

  /// Fine adjustment within the [grind] band, in microns: negative is finer.
  /// Zero for the published recipes; set by community tuning.
  final double grindOffsetMicrons;

  /// Expected brew time; the timer keeps running past it.
  final Duration totalTime;
  final List<BrewStep> steps;
  final String? summary;
  final List<String> tips;

  /// Water-to-coffee ratio, counting ice as water.
  double get ratio => (waterGrams + iceGrams) / coffeeGrams;

  /// Factor to multiply this recipe's quantities by for the given dose.
  double scaleFor(double coffee) => coffee / coffeeGrams;

  Recipe copyWith({double? coffeeGrams, double? grindOffsetMicrons}) => Recipe(
    id: id,
    name: name,
    method: method,
    source: source,
    coffeeGrams: coffeeGrams ?? this.coffeeGrams,
    waterGrams: waterGrams,
    waterTempC: waterTempC,
    grind: grind,
    totalTime: totalTime,
    steps: steps,
    iceGrams: iceGrams,
    grindOffsetMicrons: grindOffsetMicrons ?? this.grindOffsetMicrons,
    summary: summary,
    tips: tips,
  );
}
