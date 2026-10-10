import 'package:flutter/material.dart';

import '../models/grind.dart';
import '../screens/grinders_screen.dart';
import '../state/app_state.dart';

/// Shows the grind size for a recipe on the user's grinder, with a shortcut
/// to switch grinders.
class GrindCard extends StatelessWidget {
  const GrindCard({super.key, required this.grind, this.offsetMicrons = 0});

  final GrindSize grind;

  /// Fine adjustment from tuning; negative is finer.
  final double offsetMicrons;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final grinder = state.grinder;
    final offsetClicks = grinder.clicksFor(offsetMicrons);
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => GrindersScreen(highlight: grind)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.settings_input_component,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${grind.label} grind',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(grind.description, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(grinder.name, style: theme.textTheme.labelLarge),
                    Text(
                      grinder.describe(grind, offsetClicks: offsetClicks),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (offsetClicks != 0)
                      Text(
                        '${offsetClicks.abs()} '
                        'click${offsetClicks.abs() == 1 ? '' : 's'} '
                        '${offsetClicks < 0 ? 'finer' : 'coarser'} '
                        'than the original',
                        style: theme.textTheme.labelMedium,
                      ),
                    Text(
                      'Approximate starting point — adjust to taste.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
