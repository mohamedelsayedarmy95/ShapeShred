import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _userGoalKey = 'user_goal';
  static const String _fitnessLevelKey = 'fitness_level';
  static const String _userGenderKey = 'user_gender';
  static const String _userHeightKey = 'user_height';
  static const String _userWeightKey = 'user_weight';
  static const String _userAgeKey = 'user_age';

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setOnboardingComplete(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_onboardingCompleteKey, value);
  }

  static Future<bool> isOnboardingComplete() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  static Future<void> setUserGoal(String goal) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userGoalKey, goal);
  }

  static Future<String?> getUserGoal() async {
    final prefs = await _getPrefs();
    return prefs.getString(_userGoalKey);
  }

  static Future<void> setFitnessLevel(String level) async {
    final prefs = await _getPrefs();
    await prefs.setString(_fitnessLevelKey, level);
  }

  static Future<String?> getFitnessLevel() async {
    final prefs = await _getPrefs();
    return prefs.getString(_fitnessLevelKey);
  }

  static Future<void> setUserGender(String gender) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userGenderKey, gender);
  }

  static Future<String?> getUserGender() async {
    final prefs = await _getPrefs();
    return prefs.getString(_userGenderKey);
  }

  static Future<void> setUserHeight(double height) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_userHeightKey, height);
  }

  static Future<double?> getUserHeight() async {
    final prefs = await _getPrefs();
    return prefs.getDouble(_userHeightKey);
  }

  static Future<void> setUserWeight(double weight) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_userWeightKey, weight);
  }

  static Future<double?> getUserWeight() async {
    final prefs = await _getPrefs();
    return prefs.getDouble(_userWeightKey);
  }

  static Future<void> setUserAge(int age) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_userAgeKey, age);
  }

  static Future<int?> getUserAge() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_userAgeKey);
  }
}
