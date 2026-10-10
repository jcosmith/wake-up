/// Broad grind-size bands, from finest to coarsest.
///
/// Recipes name one of these, and every grinder maps each band to a range of
/// clicks. Micron ranges are rough guides for grinders that are not listed.
enum GrindSize {
  extraFine('Extra fine', 'Powdery, like flour', 100, 250),
  fine('Fine', 'Like table salt, but finer', 200, 400),
  mediumFine('Medium-fine', 'Like table salt', 350, 600),
  medium('Medium', 'Like coarse sand', 550, 800),
  mediumCoarse('Medium-coarse', 'Like rough sand', 700, 950),
  coarse('Coarse', 'Like sea salt', 900, 1150),
  extraCoarse('Extra coarse', 'Like cracked peppercorns', 1100, 1400);

  const GrindSize(
    this.label,
    this.description,
    this.minMicrons,
    this.maxMicrons,
  );

  final String label;
  final String description;
  final int minMicrons;
  final int maxMicrons;
}
