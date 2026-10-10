import 'package:flutter/material.dart';

import '../data/recipes.dart';
import '../format.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';
import '../widgets/method_icon.dart';
import 'grinders_screen.dart';
import 'recipe_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grinder = AppStateScope.of(context).grinder;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Timer'),
        actions: [
          IconButton(
            tooltip: 'Grinder settings',
            icon: const Icon(Icons.tune),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GrindersScreen())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: ActionChip(
              avatar: const Icon(Icons.settings_input_component, size: 18),
              label: Text('Grinder: ${grinder.name}'),
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const GrindersScreen())),
            ),
          ),
          for (final method in BrewMethod.values)
            if (recipesFor(method).isNotEmpty) ...[
              _MethodHeader(method: method),
              for (final recipe in recipesFor(method))
                _RecipeTile(recipe: recipe),
            ],
        ],
      ),
    );
  }
}

class _MethodHeader extends StatelessWidget {
  const _MethodHeader({required this.method});

  final BrewMethod method;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Row(
        children: [
          Icon(methodIcon(method), color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(method.label, style: theme.textTheme.titleLarge),
          const SizedBox(width: 8),
          Text(method.style, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(recipe.name),
        subtitle: Text(
          '${formatGrams(recipe.coffeeGrams)} · '
          '${formatRatio(recipe.ratio)} · '
          '${recipe.grind.label} · '
          '${formatBrewTime(recipe.totalTime)}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => RecipeScreen(recipe: recipe))),
      ),
    );
  }
}
