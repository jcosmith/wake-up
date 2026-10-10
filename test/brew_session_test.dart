import 'package:coffee_timer/data/recipes.dart';
import 'package:coffee_timer/format.dart';
import 'package:coffee_timer/models/brew_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final v60 = recipeById('v60-ultimate')!;

  test('tracks the current and next step', () {
    final s = BrewSession(v60);
    expect(s.stepIndexAt(Duration.zero), 0);
    expect(s.stepIndexAt(const Duration(seconds: 44)), 0);
    expect(s.stepIndexAt(const Duration(seconds: 45)), 1);
    expect(
      s.nextStepAfter(const Duration(seconds: 50))!.title,
      'Second main pour',
    );
    expect(
      s.remainingInStep(const Duration(seconds: 50)),
      const Duration(seconds: 25),
    );
  });

  test('last step counts down to the expected finish, then stops at zero', () {
    final s = BrewSession(v60);
    expect(s.nextStepAfter(const Duration(seconds: 200)), isNull);
    expect(
      s.remainingInStep(const Duration(seconds: 200)),
      const Duration(seconds: 10),
    );
    expect(s.remainingInStep(const Duration(seconds: 400)), Duration.zero);
    expect(s.isFinishedAt(const Duration(seconds: 210)), isTrue);
  });

  test('scales water and pour targets with the dose', () {
    final s = BrewSession(v60, coffeeGrams: 15);
    expect(s.waterGrams, 250);
    expect(s.pourTargetFor(v60.steps.first), 30);
    // After the last pour, the scale target holds at the total.
    expect(s.waterTargetAt(const Duration(seconds: 150)), 250);
  });

  test('formats times and weights', () {
    expect(formatDuration(const Duration(seconds: 65)), '1:05');
    expect(formatDuration(const Duration(hours: 12, seconds: 3)), '12:00:03');
    expect(formatBrewTime(const Duration(hours: 12)), '12 h');
    expect(formatGrams(16.5), '16.5 g');
    expect(formatGrams(250.0), '250 g');
    expect(formatRatio(500 / 30), '1:16.7');
  });
}
