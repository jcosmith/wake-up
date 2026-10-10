import 'package:flutter/material.dart';

import '../data/grinders.dart';
import '../models/grind.dart';
import '../models/grinder.dart';
import '../state/app_state.dart';

/// Pick your grinder and see its full settings chart.
class GrindersScreen extends StatelessWidget {
  const GrindersScreen({super.key, this.highlight});

  /// Grind size to emphasise, e.g. the one the current recipe needs.
  final GrindSize? highlight;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Grinder settings')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Clicks are counted from zero: close the burrs until they just '
              'touch, then count clicks as you open them. These are '
              'approximate starting points, so dial in by taste.',
            ),
          ),
          for (final g in grinders)
            _GrinderTile(
              grinder: g,
              selected: g.id == state.grinder.id,
              highlight: highlight,
              onSelect: () => state.grinder = g,
            ),
        ],
      ),
    );
  }
}

class _GrinderTile extends StatelessWidget {
  const _GrinderTile({
    required this.grinder,
    required this.selected,
    required this.onSelect,
    this.highlight,
  });

  final HandGrinder grinder;
  final bool selected;
  final VoidCallback onSelect;
  final GrindSize? highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: selected
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ExpansionTile(
        key: PageStorageKey(grinder.id),
        initiallyExpanded: selected,
        shape: const Border(),
        leading: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: selected ? theme.colorScheme.primary : null,
        ),
        title: Text(grinder.name),
        subtitle: Text('~${_microns(grinder.micronsPerClick)} µm per click'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          for (final size in GrindSize.values)
            Container(
              decoration: size == highlight
                  ? BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(child: Text(size.label)),
                  Text(
                    grinder.describe(size),
                    style: grinder.settingFor(size) == null
                        ? theme.textTheme.bodyMedium?.copyWith(
                            color: theme.disabledColor,
                          )
                        : theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                  ),
                ],
              ),
            ),
          if (grinder.notes != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(grinder.notes!, style: theme.textTheme.bodySmall),
            ),
          if (!selected)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onSelect,
                child: const Text('Use this grinder'),
              ),
            ),
        ],
      ),
    );
  }

  static String _microns(double v) =>
      v == v.roundToDouble() ? v.round().toString() : v.toString();
}
