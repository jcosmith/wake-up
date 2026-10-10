import 'recipe.dart';

/// How a brew tasted, on a five-point scale centred on "just right".
enum TasteBalance {
  sour('Sour', -2),
  slightlySour('A bit sour', -1),
  balanced('Balanced', 0),
  slightlyBitter('A bit bitter', 1),
  bitter('Bitter', 2);

  const TasteBalance(this.label, this.value);

  final String label;
  final int value;
}

enum Strength {
  weak('Weak', -2),
  slightlyWeak('A bit weak', -1),
  justRight('Just right', 0),
  slightlyStrong('A bit strong', 1),
  strong('Strong', 2);

  const Strength(this.label, this.value);

  final String label;
  final int value;
}

/// One person's verdict on one brew, together with what they actually
/// brewed (the original or the tuned version), so later tuning can work out
/// where the ideal lies.
class RecipeFeedback {
  const RecipeFeedback({
    required this.recipeId,
    required this.createdAt,
    required this.rating,
    required this.taste,
    required this.strength,
    required this.brewedRatio,
    this.brewedGrindOffsetMicrons = 0,
  });

  /// Builds feedback for a brew of [brewed], which may be a tuned recipe.
  factory RecipeFeedback.forBrew(
    Recipe brewed, {
    required int rating,
    required TasteBalance taste,
    required Strength strength,
    DateTime? at,
  }) => RecipeFeedback(
    recipeId: brewed.id,
    createdAt: at ?? DateTime.now(),
    rating: rating,
    taste: taste,
    strength: strength,
    brewedRatio: brewed.ratio,
    brewedGrindOffsetMicrons: brewed.grindOffsetMicrons,
  );

  factory RecipeFeedback.fromJson(Map<String, dynamic> json) => RecipeFeedback(
    recipeId: json['recipeId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    rating: json['rating'] as int,
    taste: TasteBalance.values.byName(json['taste'] as String),
    strength: Strength.values.byName(json['strength'] as String),
    brewedRatio: (json['brewedRatio'] as num).toDouble(),
    brewedGrindOffsetMicrons:
        (json['brewedGrindOffsetMicrons'] as num?)?.toDouble() ?? 0,
  );

  final String recipeId;
  final DateTime createdAt;

  /// Overall enjoyment, 1–5.
  final int rating;
  final TasteBalance taste;
  final Strength strength;

  /// Water-to-coffee ratio that was brewed (ice counted as water).
  final double brewedRatio;
  final double brewedGrindOffsetMicrons;

  Map<String, dynamic> toJson() => {
    'recipeId': recipeId,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'rating': rating,
    'taste': taste.name,
    'strength': strength.name,
    'brewedRatio': brewedRatio,
    'brewedGrindOffsetMicrons': brewedGrindOffsetMicrons,
  };
}
