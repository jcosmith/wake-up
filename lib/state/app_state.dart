import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/grinders.dart';
import '../models/grinder.dart';

/// App-wide settings: currently just the user's grinder.
class AppState extends ChangeNotifier {
  AppState({SharedPreferences? prefs, String? grinderId})
    : _prefs = prefs,
      _grinder = grinderById(
        grinderId ?? prefs?.getString(_grinderKey) ?? grinders.first.id,
      );

  static const _grinderKey = 'grinder';

  final SharedPreferences? _prefs;
  HandGrinder _grinder;

  HandGrinder get grinder => _grinder;

  set grinder(HandGrinder value) {
    if (value.id == _grinder.id) return;
    _grinder = value;
    _prefs?.setString(_grinderKey, value.id);
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.notifier!;
}
