import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService(this._prefs);

  static const String _highScoreKey = 'high_score';
  static const String _soundEnabledKey = 'sound_enabled';

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  int get highScore => _prefs.getInt(_highScoreKey) ?? 0;

  bool get soundEnabled => _prefs.getBool(_soundEnabledKey) ?? true;

  Future<void> saveHighScore(int score) async {
    await _prefs.setInt(_highScoreKey, score);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }
}
