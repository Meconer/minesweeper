class GameSettings {
  int boardWidth;
  int noOfMines;
  String settingName;
  bool generateSolvable;

  GameSettings({
    required this.boardWidth,
    required this.noOfMines,
    required this.settingName,
    required this.generateSolvable,
  });

  factory GameSettings.easy() {
    return GameSettings(
      boardWidth: 8,
      noOfMines: 10,
      settingName: 'Easy',
      generateSolvable: true,
    );
  }

  factory GameSettings.medium() {
    return GameSettings(
      boardWidth: 12,
      noOfMines: 30,
      settingName: 'Medium',
      generateSolvable: true,
    );
  }

  factory GameSettings.hard() {
    return GameSettings(
      boardWidth: 16,
      noOfMines: 50,
      settingName: 'Hard',
      generateSolvable: true,
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

  Map<String, dynamic> toJson() {
    return {
      'boardWidth': boardWidth,
      'noOfMines': noOfMines,
      'settingName': settingName,
      'generateSolvable': generateSolvable
    };
  }

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    int boardWidth = json['boardWidth'];
    int noOfMines = json['noOfMines'];
    String settingName = json['settingName'];
    bool generateSolvable = json['generateSolvable'];
    return GameSettings(
      boardWidth: boardWidth,
      noOfMines: noOfMines,
      settingName: settingName,
      generateSolvable: generateSolvable,
    );
  }
}
