import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_settings.dart';

class StoredSettings {
  static const String boardWithKey = 'BoardWith';
  static const String noOfMinesKey = 'NoOfMines';
  static const String difficultySettingKey = 'diffSetting';
  static const String generateSolvableKey = 'generateSolvable';

  Future<void> saveSettings(GameSettings gameSettings) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(boardWithKey, gameSettings.boardWidth);
    prefs.setInt(noOfMinesKey, gameSettings.noOfMines);
    prefs.setString(difficultySettingKey, gameSettings.settingName);
  }

  Future<GameSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final defaultSetting = GameSettings.easy();
    int boardWidth = prefs.getInt(boardWithKey) ?? defaultSetting.boardWidth;
    int noOfMines = prefs.getInt(noOfMinesKey) ?? defaultSetting.noOfMines;
    String settingName =
        prefs.getString(difficultySettingKey) ?? defaultSetting.settingName;
    bool generateSolvable =
        prefs.getBool(generateSolvableKey) ?? defaultSetting.generateSolvable;
    GameSettings settings = GameSettings(
        boardWidth: boardWidth,
        noOfMines: noOfMines,
        settingName: settingName,
        generateSolvable: generateSolvable);
    return settings;
  }
}
