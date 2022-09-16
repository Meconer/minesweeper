import 'dart:math';
import 'package:logger/logger.dart';
import 'game_cell_content.dart';

class Board {
  final int boardWidth;
  late final List<GameCell> cells;
  late final List<int> mines;
  Logger logger = Logger(level: Level.error);

  Board({
    required this.boardWidth,
    required this.cells,
    required this.mines,
  }) {
    logger.d('Board is created.');
    printBoard();
    printMines();
  }

  Board copyWith({int? boardWidth, List<GameCell>? cells, List<int>? mines}) {
    return Board(
      boardWidth: boardWidth ?? this.boardWidth,
      cells: cells ?? this.cells,
      mines: mines ?? this.mines,
    );
  }

  factory Board.init(int boardWidth, int noOfMines) {
    final List<GameCell> cells = List.generate(boardWidth * boardWidth,
        (_) => GameCell(gameCellContent: GameCellContent()));

    final board = Board(
      boardWidth: boardWidth,
      cells: cells,
      mines: <int>[],
    );

    return board;
  }

  printBoard() {
    for (int row = 0; row < boardWidth; row++) {
      String line = '';
      for (int col = 0; col < boardWidth; col++) {
        line += cells[row * boardWidth + col].gameCellContent.gameCellType.name;
      }
      logger.d(line);
    }
  }

  printMines() {
    String line = '';
    for (int mine in mines) {
      line += '$mine ';
    }
    logger.d(line);
  }

  int getCol(int index) {
    return index % boardWidth;
  }

  int getRow(int index) {
    return index ~/ boardWidth;
  }

  int getCellIndexFromRowCol(int row, int col) {
    return row * boardWidth + col;
  }

  List<int> getNeighbourIndexList(int cellIndex) {
    int col = getCol(cellIndex);
    int row = getRow(cellIndex);
    var list = <int>[];
    for (int rowToCheck = row - 1; rowToCheck <= row + 1; rowToCheck++) {
      for (int colToCheck = col - 1; colToCheck <= col + 1; colToCheck++) {
        if (rowToCheck != row || colToCheck != col) {
          if (rowToCheck >= 0 &&
              rowToCheck < boardWidth &&
              colToCheck >= 0 &&
              colToCheck < boardWidth) {
            list.add(getCellIndexFromRowCol(rowToCheck, colToCheck));
          }
        }
      }
    }
    return list;
  }

  int countNeighbourMines(int cellIndex) {
    int noOfMines = 0;
    for (int index in getNeighbourIndexList(cellIndex)) {
      if (mines.contains(index)) noOfMines++;
    }

    return noOfMines;
  }

  bool hasMine(int row, int col) {
    if (row < 0 || row > boardWidth) return false;
    if (col < 0 || col > boardWidth) return false;
    return mines.contains(getCellIndexFromRowCol(row, col));
  }

  List<int> getRandomMineList(
      int boardSize, int noOfMines, int cellIndexToAvoid) {
    // Place the mines
    List<int> mines = [];
    List<int> cellsToAvoid = getNeighbourIndexList(cellIndexToAvoid);
    cellsToAvoid.add(cellIndexToAvoid);
    while (mines.length < noOfMines) {
      int nextMine = Random().nextInt(boardSize);
      if (!mines.contains(nextMine) && !cellsToAvoid.contains(nextMine)) {
        mines.add(nextMine);
      }
    }
    return mines;
  }

  void digCell(int index) {
    if (!cells[index].gameCellContent.isDown()) {
      cells[index].gameCellContent.digCell();
      if (cells[index].gameCellContent.gameCellType == GameCellType.empty) {
        // Empty cell so it is safe to tap all neighbours
        final neighbourList = getNeighbourIndexList(index);
        for (int neighbour in neighbourList) {
          digCell(neighbour);
        }
      }
    }
  }

  void flagCell(int index) {
    cells[index].gameCellContent.flagCell();
  }

  Board copy() {
    List<GameCell> newCells = [];
    for (var cell in cells) {
      newCells.add(GameCell(gameCellContent: cell.gameCellContent));
    }

    Board copiedBoard =
        Board(boardWidth: boardWidth, cells: newCells, mines: mines);
    return copiedBoard;
  }

  void gameOver() {
    logger.d('Game over!');
    for (int cellIndex in mines) {
      cells[cellIndex].gameCellContent.gameCellType = GameCellType.explodedMine;
    }
  }

  void setNeighbourCounts() {
    for (int cellIndex = 0; cellIndex < boardWidth * boardWidth; cellIndex++) {
      if (!mines.contains(cellIndex)) {
        cells[cellIndex].gameCellContent.noOfNeighbourMines =
            countNeighbourMines(cellIndex);
      }
    }
  }

  void setHiddenMines() {
    for (int cellIndex in mines) {
      cells[cellIndex].gameCellContent.gameCellType = GameCellType.hiddenMine;
    }
  }

  bool areAllCellsMarked() {
    for (final cell in cells) {
      if (!cell.gameCellContent.isFlagged && !cell.gameCellContent.isDown()) {
        return false;
      }
    }
    return true;
  }

  bool hasWon() {
    // Check all cells
    for (final cell in cells) {
      // Check if we have flagged a cell without a mine
      if (cell.gameCellContent.isFlagged) {
        if (cell.gameCellContent.gameCellType != GameCellType.hiddenMine) {
          return false;
        }
      } else {
        // Check if cell is not digged
        if (cell.gameCellContent.gameCellType == GameCellType.hidden ||
            cell.gameCellContent.gameCellType == GameCellType.hiddenMine) {
          return false;
        }
      }
    }
    // All cells are either flagged correctly or digged. Then we have won
    return true;
  }
}

class GameCell {
  GameCellContent gameCellContent;
  GameCell({required this.gameCellContent});
}