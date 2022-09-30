import 'package:logger/logger.dart';
import 'package:minesweeper/models/board.dart';
import 'package:minesweeper/models/game_cell_content.dart';

class GameSolver {
  final Board board;
  final logger = Logger(level: Level.error);

  GameSolver(this.board);

  // Tries to solve a game without guessing. Returns true of possible
  // First dig in cell[index]
  bool solve(int index) {
    board.tapCell(index, false); // Tap first cell

    printBoard();
    bool changed = true;
    while (changed) {
      changed = false;
      bool didSetFlags = flagKnownMines();
      changed = changed || didSetFlags;
      bool didDig = digSafeCells();
      changed = changed || didDig;
    }
    printBoard();

    var solved = isSolved();
    return solved;
  }

  bool flagKnownMines() {
    bool changed = false;
    for (var cellIndex = 0; cellIndex < board.cells.length; cellIndex++) {
      final currentCell = board.cells[cellIndex];

      if (currentCell.gameCellType == GameCellType.mineNeighbour) {
        int unCheckedNeighbourCount = countUnDugNeighbours(cellIndex);
        if (unCheckedNeighbourCount == currentCell.noOfNeighbourMines) {
          int noNewFlagged = flagAllUnCheckedNeighbours(cellIndex);
          changed = changed || noNewFlagged > 0;
        }
      }
    }
    return changed;
  }

  int flagAllUnCheckedNeighbours(int index) {
    int count = 0;
    final neighbours = getNeighbourIndexList(index);
    for (final cellIndex in neighbours) {
      final cell = board.cells[cellIndex];
      if (cell.isFlagged || cell.isDown()) continue;
      count++;
      cell.isFlagged = true;
    }
    return count;
  }

  bool digSafeCells() {
    bool changed = false;
    for (var cellIndex = 0; cellIndex < board.cells.length; cellIndex++) {
      final currentCell = board.cells[cellIndex];
      if (currentCell.gameCellType == GameCellType.mineNeighbour) {
        int flaggedNeighbours = countFlaggedNeighbours(cellIndex);
        if (flaggedNeighbours == currentCell.noOfNeighbourMines) {
          int noDigged = digAllUnFlaggedNeighbours(cellIndex);
          changed = noDigged > 0;
        }
      } else if (currentCell.gameCellType == GameCellType.empty) {
        int noDigged = digAllNeighbours(cellIndex);
        changed = changed || noDigged > 0;
      }
    }

    return changed;
  }

  int digAllUnFlaggedNeighbours(int index) {
    int count = 0;
    final neighbours = getNeighbourIndexList(index);
    for (final cellIndex in neighbours) {
      final cell = board.cells[cellIndex];
      if (!cell.isDown() && !cell.isFlagged) {
        cell.digCell();
        count++;
      }
    }
    return count;
  }

  int digAllNeighbours(int index) {
    int count = 0;
    final neighbours = getNeighbourIndexList(index);
    for (final cellIndex in neighbours) {
      final cell = board.cells[cellIndex];
      if (!cell.isDown()) {
        cell.digCell();
        count++;
      }
    }
    return count;
  }

  int countUnDugNeighbours(int index) {
    final neighbours = getNeighbourIndexList(index);
    int count = 0;
    for (final cellIndex in neighbours) {
      final cell = board.cells[cellIndex];
      if (!cell.isDown()) count++;
    }
    return count;
  }

  int countFlaggedNeighbours(int index) {
    final neighbours = getNeighbourIndexList(index);
    int count = 0;
    for (final cellIndex in neighbours) {
      final cell = board.cells[cellIndex];
      if (cell.isFlagged) count++;
    }
    return count;
  }

  List<int> getNeighbourIndexList(int cellIndex) {
    int col = getCol(cellIndex);
    int row = getRow(cellIndex);
    var list = <int>[];
    for (int rowToCheck = row - 1; rowToCheck <= row + 1; rowToCheck++) {
      for (int colToCheck = col - 1; colToCheck <= col + 1; colToCheck++) {
        if (rowToCheck != row || colToCheck != col) {
          if (rowToCheck >= 0 &&
              rowToCheck < board.boardWidth &&
              colToCheck >= 0 &&
              colToCheck < board.boardWidth) {
            list.add(getCellIndexFromRowCol(rowToCheck, colToCheck));
          }
        }
      }
    }
    return list;
  }

  int getCol(int index) {
    return index % board.boardWidth;
  }

  int getRow(int index) {
    return index ~/ board.boardWidth;
  }

  int getCellIndexFromRowCol(int row, int col) {
    return row * board.boardWidth + col;
  }

  void printBoard() {
    logger.d(board.getBoardString());
    logger.d('===============');
  }

  bool isSolved() {
    for (final cell in board.cells) {
      if (!cell.isFlagged && !cell.isDown()) return false;
    }
    return true;
  }
}
