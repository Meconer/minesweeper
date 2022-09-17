import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'board.dart';
import 'game_state.dart';

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(super.state);
  Logger logger = Logger(level: Level.error);

  // User tapped a cell
  void tapCell(int index) {
    logger.d('tapCell called $index');
    var board = state.board.copy();
    final dugUpAMine = board.tapCell(index, state.isFlagging);
    if (dugUpAMine) {
      board.gameOver();
      final newState = state.copyWith(
        board: board,
        isFlagging: false,
        isGameOver: true,
        isWon: false,
      );
      state = newState;
    } else {
      final newState = state.copyWith(
        board: board,
        isFlagging: state.isFlagging,
        isGameOver: false,
        isWon: board.hasWon(),
      );
      state = newState;
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
    );
  }

  void initGameBoard({required int boardWidth, required int noOfMines}) {
    state = GameState(
      board: Board.init(boardWidth, noOfMines),
      isFlagging: false,
      isGameOver: false,
      isWon: false,
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
              ),
            ));
