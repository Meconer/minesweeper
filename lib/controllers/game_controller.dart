import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/services/game_timer.dart';
import 'package:minesweeper/services/game_undo.dart';
import 'package:minesweeper/services/stored_settings.dart';

import '../models/board.dart';
import '../models/game_state.dart';

class GameController extends StateNotifier<GameState> {
  late GameTimer gameTimerNotifier;
  late GameUndo undoHandler;

  GameController(super.state);
  Logger logger = Logger(level: Level.error);

  // User tapped a cell
  void tapCell(int index) {
    logger.d('tapCell called $index');
    undoHandler.storeState(state);

    var board = state.board.copy();
    if (!board.havePlacedMines()) gameTimerNotifier.startTimer();
    final dugUpAMine = board.tapCell(index, state.isFlagging);
    if (dugUpAMine) {
      vibrate();
      board.gameOver();
      gameTimerNotifier.stopTimer();
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
      if (newState.isWon) {
        gameTimerNotifier.stopTimer();
        vibrate();
      }
      state = newState;
    }
  }

  void longPressCell(int index) {
    logger.d('longPressCell called $index');
    undoHandler.storeState(state);
    final board = state.board.copy();

    board.flagCell(index);
    bool won = board.hasWon();
    if (won) vibrate();
    final newState = state.copyWith(board: board, isWon: won);
    state = newState;
  }

  void toggleDigOrFlag() {
    final newFlagging = !state.isFlagging;
    state = state.copyWith(isFlagging: newFlagging);
  }

  void gameOver() {
    logger.i('Game over!');
    String line = '';
    for (int mine in state.board.mines) {
      line += '$mine ';
    }
    logger.i(line);

    undoHandler.storeState(state);
    gameTimerNotifier.stopTimer();

    state = GameState(
      board: state.board,
      isFlagging: false,
      isGameOver: true,
      isWon: false,
      settings: GameSettings.easy(),
    );
  }

  void initGameBoard({required GameSettings gameSettings}) {
    undoHandler.reset();
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

  Future<void> changeSettings(GameSettings? gameSettings) async {
    logger.d(gameSettings!.settingName);
    await StoredSettings().saveSettings(gameSettings);
    undoHandler.storeState(state);

    var board = state.board;
    if (!board.havePlacedMines()) {
      board = Board.init(gameSettings);
    }
    state = state.copyWith(board: board, settings: gameSettings);
  }

  GameSettings getSettings() {
    return state.settings;
  }

  isFlagging() {
    return state.isFlagging;
  }

  void loadState(GameState restoredState) {
    if (!restoredState.isGameOver &&
        !restoredState.isWon &&
        restoredState.board.havePlacedMines()) {
      gameTimerNotifier.startTimer();
    }
    state = restoredState;
  }

  getCell(int index) {
    return state.board.cells[index];
  }

  void undo() {
    final undoState = undoHandler.restoreState();
    if (undoState != null) {
      if (!undoState.isGameOver && !undoState.isWon) {
        gameTimerNotifier.startTimer();
      }
      state = undoState;
    }
  }
}

final gameStateProvider =
    StateNotifierProvider<GameController, GameState>((ref) {
  final gameController = GameController(
    GameState(
      board: Board.init(GameSettings.easy()),
      isFlagging: false,
      isGameOver: false,
      isWon: false,
      settings: GameSettings.easy(),
    ),
  );
  gameController.undoHandler = ref.read(undoProvider);
  gameController.gameTimerNotifier = ref.read(gameTimeProvider.notifier);
  return gameController;
});
