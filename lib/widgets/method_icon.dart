import 'package:flutter/material.dart';

import '../models/recipe.dart';

IconData methodIcon(BrewMethod method) => switch (method) {
  BrewMethod.v60 ||
  BrewMethod.chemex ||
  BrewMethod.kalita => Icons.filter_alt_outlined,
  BrewMethod.clever => Icons.filter_alt,
  BrewMethod.drip => Icons.coffee_maker_outlined,
  BrewMethod.aeropress => Icons.compress,
  BrewMethod.frenchPress => Icons.coffee_maker,
  BrewMethod.mokaPot => Icons.local_fire_department_outlined,
  BrewMethod.espresso => Icons.coffee,
  BrewMethod.coldBrew => Icons.nightlight_outlined,
  BrewMethod.icedPourOver => Icons.ac_unit,
  BrewMethod.turkish => Icons.whatshot_outlined,
};
