import 'feedback.dart';
import 'recipe.dart';

/// A version of a recipe tuned from everyone's feedback.
///
/// Each piece of feedback is read as a guess at the ideal brew: what was
/// brewed, nudged the way the taste notes point (sour → finer, bitter →
/// coarser; weak → more coffee, strong → less). The guesses are averaged and
/// pulled towards the original recipe while there are only a few of them, so
/// one odd brew can't swing it. Feedback on a tuned brew is relative to the
/// tuned settings, which lets the tuning settle instead of drifting.
class RecipeTuning {
  RecipeTuning._({
    required this.base,
    required this.brews,
    required this.ratio,
    required this.grindOffsetMicrons,
    required this.averageRating,
  });

  factory RecipeTuning.from(Recipe base, Iterable<RecipeFeedback> feedback) {
    final relevant = feedback.where((f) => f.recipeId == base.id).toList();
    final n = relevant.length;
    if (n == 0) {
      return RecipeTuning._(
        base: base,
        brews: 0,
        ratio: base.ratio,
        grindOffsetMicrons: base.grindOffsetMicrons,
        averageRating: null,
      );
    }

    var ratioSum = 0.0;
    var grindSum = 0.0;
    var ratingSum = 0;
    for (final f in relevant) {
      ratioSum += f.brewedRatio * (1 + ratioStepPerPoint * f.strength.value);
      grindSum +=
          f.brewedGrindOffsetMicrons + micronsPerTastePoint * f.taste.value;
      ratingSum += f.rating;
    }
    final weight = n / (n + priorBrews);
    double towards(double from, double to) => from + (to - from) * weight;

    final ratio = towards(base.ratio, ratioSum / n).clamp(
      base.ratio * (1 - maxRatioChange),
      base.ratio * (1 + maxRatioChange),
    );
    final grind = towards(
      base.grindOffsetMicrons,
      grindSum / n,
    ).clamp(-maxGrindOffsetMicrons, maxGrindOffsetMicrons);

    return RecipeTuning._(
      base: base,
      brews: n,
      ratio: ratio,
      grindOffsetMicrons: grind,
      averageRating: ratingSum / n,
    );
  }

  /// Brews needed before a tuned version is offered.
  static const minBrews = 3;

  /// How strongly the original recipe holds while feedback is scarce,
  /// counted in brews.
  static const priorBrews = 2;

  /// Ratio change per point of "too strong" (more water) or "too weak".
  static const ratioStepPerPoint = 0.04;

  /// Grind change per point of "too bitter" (coarser) or "too sour".
  static const micronsPerTastePoint = 40.0;

  static const maxRatioChange = 0.2;
  static const maxGrindOffsetMicrons = 200.0;

  final Recipe base;

  /// Feedback entries the tuning is built from.
  final int brews;
  final double ratio;
  final double grindOffsetMicrons;
  final double? averageRating;

  bool get isAvailable => brews >= minBrews;

  /// The tuned recipe: same water and steps, with the dose and grind
  /// adjusted. Dose is rounded to half a gram.
  Recipe get recipe {
    final coffee = ((base.waterGrams + base.iceGrams) / ratio * 2).round() / 2;
    return base.copyWith(
      coffeeGrams: coffee,
      grindOffsetMicrons: (grindOffsetMicrons / 10).round() * 10.0,
    );
  }
}
