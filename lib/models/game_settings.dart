class GameSettings {
  int boardWidth;
  int noOfMines;
  String settingName;

  GameSettings({
    required this.boardWidth,
    required this.noOfMines,
    required this.settingName,
  });

  factory GameSettings.easy() {
    return GameSettings(
      boardWidth: 8,
      noOfMines: 10,
      settingName: 'Easy',
    );
  }

  factory GameSettings.medium() {
    return GameSettings(
      boardWidth: 12,
      noOfMines: 30,
      settingName: 'Medium',
    );
  }

  factory GameSettings.hard() {
    return GameSettings(
      boardWidth: 16,
      noOfMines: 50,
      settingName: 'Hard',
    );
  }

  static List<GameSettings> standardSettings = [
    GameSettings.easy(),
    GameSettings.medium(),
    GameSettings.hard(),
  ];

  static GameSettings? byName(String? name) {
    if (name == 'Easy') return GameSettings.easy();
    if (name == 'Medium') return GameSettings.medium();
    if (name == 'Hard') return GameSettings.hard();
    return null;
  }
}
