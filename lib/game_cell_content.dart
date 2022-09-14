import 'package:logger/logger.dart';

enum GameCellType { empty, mineNeighbour, hiddenMine, explodedMine, hidden }

class GameCellContent {
  GameCellType gameCellType = GameCellType.hidden;
  int noOfNeighbourMines = 0;
  bool isFlagged = false;

  final logger = Logger(level: Level.error);

  bool isDown() {
    return gameCellType != GameCellType.hidden &&
        gameCellType != GameCellType.hiddenMine;
  }

  void digCell() {
    logger.d('digCell ${gameCellType.name}');
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
}
