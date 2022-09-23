import 'package:logger/logger.dart';

enum GameCellType { empty, mineNeighbour, hiddenMine, explodedMine, hidden }

class GameCellContent {
  GameCellType gameCellType = GameCellType.hidden;
  int noOfNeighbourMines = 0;
  bool isFlagged = false;

  final logger = Logger(level: Level.error);

  GameCellContent({
    required this.gameCellType,
    required this.noOfNeighbourMines,
    required this.isFlagged,
  });

  bool isDown() {
    return gameCellType != GameCellType.hidden &&
        gameCellType != GameCellType.hiddenMine;
  }

  void digCell() {
    logger.d('digCell ${gameCellType.name}');
    isFlagged = false;
    if (gameCellType == GameCellType.hiddenMine) {
      gameCellType = GameCellType.explodedMine;
    } else if (noOfNeighbourMines > 0) {
      gameCellType = GameCellType.mineNeighbour;
    } else {
      gameCellType = GameCellType.empty;
      logger.d('Empty');
    }
  }

  void flagCell() {
    if (!isDown()) isFlagged = !isFlagged;
  }

  Map<String, dynamic> toJson() {
    return {
      'gameCellType': gameCellType.name,
      'noOfNeighbourMines': noOfNeighbourMines,
      'isFlagged': isFlagged,
    };
  }

  factory GameCellContent.fromJson(Map<String, dynamic> jsonCell) {
    final noOfNeighbourMines = jsonCell['noOfNeighbourMines'];
    final gameCellType = GameCellType.values.byName(jsonCell['gameCellType']);
    final isFlagged = jsonCell['isFlagged'];
    return GameCellContent(
      gameCellType: gameCellType,
      noOfNeighbourMines: noOfNeighbourMines,
      isFlagged: isFlagged,
    );
  }

  factory GameCellContent.hiddenCell() {
    return GameCellContent(
      gameCellType: GameCellType.hidden,
      noOfNeighbourMines: 0,
      isFlagged: false,
    );
  }
}
