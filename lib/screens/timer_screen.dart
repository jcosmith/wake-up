import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../format.dart';
import '../models/brew_session.dart';

/// Runs a brew: elapsed time, the current step and when the next one starts.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.session});

  final BrewSession session;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _stopwatch = Stopwatch();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  int _lastStep = 0;
  bool _finishedAlerted = false;

  BrewSession get session => widget.session;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _toggle() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _ticker?.cancel();
    } else {
      _stopwatch.start();
      _ticker = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) => _tick(),
      );
      HapticFeedback.mediumImpact();
    }
    setState(() {});
  }

  void _reset() {
    _stopwatch
      ..stop()
      ..reset();
    _ticker?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _lastStep = 0;
      _finishedAlerted = false;
    });
  }

  void _tick() {
    final elapsed = _stopwatch.elapsed;
    final step = session.stepIndexAt(elapsed);
    if (step != _lastStep) {
      _lastStep = step;
      _alert();
    }
    if (!_finishedAlerted && session.isFinishedAt(elapsed)) {
      _finishedAlerted = true;
      _alert();
    }
    setState(() => _elapsed = elapsed);
  }

  void _alert() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recipe = session.recipe;
    final stepIndex = session.stepIndexAt(_elapsed);
    final step = recipe.steps[stepIndex];
    final next = session.nextStepAfter(_elapsed);
    final remaining = session.remainingInStep(_elapsed);
    final finished = session.isFinishedAt(_elapsed);
    final waterTarget = session.waterTargetAt(_elapsed);
    final running = _stopwatch.isRunning;

    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 240,
                      height: 240,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: session.progressAt(_elapsed),
                            strokeWidth: 10,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formatDuration(_elapsed),
                                  key: const Key('elapsed'),
                                  style: theme.textTheme.displayMedium
                                      ?.copyWith(
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                ),
                                Text(
                                  finished
                                      ? 'Done — enjoy'
                                      : 'of ${formatBrewTime(recipe.totalTime)}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                if (waterTarget > 0) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Scale: ${formatGrams(waterTarget)}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      color: theme.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step ${stepIndex + 1} of ${recipe.steps.length}',
                              style: theme.textTheme.labelMedium,
                            ),
                            Text(
                              step.title,
                              style: theme.textTheme.headlineSmall,
                            ),
                            if (session.pourTargetFor(step) != null)
                              Text(
                                'Pour to ${formatGrams(session.pourTargetFor(step)!)}',
                                style: theme.textTheme.titleMedium,
                              ),
                            if (step.detail != null) ...[
                              const SizedBox(height: 4),
                              Text(step.detail!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (next != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Text(
                        'Next: ${next.title} in ${formatDuration(remaining)}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  for (var i = 0; i < recipe.steps.length; i++)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 32,
                      ),
                      dense: true,
                      selected: i == stepIndex,
                      leading: Icon(
                        i < stepIndex || (finished && i == stepIndex)
                            ? Icons.check_circle
                            : i == stepIndex
                            ? Icons.play_circle
                            : Icons.circle_outlined,
                      ),
                      title: Text(recipe.steps[i].title),
                      trailing: Text(formatDuration(recipe.steps[i].at)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _elapsed == Duration.zero && !running
                          ? null
                          : _reset,
                      icon: const Icon(Icons.replay),
                      label: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      key: const Key('startPause'),
                      onPressed: _toggle,
                      icon: Icon(running ? Icons.pause : Icons.play_arrow),
                      label: Text(
                        running
                            ? 'Pause'
                            : _elapsed == Duration.zero
                            ? 'Start'
                            : 'Resume',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
