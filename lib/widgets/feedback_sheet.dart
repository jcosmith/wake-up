import 'package:flutter/material.dart';

import '../models/feedback.dart';
import '../models/recipe.dart';
import '../state/app_state.dart';

/// Asks how a brew of [recipe] turned out and saves the answer. Resolves to
/// true when feedback was saved.
Future<bool> showFeedbackSheet(BuildContext context, Recipe recipe) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FeedbackSheet(recipe: recipe),
  );
  return saved ?? false;
}

class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet({required this.recipe});

  final Recipe recipe;

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  int _rating = 0;
  TasteBalance _taste = TasteBalance.balanced;
  Strength _strength = Strength.justRight;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final store = AppStateScope.of(context).feedback;
    await store.add(
      RecipeFeedback.forBrew(
        widget.recipe,
        rating: _rating,
        taste: _taste,
        strength: _strength,
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How was it?', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    tooltip: '$i star${i == 1 ? '' : 's'}',
                    icon: Icon(i <= _rating ? Icons.star : Icons.star_border),
                    color: theme.colorScheme.primary,
                    onPressed: () => setState(() => _rating = i),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Taste', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in TasteBalance.values)
                  ChoiceChip(
                    label: Text(t.label),
                    selected: _taste == t,
                    onSelected: (_) => setState(() => _taste = t),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Strength', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final s in Strength.values)
                  ChoiceChip(
                    label: Text(s.label),
                    selected: _strength == s,
                    onSelected: (_) => setState(() => _strength = s),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _rating == 0 || _saving ? null : _save,
                child: const Text('Send feedback'),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your feedback tunes this recipe: sour or bitter adjusts the '
              'grind, weak or strong adjusts the dose.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
