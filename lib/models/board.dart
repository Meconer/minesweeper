import 'dart:math';
import 'package:logger/logger.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/services/game_solver.dart';
import 'game_cell_content.dart';

class Board {
  final int boardWidth;
  final int noOfMines;
  bool generateSolvable;
  late final List<GameCellContent> cells;
  List<int> mines = [];

  Logger logger = Logger(level: Level.error);

  Board({
    required this.boardWidth,
    required this.cells,
    required this.mines,
    required this.noOfMines,
    required this.generateSolvable,
  }) {
    logger.d('Board is created.');
    printBoard();
    printMines();
  }

  Board copyWith({
    int? boardWidth,
    List<GameCellContent>? cells,
    List<int>? mines,
    int? noOfMines,
    bool? generateSolvable,
  }) {
    return Board(
      boardWidth: boardWidth ?? this.boardWidth,
      cells: cells ?? this.cells,
      mines: mines ?? this.mines,
      noOfMines: noOfMines ?? this.noOfMines,
      generateSolvable: generateSolvable ?? this.generateSolvable,
    );
  }

  factory Board.init(GameSettings settings) {
    final List<GameCellContent> cells = List.generate(
        settings.boardWidth * settings.boardWidth,
        (_) => GameCellContent.hiddenCell());

    final board = Board(
      boardWidth: settings.boardWidth,
      cells: cells,
      mines: <int>[],
      noOfMines: settings.noOfMines,
      generateSolvable: settings.generateSolvable,
    );

    return board;
  }

  printBoard() {
    for (int row = 0; row < boardWidth; row++) {
      String line = '';
      for (int col = 0; col < boardWidth; col++) {
        line += cells[row * boardWidth + col].gameCellType.name;
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
      if (generateSolvable) {
        bool solvable = false;
        while (!solvable) {
          final testBoard = copy();
          // No mines. Place new mines but avoid this cell and all neighbours
          testBoard.mines = getRandomMineList(
            boardWidth * boardWidth,
            noOfMines,
            index,
          );
          // Set the cellcontent of the mines
          testBoard.setHiddenMines();
          // and calculate the cells neighbour mine count
          testBoard.setNeighbourCounts();
          solvable = GameSolver(testBoard).solve(index);
          if (solvable) mines = testBoard.mines;
        }
      } else {
        mines = getRandomMineList(
          boardWidth * boardWidth,
          noOfMines,
          index,
        );
      }
      setHiddenMines();
      setNeighbourCounts();
    }
  }

  bool digCell(int index) {
    if (!cells[index].isDown()) {
      cells[index].digCell();
      if (cells[index].gameCellType == GameCellType.empty) {
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
    cells[index].flagCell();
  }

  Board copy() {
    List<GameCellContent> newCells = [];
    for (var cell in cells) {
      var newCell = cell.copy();
      newCells.add(newCell);
    }

    List<int> newMines = [];
    for (var mine in mines) {
      newMines.add(mine);
    }

    Board copiedBoard = Board(
      boardWidth: boardWidth,
      cells: newCells,
      mines: newMines,
      noOfMines: noOfMines,
      generateSolvable: generateSolvable,
    );
    return copiedBoard;
  }

  void gameOver() {
    logger.d('Game over!');
    for (int cellIndex in mines) {
      cells[cellIndex].gameCellType = GameCellType.explodedMine;
    }
  }

  void setNeighbourCounts() {
    for (int cellIndex = 0; cellIndex < boardWidth * boardWidth; cellIndex++) {
      if (!mines.contains(cellIndex)) {
        cells[cellIndex].noOfNeighbourMines = countNeighbourMines(cellIndex);
      }
    }
  }

  void setHiddenMines() {
    for (int cellIndex in mines) {
      cells[cellIndex].gameCellType = GameCellType.hiddenMine;
    }
  }

  bool areAllCellsMarked() {
    for (final cell in cells) {
      if (!cell.isFlagged && !cell.isDown()) {
        return false;
      }
    }
    return true;
  }

  bool hasWon() {
    // Check all cells
    for (final cell in cells) {
      // Check if we have flagged a cell without a mine
      if (cell.isFlagged) {
        if (cell.gameCellType != GameCellType.hiddenMine) {
          return false;
        }
      } else {
        // Check if cell is not digged
        if (!cell.isDown()) {
          return false;
        }
      }
    }
    // All cells are either flagged correctly or digged. Then we have won
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'boardWidth': boardWidth,
      'noOfMines': noOfMines,
      'cells': cells.map((e) => e.toJson()).toList(),
      'mines': mines,
      'generateSolvable': generateSolvable,
    };
  }

  factory Board.fromJson(json) {
    int boardWidth = json['boardWidth'];
    int noOfMines = json['noOfMines'];
    bool generateSolvable = json['generateSolvable'];
    final jsonCellArray = json['cells'];
    List<GameCellContent> cells = [];
    for (var jsonCell in jsonCellArray) {
      cells.add(GameCellContent.fromJson(jsonCell));
    }
    List<int> mines = [];
    for (var mine in json['mines']) {
      int newMine = mine;
      mines.add(newMine);
    }
    return Board(
      boardWidth: boardWidth,
      cells: cells,
      mines: mines,
      noOfMines: noOfMines,
      generateSolvable: generateSolvable,
    );
  }

  String getBoardString() {
    String boardStr = ' \n';
    for (var row = 0; row < boardWidth; row++) {
      String line = '$row : ';
      for (var col = 0; col < boardWidth; col++) {
        int index = getCellIndexFromRowCol(row, col);
        final cell = cells[index];
        if (cell.isFlagged) {
          line += 'f';
        } else if (cell.gameCellType == GameCellType.empty) {
          line += '_';
        } else if (cell.gameCellType == GameCellType.hidden ||
            cell.gameCellType == GameCellType.hiddenMine) {
          line += 'O';
        } else if (cell.gameCellType == GameCellType.mineNeighbour) {
          line += cell.noOfNeighbourMines.toString();
        } else if (cell.gameCellType == GameCellType.explodedMine) {
          line += 'X';
        }
      }
      boardStr += '$line\n';
    }
    boardStr += '    --------';
    return boardStr;
  }
}
