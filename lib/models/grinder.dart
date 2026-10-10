import 'grind.dart';

/// A click range on a grinder, counted from zero (burrs just touching).
class ClickRange {
  const ClickRange(this.min, this.max);

  final int min;
  final int max;

  @override
  String toString() => min == max ? '$min' : '$min–$max';
}

class HandGrinder {
  const HandGrinder({
    required this.id,
    required this.brand,
    required this.model,
    required this.micronsPerClick,
    required this.settings,
    this.clicksPerRotation,
    this.notes,
  });

  final String id;
  final String brand;
  final String model;

  /// Approximate burr movement per click, in microns.
  final double micronsPerClick;

  /// Clicks in one full turn of the adjustment dial, when the grinder uses
  /// rotation-based numbering (e.g. 1Zpresso's "1.2.0" notation).
  final int? clicksPerRotation;

  /// Suggested range for each grind size. Missing entries mean the grinder
  /// is not well suited to that grind.
  final Map<GrindSize, ClickRange> settings;

  final String? notes;

  String get name => '$brand $model';

  ClickRange? settingFor(GrindSize size) => settings[size];

  /// Human-friendly setting, e.g. "22–28 clicks" or "45–60 clicks (1.5.0–2.0.0)".
  String describe(GrindSize size) {
    final range = settings[size];
    if (range == null) return 'Not recommended';
    final clicks = '$range clicks';
    final perRotation = clicksPerRotation;
    if (perRotation == null) return clicks;
    String rot(int c) =>
        '${c ~/ perRotation}.${(c % perRotation) ~/ 10}.${c % 10}';
    final dial = range.min == range.max
        ? rot(range.min)
        : '${rot(range.min)}–${rot(range.max)}';
    return '$clicks ($dial)';
  }
}
