import 'package:flutter/material.dart';

import '../format.dart';
import '../models/brew_session.dart';
import '../models/recipe.dart';
import '../widgets/grind_card.dart';
import 'timer_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late double _coffee = widget.recipe.coffeeGrams;

  Recipe get recipe => widget.recipe;

  /// Step size for the dose buttons: finer for small doses.
  double get _doseStep => recipe.coffeeGrams < 20 ? 0.5 : 1;

  void _changeDose(double delta) {
    setState(() {
      _coffee = (_coffee + delta).clamp(_doseStep, recipe.coffeeGrams * 5);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = BrewSession(recipe, coffeeGrams: _coffee);
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.timer_outlined),
        label: const Text('Start brewing'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TimerScreen(session: session)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          if (recipe.summary != null)
            Text(recipe.summary!, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text(
            recipe.source,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          _DoseCard(
            coffee: _coffee,
            onMinus: () => _changeDose(-_doseStep),
            onPlus: () => _changeDose(_doseStep),
            onReset: _coffee == recipe.coffeeGrams
                ? null
                : () => setState(() => _coffee = recipe.coffeeGrams),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Fact(
                icon: Icons.water_drop_outlined,
                label: 'Water',
                value: formatGrams(session.waterGrams),
              ),
              if (session.iceGrams > 0)
                _Fact(
                  icon: Icons.ac_unit,
                  label: 'Ice',
                  value: formatGrams(session.iceGrams),
                ),
              _Fact(
                icon: Icons.balance,
                label: 'Ratio',
                value: formatRatio(recipe.ratio),
              ),
              _Fact(
                icon: Icons.thermostat,
                label: 'Water temp',
                value: recipe.waterTempC == null
                    ? (recipe.method == BrewMethod.coldBrew ||
                              recipe.method == BrewMethod.turkish
                          ? 'Cold'
                          : 'Machine')
                    : recipe.waterTempC! >= 100
                    ? 'Just off boil'
                    : '${recipe.waterTempC} °C',
              ),
              _Fact(
                icon: Icons.timer_outlined,
                label: 'Time',
                value: formatBrewTime(recipe.totalTime),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GrindCard(grind: recipe.grind),
          const SizedBox(height: 16),
          Text('Steps', style: theme.textTheme.titleLarge),
          for (final step in recipe.steps)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(
                width: 56,
                child: Text(
                  formatDuration(step.at),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              title: Text(step.title),
              subtitle: step.detail == null ? null : Text(step.detail!),
              trailing: session.pourTargetFor(step) == null
                  ? null
                  : Text(
                      'to ${formatGrams(session.pourTargetFor(step)!)}',
                      style: theme.textTheme.labelLarge,
                    ),
            ),
          if (recipe.tips.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Tips', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            for (final tip in recipe.tips)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _DoseCard extends StatelessWidget {
  const _DoseCard({
    required this.coffee,
    required this.onMinus,
    required this.onPlus,
    this.onReset,
  });

  final double coffee;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Coffee', style: theme.textTheme.labelLarge),
                  Text(
                    formatGrams(coffee),
                    style: theme.textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            if (onReset != null)
              IconButton(
                tooltip: 'Reset dose',
                icon: const Icon(Icons.restart_alt),
                onPressed: onReset,
              ),
            IconButton.filledTonal(
              tooltip: 'Less coffee',
              icon: const Icon(Icons.remove),
              onPressed: onMinus,
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: 'More coffee',
              icon: const Icon(Icons.add),
              onPressed: onPlus,
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelSmall),
              Text(value, style: theme.textTheme.titleSmall),
            ],
          ),
        ],
      ),
    );
  }
}
