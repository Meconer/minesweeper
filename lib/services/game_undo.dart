import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:minesweeper/models/board.dart';
import 'package:minesweeper/models/game_settings.dart';

import '../models/game_state.dart';

class GameUndo {
  GameState? undoState;
  final logger = Logger(level: Level.debug);

  storeState(GameState gameState) {
    undoState = gameState.copy();
    logger.d('Storing state');
  }

  GameState restoreState() {
    logger.d('Restoring state');
    if (undoState != null) return undoState!;

    return GameState(
      board: Board.init(GameSettings.easy()),
      isFlagging: false,
      isGameOver: false,
      isWon: false,
      settings: GameSettings.easy(),
    );
  }
}

final undoProvider = Provider((ref) => GameUndo());
