import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:minesweeper/game_settings.dart';

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
      vibrate();
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
      if (newState.isWon) vibrate();
      state = newState;
    }
  }

  void longPressCell(int index) {
    logger.d('longPressCell called $index');
    final board = state.board.copy();

    board.flagCell(index);
    bool won = board.hasWon();
    if (won) vibrate();
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
      settings: GameSettings.easy(),
    );
  }

  void initGameBoard({required GameSettings gameSettings}) {
    state = GameState(
      board: Board.init(gameSettings),
      isFlagging: false,
      isGameOver: false,
      isWon: false,
      settings: gameSettings,
    );
  }

  Future<void> vibrate() async {
    HapticFeedback.vibrate();
    await Future.delayed(const Duration(milliseconds: 300));
    HapticFeedback.vibrate();
    await Future.delayed(const Duration(milliseconds: 300));
    HapticFeedback.vibrate();
  }

  void changeSettings(GameSettings? gameSettings) {
    logger.d(gameSettings!.settingName);
    state = state.copyWith(settings: gameSettings);
  }
}

final gameStateNotifierProvider =
    StateNotifierProvider<GameStateNotifier, GameState>(
        (ref) => GameStateNotifier(
              GameState(
                board: Board.init(GameSettings.easy()),
                isFlagging: false,
                isGameOver: false,
                isWon: false,
                settings: GameSettings.easy(),
              ),
            ));
