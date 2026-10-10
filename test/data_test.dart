import 'package:coffee_timer/data/grinders.dart';
import 'package:coffee_timer/data/recipes.dart';
import 'package:coffee_timer/models/grind.dart';
import 'package:coffee_timer/models/recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('recipes', () {
    test('have unique ids', () {
      final ids = recipes.map((r) => r.id).toSet();
      expect(ids.length, recipes.length);
    });

    test('cover every brew method', () {
      for (final method in BrewMethod.values) {
        expect(recipesFor(method), isNotEmpty, reason: method.label);
      }
    });

    for (final r in recipes) {
      test('${r.name} steps are well formed', () {
        expect(r.steps, isNotEmpty);
        expect(r.steps.first.at, Duration.zero);
        for (var i = 1; i < r.steps.length; i++) {
          expect(r.steps[i].at, greaterThan(r.steps[i - 1].at));
        }
        expect(r.steps.last.at, lessThanOrEqualTo(r.totalTime));

        final pours = r.steps.map((s) => s.pourTo).whereType<double>();
        expect(pours, isNotEmpty, reason: 'no pour target in ${r.name}');
        var previous = 0.0;
        for (final p in pours) {
          expect(p, greaterThanOrEqualTo(previous));
          previous = p;
        }
        expect(previous, r.waterGrams, reason: 'last pour should be the total');
      });
    }
  });

  group('grinders', () {
    test('have unique ids', () {
      expect(grinders.map((g) => g.id).toSet().length, grinders.length);
    });

    for (final g in grinders) {
      test('${g.name} settings get coarser with grind size', () {
        var lastMin = -1;
        for (final size in GrindSize.values) {
          final range = g.settingFor(size);
          if (range == null) continue;
          expect(range.min, lessThanOrEqualTo(range.max));
          expect(range.min, greaterThan(lastMin));
          lastMin = range.min;
        }
      });

      test('${g.name} covers every grind a filter recipe needs', () {
        for (final size in [
          GrindSize.mediumFine,
          GrindSize.medium,
          GrindSize.mediumCoarse,
          GrindSize.coarse,
        ]) {
          expect(g.settingFor(size), isNotNull, reason: size.label);
        }
      });
    }

    test('describe uses rotation notation when the dial has one', () {
      final kUltra = grinderById('1zpresso-k-ultra');
      expect(kUltra.describe(GrindSize.medium), '60–80 clicks (0.6.0–0.8.0)');
      final comandante = grinderById('comandante-c40');
      expect(comandante.describe(GrindSize.medium), '20–26 clicks');
      final qAir = grinderById('1zpresso-q-air');
      expect(qAir.describe(GrindSize.extraFine), 'Not recommended');
    });
  });
}
