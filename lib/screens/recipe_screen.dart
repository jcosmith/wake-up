import 'package:flutter/material.dart';

import '../format.dart';
import '../models/brew_session.dart';
import '../models/feedback.dart';
import '../models/recipe.dart';
import '../models/tuning.dart';
import '../state/app_state.dart';
import '../widgets/feedback_sheet.dart';
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
  List<RecipeFeedback> _feedback = const [];
  bool _useTuned = false;

  RecipeTuning get _tuning => RecipeTuning.from(widget.recipe, _feedback);

  /// The version being shown: the original or the community-tuned one.
  Recipe get recipe =>
      _useTuned && _tuning.isAvailable ? _tuning.recipe : widget.recipe;

  /// Step size for the dose buttons: finer for small doses.
  double get _doseStep => widget.recipe.coffeeGrams < 20 ? 0.5 : 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    final store = AppStateScope.of(context).feedback;
    final feedback = await store.forRecipe(widget.recipe.id);
    if (!mounted) return;
    setState(() => _feedback = feedback);
  }

  void _selectVariant(bool tuned) {
    setState(() {
      _useTuned = tuned;
      _coffee = recipe.coffeeGrams;
    });
  }

  Future<void> _rate() async {
    if (await showFeedbackSheet(context, recipe)) await _loadFeedback();
  }

  Future<void> _brew(BrewSession session) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => TimerScreen(session: session)));
    await _loadFeedback();
  }

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
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            tooltip: 'Rate a brew',
            icon: const Icon(Icons.rate_review_outlined),
            onPressed: _rate,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.timer_outlined),
        label: const Text('Start brewing'),
        onPressed: () => _brew(session),
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
          _VariantCard(
            tuning: _tuning,
            tuned: _useTuned && _tuning.isAvailable,
            onSelect: _selectVariant,
          ),
          const SizedBox(height: 8),
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
          GrindCard(
            grind: recipe.grind,
            offsetMicrons: recipe.grindOffsetMicrons,
          ),
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

/// Picks between the original recipe and the version tuned from feedback.
/// The original is always offered.
class _VariantCard extends StatelessWidget {
  const _VariantCard({
    required this.tuning,
    required this.tuned,
    required this.onSelect,
  });

  final RecipeTuning tuning;
  final bool tuned;
  final ValueChanged<bool> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!tuning.isAvailable) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.auto_graph),
          title: const Text('Tuned version'),
          subtitle: Text(
            'Rate your brews to build a tuned version of this recipe '
            '(${tuning.brews} of ${RecipeTuning.minBrews} ratings).',
          ),
        ),
      );
    }

    final grinder = AppStateScope.of(context).grinder;
    final base = tuning.base;
    final tunedRecipe = tuning.recipe;
    final doseChange = tunedRecipe.coffeeGrams - base.coffeeGrams;
    final clicks = grinder.clicksFor(tunedRecipe.grindOffsetMicrons);
    final changes = [
      if (doseChange != 0)
        '${formatGrams(doseChange.abs())} '
            '${doseChange > 0 ? 'more' : 'less'} coffee '
            '(${formatRatio(tunedRecipe.ratio)})',
      if (clicks != 0)
        'grind ${clicks.abs()} click${clicks.abs() == 1 ? '' : 's'} '
            '${clicks < 0 ? 'finer' : 'coarser'}',
    ];
    final rating = tuning.averageRating!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('Original')),
                  ButtonSegment(
                    value: true,
                    label: Text('Tuned'),
                    icon: Icon(Icons.auto_graph),
                  ),
                ],
                selected: {tuned},
                onSelectionChanged: (s) => onSelect(s.first),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tuned
                  ? (changes.isEmpty
                        ? 'Feedback so far says the original is spot on.'
                        : 'Tuned: ${changes.join(', ')}.')
                  : 'The recipe as published.',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              'Built from ${tuning.brews} rated brews · '
              'average ${rating.toStringAsFixed(1)} ★',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
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
