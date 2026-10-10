import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/feedback.dart';

/// Where recipe feedback is kept.
///
/// The app currently stores feedback on the device. A shared backend that
/// pools everyone's feedback implements this same interface and returns all
/// users' entries from [forRecipe]; tuning then works across users with no
/// other changes.
abstract class FeedbackStore {
  Future<void> add(RecipeFeedback feedback);

  Future<List<RecipeFeedback>> forRecipe(String recipeId);
}

/// Keeps feedback on this device with shared_preferences.
class LocalFeedbackStore implements FeedbackStore {
  LocalFeedbackStore(this._prefs);

  final SharedPreferences _prefs;

  static String _key(String recipeId) => 'feedback.$recipeId';

  @override
  Future<void> add(RecipeFeedback feedback) async {
    final key = _key(feedback.recipeId);
    final entries = _prefs.getStringList(key) ?? const [];
    await _prefs.setStringList(key, [
      ...entries,
      jsonEncode(feedback.toJson()),
    ]);
  }

  @override
  Future<List<RecipeFeedback>> forRecipe(String recipeId) async {
    final entries = _prefs.getStringList(_key(recipeId)) ?? const [];
    return [
      for (final e in entries)
        RecipeFeedback.fromJson(jsonDecode(e) as Map<String, dynamic>),
    ];
  }
}

/// Keeps feedback in memory only; used in tests and when no storage is set.
class MemoryFeedbackStore implements FeedbackStore {
  final _entries = <RecipeFeedback>[];

  @override
  Future<void> add(RecipeFeedback feedback) async => _entries.add(feedback);

  @override
  Future<List<RecipeFeedback>> forRecipe(String recipeId) async =>
      _entries.where((f) => f.recipeId == recipeId).toList();
}
