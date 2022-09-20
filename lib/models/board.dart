import 'dart:math';
import 'package:logger/logger.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'game_cell_content.dart';

class Board {
  final int boardWidth;
  final int noOfMines;
  late final List<GameCell> cells;
  List<int> mines = [];

  Logger logger = Logger(level: Level.error);

  Board(
      {required this.boardWidth,
      required this.cells,
      required this.mines,
      required this.noOfMines}) {
    logger.d('Board is created.');
    printBoard();
    printMines();
  }

  Board copyWith({
    int? boardWidth,
    List<GameCell>? cells,
    List<int>? mines,
    int? noOfMines,
  }) {
    return Board(
      boardWidth: boardWidth ?? this.boardWidth,
      cells: cells ?? this.cells,
      mines: mines ?? this.mines,
      noOfMines: noOfMines ?? this.noOfMines,
    );
  }

  factory Board.init(GameSettings settings) {
    final List<GameCell> cells = List.generate(
        settings.boardWidth * settings.boardWidth,
        (_) => GameCell(gameCellContent: GameCellContent()));

    final board = Board(
      boardWidth: settings.boardWidth,
      cells: cells,
      mines: <int>[],
      noOfMines: settings.noOfMines,
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

  bool tapCell(int index, bool isFlagging) {
    logger.d('tapCell called $index');
    placeMinesIfNotDone(index);
    if (isFlagging) {
      flagCell(index);
      return false;
    } else {
      bool hitMine = digCell(index);
      return hitMine;
    }
  }

  bool havePlacedMines() {
    return mines.isNotEmpty;
  }

  void placeMinesIfNotDone(int index) {
    if (mines.isEmpty) {
      // No mines. Place new mines but avoid this cell and all neighbours
      mines = getRandomMineList(
        boardWidth * boardWidth,
        noOfMines,
        index,
      );
      // Set the cellcontent of the mines
      setHiddenMines();
      // and calculate the cells neighbour mine count
      setNeighbourCounts();
    }
  }

  bool digCell(int index) {
    if (!cells[index].gameCellContent.isDown()) {
      cells[index].gameCellContent.digCell();
      if (cells[index].gameCellContent.gameCellType == GameCellType.empty) {
        // Empty cell so it is safe to tap all neighbours
        final neighbourList = getNeighbourIndexList(index);
        for (int neighbour in neighbourList) {
          digCell(neighbour);
        }
      }
      return mines.contains(index);
    }
    return false;
  }

  void flagCell(int index) {
    cells[index].gameCellContent.flagCell();
  }

  Board copy() {
    List<GameCell> newCells = [];
    for (var cell in cells) {
      newCells.add(GameCell(gameCellContent: cell.gameCellContent));
    }

    Board copiedBoard = Board(
        boardWidth: boardWidth,
        cells: newCells,
        mines: mines,
        noOfMines: noOfMines);
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
        if (!cell.gameCellContent.isDown()) {
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
