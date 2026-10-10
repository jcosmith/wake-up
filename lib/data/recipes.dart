import '../models/grind.dart';
import '../models/recipe.dart';

/// Brew recipes. Where James Hoffmann has published a method, the recipe
/// follows it and [Recipe.source] names it; the rest are Hoffmann-style
/// adaptations using the same principles (60 g/L-ish ratios, hot water,
/// gentle agitation) and say so.
const recipes = <Recipe>[
  Recipe(
    id: 'v60-ultimate',
    name: 'The Ultimate V60',
    method: BrewMethod.v60,
    source: 'James Hoffmann — "The Ultimate V60 Technique"',
    coffeeGrams: 30,
    waterGrams: 500,
    waterTempC: 100,
    grind: GrindSize.medium,
    totalTime: Duration(seconds: 210),
    summary:
        'A two-cup V60 with a big bloom, two main pours and a gentle '
        'swirl for an even, flat bed.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Bloom',
        detail:
            'Pour about twice the coffee weight, then swirl the brewer '
            'until all the grounds are evenly wet.',
        pourTo: 60,
      ),
      BrewStep(
        at: Duration(seconds: 45),
        title: 'First main pour',
        detail: 'Pour steadily in spirals to reach 60% of the water by 1:15.',
        pourTo: 300,
      ),
      BrewStep(
        at: Duration(seconds: 75),
        title: 'Second main pour',
        detail: 'Pour a little slower, up to the full weight by 1:45.',
        pourTo: 500,
      ),
      BrewStep(
        at: Duration(seconds: 105),
        title: 'Stir and swirl',
        detail:
            'Stir once clockwise and once anticlockwise with a spoon, '
            'then give the V60 a gentle swirl.',
      ),
      BrewStep(
        at: Duration(seconds: 120),
        title: 'Drawdown',
        detail: 'Let it drain. Aim to finish around 3:30.',
      ),
    ],
    tips: [
      'Rinse the paper filter with hot water and discard the rinse water.',
      'Make a small well in the middle of the bed before blooming.',
      'If drawdown runs long, grind coarser; if short and sour, go finer.',
    ],
  ),
  Recipe(
    id: 'v60-one-cup',
    name: 'A Better 1-Cup V60',
    method: BrewMethod.v60,
    source: 'James Hoffmann — "A Better 1 Cup V60 Technique"',
    coffeeGrams: 15,
    waterGrams: 250,
    waterTempC: 100,
    grind: GrindSize.medium,
    totalTime: Duration(seconds: 180),
    summary: 'Five even pulses keep the slurry level steady for a single cup.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Bloom',
        detail: 'Pour, then swirl gently to wet all the grounds.',
        pourTo: 50,
      ),
      BrewStep(at: Duration(seconds: 45), title: 'Pour 2', pourTo: 100),
      BrewStep(at: Duration(seconds: 70), title: 'Pour 3', pourTo: 150),
      BrewStep(at: Duration(seconds: 90), title: 'Pour 4', pourTo: 200),
      BrewStep(at: Duration(seconds: 110), title: 'Pour 5', pourTo: 250),
      BrewStep(
        at: Duration(seconds: 130),
        title: 'Swirl and drawdown',
        detail: 'Give it a gentle swirl and let it drain. Aim for about 3:00.',
      ),
    ],
    tips: ['Each pour is 50 g, done in about 10 seconds.'],
  ),
  Recipe(
    id: 'chemex',
    name: 'Chemex',
    method: BrewMethod.chemex,
    source: 'Adapted from James Hoffmann\'s V60 technique',
    coffeeGrams: 30,
    waterGrams: 500,
    waterTempC: 96,
    grind: GrindSize.mediumCoarse,
    totalTime: Duration(seconds: 270),
    summary:
        'The thick Chemex paper needs a slightly coarser grind and a '
        'longer drawdown than a V60.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Bloom',
        detail: 'Pour and gently stir or swirl so every ground is wet.',
        pourTo: 75,
      ),
      BrewStep(
        at: Duration(seconds: 45),
        title: 'First main pour',
        detail: 'Spiral pour to 60% of the water.',
        pourTo: 300,
      ),
      BrewStep(
        at: Duration(seconds: 90),
        title: 'Second main pour',
        pourTo: 500,
      ),
      BrewStep(
        at: Duration(seconds: 135),
        title: 'Swirl and drawdown',
        detail: 'Swirl gently and let it drain. Aim for 4:00–4:30.',
      ),
    ],
    tips: [
      'Put the triple-fold side of the filter against the spout.',
      'Rinse the paper well; it can taste papery.',
    ],
  ),
  Recipe(
    id: 'kalita',
    name: 'Kalita Wave',
    method: BrewMethod.kalita,
    source: 'Hoffmann-style pulse pour',
    coffeeGrams: 20,
    waterGrams: 330,
    waterTempC: 96,
    grind: GrindSize.medium,
    totalTime: Duration(seconds: 210),
    summary: 'The flat bed and small holes reward steady, even pulses.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Bloom',
        detail: 'Pour and swirl to wet everything.',
        pourTo: 50,
      ),
      BrewStep(at: Duration(seconds: 40), title: 'Pour 2', pourTo: 150),
      BrewStep(at: Duration(seconds: 70), title: 'Pour 3', pourTo: 250),
      BrewStep(at: Duration(seconds: 100), title: 'Pour 4', pourTo: 330),
      BrewStep(
        at: Duration(seconds: 125),
        title: 'Swirl and drawdown',
        detail: 'Gentle swirl, then let it drain. Aim for about 3:30.',
      ),
    ],
  ),
  Recipe(
    id: 'clever',
    name: 'Clever Dripper',
    method: BrewMethod.clever,
    source: 'Inspired by James Hoffmann\'s water-first Clever method',
    coffeeGrams: 18,
    waterGrams: 300,
    waterTempC: 100,
    grind: GrindSize.medium,
    totalTime: Duration(seconds: 240),
    summary: 'Water in first, then coffee: no dry clumps and a faster drain.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Add water',
        detail: 'Pour all the water into the rinsed Clever.',
        pourTo: 300,
      ),
      BrewStep(
        at: Duration(seconds: 10),
        title: 'Add coffee',
        detail: 'Tip in the coffee and gently push it under the surface.',
      ),
      BrewStep(
        at: Duration(seconds: 120),
        title: 'Stir',
        detail: 'Give it a gentle stir to break the crust.',
      ),
      BrewStep(
        at: Duration(seconds: 130),
        title: 'Drain',
        detail:
            'Set the Clever on your cup or carafe. It should finish '
            'draining around 3:30–4:00.',
      ),
    ],
  ),
  Recipe(
    id: 'drip-machine',
    name: 'Better Batch Brew',
    method: BrewMethod.drip,
    source: 'Based on James Hoffmann\'s filter machine advice',
    coffeeGrams: 60,
    waterGrams: 1000,
    waterTempC: null,
    grind: GrindSize.medium,
    totalTime: Duration(seconds: 360),
    summary: 'Use 60 g/L and help the machine wet the bed evenly.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Start the machine',
        detail:
            'Fill the reservoir, rinse the paper, add coffee, level the bed.',
        pourTo: 1000,
      ),
      BrewStep(
        at: Duration(seconds: 45),
        title: 'Stir the bloom',
        detail:
            'Once the bed is wet, give it a quick stir if your basket '
            'allows, so no dry pockets remain.',
      ),
      BrewStep(
        at: Duration(seconds: 300),
        title: 'Finish',
        detail:
            'When dripping stops, swirl the carafe and remove it from the '
            'hot plate.',
      ),
    ],
    tips: ['Don\'t leave coffee on the hot plate; it cooks quickly.'],
  ),
  Recipe(
    id: 'aeropress-ultimate',
    name: 'The Ultimate AeroPress',
    method: BrewMethod.aeropress,
    source: 'James Hoffmann — "The Ultimate AeroPress Technique"',
    coffeeGrams: 11,
    waterGrams: 200,
    waterTempC: 100,
    grind: GrindSize.mediumFine,
    totalTime: Duration(seconds: 180),
    summary:
        'Standard orientation, fine-ish grind, long steep and a gentle '
        'press.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Add water',
        detail: 'Pour all the water straight off the boil.',
        pourTo: 200,
      ),
      BrewStep(
        at: Duration(seconds: 10),
        title: 'Insert plunger',
        detail:
            'Put the plunger in about 1 cm and pull up slightly to form '
            'a vacuum so it does not drip.',
      ),
      BrewStep(
        at: Duration(seconds: 120),
        title: 'Swirl',
        detail: 'Holding the whole thing, give it a gentle swirl.',
      ),
      BrewStep(
        at: Duration(seconds: 150),
        title: 'Press',
        detail: 'Press gently all the way through, about 30 seconds.',
      ),
    ],
    tips: [
      'Rinse the paper filter; no need to pre-wet it otherwise.',
      'Taste and dilute with hot water if it is too strong for you.',
    ],
  ),
  Recipe(
    id: 'french-press',
    name: 'French Press',
    method: BrewMethod.frenchPress,
    source: 'James Hoffmann — "The Ultimate French Press Technique"',
    coffeeGrams: 30,
    waterGrams: 500,
    waterTempC: 100,
    grind: GrindSize.medium,
    totalTime: Duration(seconds: 540),
    summary: 'Long steep, skim the foam, and barely plunge for a clean cup.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Add water',
        detail: 'Pour all the water quickly to wet all the grounds.',
        pourTo: 500,
      ),
      BrewStep(
        at: Duration(seconds: 240),
        title: 'Break the crust',
        detail:
            'Stir the crust with a spoon, then scoop off the foam and '
            'floating bits.',
      ),
      BrewStep(
        at: Duration(seconds: 270),
        title: 'Wait',
        detail: 'Leave it alone so the fines settle. Longer is fine.',
      ),
      BrewStep(
        at: Duration(seconds: 510),
        title: 'Plunge and pour',
        detail:
            'Push the plunger down just to the surface, not into the bed. '
            'Pour slowly; leave the last bit behind.',
      ),
    ],
    tips: ['Hoffmann uses the same grind as for filter, not super coarse.'],
  ),
  Recipe(
    id: 'moka-pot',
    name: 'The Ultimate Moka Pot',
    method: BrewMethod.mokaPot,
    source: 'James Hoffmann — "The Ultimate Moka Pot Technique"',
    coffeeGrams: 17,
    waterGrams: 170,
    waterTempC: 100,
    grind: GrindSize.mediumFine,
    totalTime: Duration(seconds: 210),
    summary:
        'Pre-heated water, lid open and pull it off the heat before it '
        'sputters.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Assemble and heat',
        detail:
            'Fill the base with just-boiled water up to the valve. Fill '
            'the basket level with no tamping. Screw on with a towel and set '
            'on medium heat, lid open.',
        pourTo: 170,
      ),
      BrewStep(
        at: Duration(seconds: 90),
        title: 'Watch the flow',
        detail:
            'Coffee should flow slowly and steadily. Turn the heat down '
            'if it gushes.',
      ),
      BrewStep(
        at: Duration(seconds: 150),
        title: 'Pull it off',
        detail:
            'When the stream turns pale and starts sputtering, remove '
            'from the heat and cool the base under a cold tap.',
      ),
    ],
    tips: [
      'Quantities are for a 3-cup Bialetti; fill to the valve on yours.',
      'Grind a little coarser than espresso.',
    ],
  ),
  Recipe(
    id: 'espresso',
    name: 'Espresso',
    method: BrewMethod.espresso,
    source: 'Based on James Hoffmann\'s espresso guidance (1:2 ratio)',
    coffeeGrams: 18,
    waterGrams: 36,
    waterTempC: 93,
    grind: GrindSize.fine,
    totalTime: Duration(seconds: 30),
    summary: 'A 1:2 ratio in roughly 25–30 seconds as a starting point.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Start the shot',
        detail: 'Start the pump and the timer together.',
      ),
      BrewStep(
        at: Duration(seconds: 6),
        title: 'First drops',
        detail: 'Coffee should appear after 5–10 seconds.',
      ),
      BrewStep(
        at: Duration(seconds: 25),
        title: 'Stop at weight',
        detail: 'Stop when the cup reaches the yield, usually around 25–30 s.',
        pourTo: 36,
      ),
    ],
    tips: [
      'Weight out is the target; the timer is a guide.',
      'Fast and sour: go finer. Slow and bitter: go coarser.',
    ],
  ),
  Recipe(
    id: 'cold-brew',
    name: 'Cold Brew Concentrate',
    method: BrewMethod.coldBrew,
    source: 'Hoffmann-style cold brew (steep, filter, dilute)',
    coffeeGrams: 100,
    waterGrams: 1000,
    waterTempC: null,
    grind: GrindSize.coarse,
    totalTime: Duration(hours: 12),
    summary:
        'Steep coarse coffee in cold water overnight, filter, then '
        'dilute to taste.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Combine',
        detail:
            'Add coffee and cold, filtered water to a jar. Stir to wet '
            'everything.',
        pourTo: 1000,
      ),
      BrewStep(
        at: Duration(minutes: 1),
        title: 'Steep in the fridge',
        detail: 'Cover and refrigerate for 12–15 hours.',
      ),
      BrewStep(
        at: Duration(hours: 12),
        title: 'Filter',
        detail:
            'Strain through a sieve, then a paper filter. Dilute about '
            '1:1 with water or milk.',
      ),
    ],
    tips: ['Keeps about a week in the fridge.'],
  ),
  Recipe(
    id: 'iced-v60',
    name: 'Japanese Iced V60',
    method: BrewMethod.icedPourOver,
    source: 'James Hoffmann — "Iced Coffee" (flash-brew method)',
    coffeeGrams: 30,
    waterGrams: 300,
    iceGrams: 200,
    waterTempC: 100,
    grind: GrindSize.mediumFine,
    totalTime: Duration(seconds: 180),
    summary: 'Brew hot straight onto ice for bright, aromatic iced coffee.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Bloom',
        detail: 'With the ice in the carafe, pour and swirl.',
        pourTo: 60,
      ),
      BrewStep(
        at: Duration(seconds: 45),
        title: 'First main pour',
        pourTo: 180,
      ),
      BrewStep(
        at: Duration(seconds: 75),
        title: 'Second main pour',
        pourTo: 300,
      ),
      BrewStep(
        at: Duration(seconds: 100),
        title: 'Swirl and drawdown',
        detail:
            'Swirl gently and let it drain, then swirl the carafe until '
            'the ice has mostly melted.',
      ),
    ],
    tips: [
      'Grind finer than usual: less hot water means you need more extraction.',
      'Scale shows hot water only; the ice sits in the carafe.',
    ],
  ),
  Recipe(
    id: 'turkish',
    name: 'Turkish Coffee',
    method: BrewMethod.turkish,
    source: 'Adapted from James Hoffmann\'s Turkish coffee video',
    coffeeGrams: 7,
    waterGrams: 70,
    waterTempC: null,
    grind: GrindSize.extraFine,
    totalTime: Duration(seconds: 210),
    summary: 'Slowly heated in a cezve until the foam rises; never boiled.',
    steps: [
      BrewStep(
        at: Duration.zero,
        title: 'Combine',
        detail:
            'Add cold water, coffee and sugar (if using) to the cezve '
            'and stir until no clumps remain.',
        pourTo: 70,
      ),
      BrewStep(
        at: Duration(seconds: 15),
        title: 'Heat gently',
        detail: 'Low heat. Do not stir again.',
      ),
      BrewStep(
        at: Duration(seconds: 150),
        title: 'Watch the foam',
        detail:
            'As the foam rises toward the rim, pull it off the heat '
            'before it boils.',
      ),
      BrewStep(
        at: Duration(seconds: 180),
        title: 'Serve',
        detail:
            'Pour slowly into a small cup, foam first. Let it settle '
            'for a minute before sipping.',
      ),
    ],
  ),
];

List<Recipe> recipesFor(BrewMethod method) =>
    recipes.where((r) => r.method == method).toList();

Recipe? recipeById(String id) {
  for (final r in recipes) {
    if (r.id == id) return r;
  }
  return null;
}
