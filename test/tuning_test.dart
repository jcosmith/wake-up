import 'package:coffee_timer/data/grinders.dart';
import 'package:coffee_timer/data/recipes.dart';
import 'package:coffee_timer/feedback/feedback_store.dart';
import 'package:coffee_timer/models/feedback.dart';
import 'package:coffee_timer/models/recipe.dart';
import 'package:coffee_timer/models/tuning.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final v60 = recipeById('v60-ultimate')!;

  RecipeFeedback rate(
    Recipe brewed, {
    TasteBalance taste = TasteBalance.balanced,
    Strength strength = Strength.justRight,
    int rating = 4,
  }) => RecipeFeedback.forBrew(
    brewed,
    rating: rating,
    taste: taste,
    strength: strength,
    at: DateTime.utc(2026, 10, 10),
  );

  test('needs a few ratings before offering a tuned version', () {
    final tuning = RecipeTuning.from(v60, [rate(v60), rate(v60)]);
    expect(tuning.brews, 2);
    expect(tuning.isAvailable, isFalse);
    expect(RecipeTuning.from(v60, []).averageRating, isNull);
  });

  test('balanced feedback keeps the original', () {
    final tuning = RecipeTuning.from(v60, List.filled(5, rate(v60)));
    expect(tuning.isAvailable, isTrue);
    expect(tuning.recipe.coffeeGrams, v60.coffeeGrams);
    expect(tuning.recipe.grindOffsetMicrons, 0);
  });

  test('sour and weak brews tune finer with more coffee', () {
    final tuning = RecipeTuning.from(
      v60,
      List.filled(
        4,
        rate(v60, taste: TasteBalance.sour, strength: Strength.slightlyWeak),
      ),
    );
    expect(tuning.recipe.grindOffsetMicrons, lessThan(0));
    expect(tuning.recipe.coffeeGrams, greaterThan(v60.coffeeGrams));
    expect(tuning.recipe.waterGrams, v60.waterGrams);
    expect(tuning.recipe.steps, v60.steps);
  });

  test('bitter and strong brews tune coarser with less coffee', () {
    final tuning = RecipeTuning.from(
      v60,
      List.filled(
        4,
        rate(v60, taste: TasteBalance.bitter, strength: Strength.strong),
      ),
    );
    expect(tuning.recipe.grindOffsetMicrons, greaterThan(0));
    expect(tuning.recipe.coffeeGrams, lessThan(v60.coffeeGrams));
  });

  test('a single outlier moves the tuning less than a consensus', () {
    final mixed = RecipeTuning.from(v60, [
      rate(v60, taste: TasteBalance.sour),
      rate(v60),
      rate(v60),
    ]);
    final consensus = RecipeTuning.from(
      v60,
      List.filled(3, rate(v60, taste: TasteBalance.sour)),
    );
    expect(mixed.grindOffsetMicrons, lessThan(0));
    expect(mixed.grindOffsetMicrons, greaterThan(consensus.grindOffsetMicrons));
  });

  test('balanced feedback on the tuned brew keeps the tuning', () {
    final first = RecipeTuning.from(
      v60,
      List.filled(4, rate(v60, taste: TasteBalance.sour)),
    );
    final tuned = first.recipe;
    final again = RecipeTuning.from(v60, [
      ...List.filled(4, rate(v60, taste: TasteBalance.sour)),
      ...List.filled(20, rate(tuned)),
    ]);
    // Many "balanced" ratings of the tuned brew settle on the tuned grind.
    expect(again.grindOffsetMicrons, closeTo(tuned.grindOffsetMicrons, 15));
  });

  test('tuning stays within limits', () {
    final tuning = RecipeTuning.from(
      v60,
      List.filled(
        200,
        rate(v60, taste: TasteBalance.sour, strength: Strength.weak),
      ),
    );
    expect(
      tuning.grindOffsetMicrons,
      greaterThanOrEqualTo(-RecipeTuning.maxGrindOffsetMicrons),
    );
    expect(
      tuning.ratio,
      greaterThanOrEqualTo(v60.ratio * (1 - RecipeTuning.maxRatioChange)),
    );
  });

  test('ignores feedback for other recipes', () {
    final other = recipes.firstWhere((r) => r.id != v60.id);
    final tuning = RecipeTuning.from(v60, List.filled(5, rate(other)));
    expect(tuning.brews, 0);
  });

  test('grinder offsets shift the click range', () {
    final c40 = grinderById('comandante-c40');
    expect(c40.describe(v60.grind), '20–26 clicks');
    expect(c40.describe(v60.grind, offsetClicks: -2), '18–24 clicks');
  });

  test('feedback round-trips through local storage', () async {
    SharedPreferences.setMockInitialValues({});
    final store = LocalFeedbackStore(await SharedPreferences.getInstance());
    final feedback = rate(v60, taste: TasteBalance.slightlyBitter, rating: 5);
    await store.add(feedback);
    await store.add(rate(recipes.last));

    final loaded = await store.forRecipe(v60.id);
    expect(loaded, hasLength(1));
    expect(loaded.single.toJson(), feedback.toJson());
  });
}
