import '../models/grind.dart';
import '../models/grinder.dart';

/// Popular hand grinders and approximate click ranges for each grind size.
///
/// Clicks are counted from zero: close the burrs until they just touch, then
/// open them. Ranges are starting points pulled together from manufacturer
/// charts and common community settings. Burrs, units and beans all vary, so
/// adjust by taste: sour or thin, go finer; bitter or slow, go coarser.
const grinders = <HandGrinder>[
  HandGrinder(
    id: 'comandante-c40',
    brand: 'Comandante',
    model: 'C40 MK4',
    micronsPerClick: 30,
    notes:
        'With the stock axle. The Red Clix accessory halves the step size, '
        'so double these numbers.',
    settings: {
      GrindSize.extraFine: ClickRange(4, 7),
      GrindSize.fine: ClickRange(8, 14),
      GrindSize.mediumFine: ClickRange(14, 18),
      GrindSize.medium: ClickRange(20, 26),
      GrindSize.mediumCoarse: ClickRange(25, 30),
      GrindSize.coarse: ClickRange(30, 35),
      GrindSize.extraCoarse: ClickRange(34, 40),
    },
  ),
  HandGrinder(
    id: '1zpresso-q-air',
    brand: '1Zpresso',
    model: 'Q Air',
    micronsPerClick: 25,
    notes: 'Also fits the Q2. Better suited to filter than espresso.',
    settings: {
      GrindSize.fine: ClickRange(10, 18),
      GrindSize.mediumFine: ClickRange(18, 26),
      GrindSize.medium: ClickRange(24, 32),
      GrindSize.mediumCoarse: ClickRange(30, 37),
      GrindSize.coarse: ClickRange(36, 45),
      GrindSize.extraCoarse: ClickRange(44, 52),
    },
  ),
  HandGrinder(
    id: '1zpresso-k-ultra',
    brand: '1Zpresso',
    model: 'K-Ultra',
    micronsPerClick: 20,
    clicksPerRotation: 100,
    notes: 'Dial notation is rotation.number.click; 100 clicks per rotation.',
    settings: {
      GrindSize.extraFine: ClickRange(15, 25),
      GrindSize.fine: ClickRange(25, 45),
      GrindSize.mediumFine: ClickRange(45, 60),
      GrindSize.medium: ClickRange(60, 80),
      GrindSize.mediumCoarse: ClickRange(75, 90),
      GrindSize.coarse: ClickRange(90, 105),
      GrindSize.extraCoarse: ClickRange(100, 120),
    },
  ),
  HandGrinder(
    id: '1zpresso-jx-pro',
    brand: '1Zpresso',
    model: 'JX-Pro',
    micronsPerClick: 12.5,
    notes: '40 clicks per rotation.',
    settings: {
      GrindSize.extraFine: ClickRange(20, 40),
      GrindSize.fine: ClickRange(40, 70),
      GrindSize.mediumFine: ClickRange(70, 90),
      GrindSize.medium: ClickRange(90, 120),
      GrindSize.mediumCoarse: ClickRange(115, 135),
      GrindSize.coarse: ClickRange(130, 150),
      GrindSize.extraCoarse: ClickRange(145, 170),
    },
  ),
  HandGrinder(
    id: '1zpresso-j-max',
    brand: '1Zpresso',
    model: 'J-Max',
    micronsPerClick: 8.8,
    notes: 'Espresso-focused; very fine steps.',
    settings: {
      GrindSize.extraFine: ClickRange(15, 30),
      GrindSize.fine: ClickRange(30, 60),
      GrindSize.mediumFine: ClickRange(60, 90),
      GrindSize.medium: ClickRange(90, 120),
      GrindSize.mediumCoarse: ClickRange(115, 140),
      GrindSize.coarse: ClickRange(135, 165),
      GrindSize.extraCoarse: ClickRange(160, 190),
    },
  ),
  HandGrinder(
    id: 'kingrinder-k6',
    brand: 'Kingrinder',
    model: 'K6',
    micronsPerClick: 16,
    settings: {
      GrindSize.extraFine: ClickRange(20, 35),
      GrindSize.fine: ClickRange(35, 60),
      GrindSize.mediumFine: ClickRange(60, 80),
      GrindSize.medium: ClickRange(80, 110),
      GrindSize.mediumCoarse: ClickRange(105, 125),
      GrindSize.coarse: ClickRange(120, 145),
      GrindSize.extraCoarse: ClickRange(140, 165),
    },
  ),
  HandGrinder(
    id: 'kingrinder-k4',
    brand: 'Kingrinder',
    model: 'K4',
    micronsPerClick: 16,
    notes: 'Same adjustment as the K6 with smaller burrs; a little slower.',
    settings: {
      GrindSize.extraFine: ClickRange(20, 35),
      GrindSize.fine: ClickRange(35, 60),
      GrindSize.mediumFine: ClickRange(60, 80),
      GrindSize.medium: ClickRange(80, 110),
      GrindSize.mediumCoarse: ClickRange(105, 125),
      GrindSize.coarse: ClickRange(120, 145),
      GrindSize.extraCoarse: ClickRange(140, 165),
    },
  ),
  HandGrinder(
    id: 'timemore-c3',
    brand: 'Timemore',
    model: 'Chestnut C3',
    micronsPerClick: 30,
    notes: 'C2 settings are close; the C2 struggles at espresso fineness.',
    settings: {
      GrindSize.fine: ClickRange(6, 9),
      GrindSize.mediumFine: ClickRange(9, 12),
      GrindSize.medium: ClickRange(13, 17),
      GrindSize.mediumCoarse: ClickRange(17, 20),
      GrindSize.coarse: ClickRange(20, 24),
      GrindSize.extraCoarse: ClickRange(23, 27),
    },
  ),
  HandGrinder(
    id: 'timemore-s3',
    brand: 'Timemore',
    model: 'Chestnut S3',
    micronsPerClick: 15,
    notes: 'External adjustment; counted from zero on the dial.',
    settings: {
      GrindSize.extraFine: ClickRange(5, 15),
      GrindSize.fine: ClickRange(15, 30),
      GrindSize.mediumFine: ClickRange(30, 45),
      GrindSize.medium: ClickRange(45, 65),
      GrindSize.mediumCoarse: ClickRange(60, 75),
      GrindSize.coarse: ClickRange(75, 90),
      GrindSize.extraCoarse: ClickRange(85, 100),
    },
  ),
  HandGrinder(
    id: 'hario-skerton-pro',
    brand: 'Hario',
    model: 'Skerton Pro',
    micronsPerClick: 90,
    notes: 'Coarse steps; between-click tuning is not possible.',
    settings: {
      GrindSize.fine: ClickRange(2, 3),
      GrindSize.mediumFine: ClickRange(4, 5),
      GrindSize.medium: ClickRange(6, 8),
      GrindSize.mediumCoarse: ClickRange(8, 9),
      GrindSize.coarse: ClickRange(10, 12),
      GrindSize.extraCoarse: ClickRange(12, 14),
    },
  ),
  HandGrinder(
    id: 'porlex-mini',
    brand: 'Porlex',
    model: 'Mini II',
    micronsPerClick: 80,
    settings: {
      GrindSize.extraFine: ClickRange(1, 2),
      GrindSize.fine: ClickRange(2, 4),
      GrindSize.mediumFine: ClickRange(4, 6),
      GrindSize.medium: ClickRange(6, 8),
      GrindSize.mediumCoarse: ClickRange(8, 10),
      GrindSize.coarse: ClickRange(10, 12),
      GrindSize.extraCoarse: ClickRange(12, 14),
    },
  ),
];

HandGrinder grinderById(String id) =>
    grinders.firstWhere((g) => g.id == id, orElse: () => grinders.first);
