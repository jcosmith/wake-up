import 'package:coffee_timer/main.dart';
import 'package:coffee_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('open a recipe, see grind setting and run the timer', (
    tester,
  ) async {
    await tester.pumpWidget(
      CoffeeTimerApp(state: AppState(grinderId: 'comandante-c40')),
    );

    expect(find.text('The Ultimate V60'), findsOneWidget);
    await tester.tap(find.text('The Ultimate V60'));
    await tester.pumpAndSettle();

    // Grind setting for the selected grinder.
    expect(find.text('Comandante C40 MK4'), findsOneWidget);
    expect(find.text('20–26 clicks'), findsOneWidget);

    // Halving the dose scales the water.
    for (var i = 0; i < 15; i++) {
      await tester.tap(find.byTooltip('Less coffee'));
    }
    await tester.pump();
    expect(find.text('15 g'), findsOneWidget);
    expect(find.text('250 g'), findsOneWidget);

    await tester.tap(find.text('Start brewing'));
    await tester.pumpAndSettle();
    expect(find.text('Bloom'), findsWidgets);
    expect(find.text('Pour to 30 g'), findsOneWidget);

    await tester.tap(find.byKey(const Key('startPause')));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Pause'), findsOneWidget);
    await tester.tap(find.byKey(const Key('startPause')));
    await tester.pump();
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets('switching grinder updates the setting', (tester) async {
    final state = AppState(grinderId: 'comandante-c40');
    await tester.pumpWidget(CoffeeTimerApp(state: state));
    await tester.tap(find.byTooltip('Grinder settings'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('1Zpresso K-Ultra'), 200);
    await tester.tap(find.text('1Zpresso K-Ultra'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Use this grinder'), 200);
    await tester.tap(find.text('Use this grinder'));
    await tester.pumpAndSettle();
    expect(state.grinder.id, '1zpresso-k-ultra');
  });

  testWidgets('rating brews unlocks a tuned version', (tester) async {
    await tester.pumpWidget(
      CoffeeTimerApp(state: AppState(grinderId: 'comandante-c40')),
    );
    await tester.tap(find.text('The Ultimate V60'));
    await tester.pumpAndSettle();
    expect(find.textContaining('0 of 3 ratings'), findsOneWidget);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byTooltip('Rate a brew'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('4 stars'));
      await tester.tap(find.text('Sour'));
      await tester.tap(find.text('A bit weak'));
      await tester.pump();
      await tester.tap(find.text('Send feedback'));
      await tester.pumpAndSettle();
    }

    // The original stays selected until the tuned one is picked.
    expect(find.text('Original'), findsOneWidget);
    expect(find.text('30 g'), findsOneWidget);
    expect(find.text('20–26 clicks'), findsOneWidget);

    await tester.tap(find.text('Tuned'));
    await tester.pumpAndSettle();
    expect(find.textContaining('more coffee'), findsOneWidget);
    expect(find.textContaining('finer than the original'), findsOneWidget);
    expect(find.text('20–26 clicks'), findsNothing);
  });
}
