import 'recipe.dart';

/// Pure timing logic for a running brew: which step is active, what's next
/// and how much water should be on the scale. Kept free of Flutter so it is
/// easy to test.
class BrewSession {
  BrewSession(this.recipe, {double? coffeeGrams})
    : coffeeGrams = coffeeGrams ?? recipe.coffeeGrams;

  final Recipe recipe;
  final double coffeeGrams;

  double get scale => recipe.scaleFor(coffeeGrams);

  double get waterGrams => recipe.waterGrams * scale;

  double get iceGrams => recipe.iceGrams * scale;

  /// Index of the step running at [elapsed]. Always at least 0.
  int stepIndexAt(Duration elapsed) {
    var index = 0;
    for (var i = 0; i < recipe.steps.length; i++) {
      if (recipe.steps[i].at <= elapsed) index = i;
    }
    return index;
  }

  BrewStep? nextStepAfter(Duration elapsed) {
    final i = stepIndexAt(elapsed) + 1;
    return i < recipe.steps.length ? recipe.steps[i] : null;
  }

  /// Time until the next step begins, or until the expected end of the brew
  /// on the last step. Never negative.
  Duration remainingInStep(Duration elapsed) {
    final next = nextStepAfter(elapsed);
    final end = next?.at ?? recipe.totalTime;
    final left = end - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  /// Scaled scale target for a step, in grams.
  double? pourTargetFor(BrewStep step) =>
      step.pourTo == null ? null : step.pourTo! * scale;

  /// Water that should be on the scale at [elapsed]: the most recent pour
  /// target at or before the current step.
  double waterTargetAt(Duration elapsed) {
    final current = stepIndexAt(elapsed);
    for (var i = current; i >= 0; i--) {
      final target = pourTargetFor(recipe.steps[i]);
      if (target != null) return target;
    }
    return 0;
  }

  double progressAt(Duration elapsed) {
    final total = recipe.totalTime.inMilliseconds;
    if (total == 0) return 1;
    return (elapsed.inMilliseconds / total).clamp(0, 1).toDouble();
  }

  bool isFinishedAt(Duration elapsed) => elapsed >= recipe.totalTime;
}
