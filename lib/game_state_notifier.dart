import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:minesweeper/main.dart';

import 'board.dart';
import 'game_state.dart';

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(super.state);
  Logger logger = Logger(level: Level.error);

  // User tapped a cell
  void tapCell(int index) {
    logger.d('tapCell called $index');
    var board = state.board.copy();
    if (!state.hasPlacedMines) {
      List<int> mines =
          board.getRandomMineList(boardWidth * boardWidth, noOfMines, index);
      board = board.copyWith(mines: mines);
      board.setHiddenMines();
      board.setNeighbourCounts();
    }
    if (state.isFlagging) {
      board.flagCell(index);
      bool won = board.hasWon();
      final newState =
          state.copyWith(board: board, isWon: won, hasPlacedMines: true);
      state = newState;
    } else {
      board.digCell(index);
      if (board.mines.contains(index)) {
        // Mine! Game is over
        board.gameOver();
        state = state.copyWith(board: board);
      } else {
        bool won = board.hasWon();
        final newState =
            state.copyWith(board: board, isWon: won, hasPlacedMines: true);
        state = newState;
      }
    }
  }

  void longPressCell(int index) {
    logger.d('longPressCell called $index');
    final board = state.board.copy();

    board.flagCell(index);
    bool won = board.hasWon();
    final newState = state.copyWith(board: board, isWon: won);
    state = newState;
  }

  void toggleDigOrFlag() {
    state = state.copyWith(isFlagging: !(state.isFlagging));
  }

  void gameOver() {
    logger.i('Game over!');
    String line = '';
    for (int mine in state.board.mines) {
      line += '$mine ';
    }
    logger.i(line);

    state = GameState(
        board: state.board,
        isFlagging: false,
        isGameOver: true,
        isWon: false,
        hasPlacedMines: false);
  }

  void initGameBoard({required int boardWidth, required int noOfMines}) {
    state = GameState(
      board: Board.init(boardWidth, noOfMines),
      isFlagging: false,
      isGameOver: false,
      isWon: false,
      hasPlacedMines: false,
    );
  }
}

final gameStateNotifierProvider =
    StateNotifierProvider<GameStateNotifier, GameState>(
        (ref) => GameStateNotifier(
              GameState(
                board: Board.init(8, 10),
                isFlagging: false,
                isGameOver: false,
                isWon: false,
                hasPlacedMines: false,
              ),
            ));
