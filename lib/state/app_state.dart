import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/grinders.dart';
import '../feedback/feedback_store.dart';
import '../models/grinder.dart';

/// App-wide settings and services: the user's grinder and where recipe
/// feedback is stored.
class AppState extends ChangeNotifier {
  AppState({
    SharedPreferences? prefs,
    String? grinderId,
    FeedbackStore? feedback,
  }) : _prefs = prefs,
       feedback =
           feedback ??
           (prefs == null ? MemoryFeedbackStore() : LocalFeedbackStore(prefs)),
       _grinder = grinderById(
         grinderId ?? prefs?.getString(_grinderKey) ?? grinders.first.id,
       );

  static const _grinderKey = 'grinder';

  final SharedPreferences? _prefs;
  final FeedbackStore feedback;
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
