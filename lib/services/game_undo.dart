import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../models/game_state.dart';

class GameUndo {
  List<GameState> undoStateList = [];
  final logger = Logger(level: Level.debug);

  storeState(GameState gameState) {
    undoStateList.add(gameState.copy());
    logger.d('Storing state');
  }

  GameState? restoreState() {
    logger.d('Restoring state');
    if (undoStateList.isNotEmpty) {
      return undoStateList.removeLast();
    }
    return null;
  }

  void reset() {
    undoStateList.clear();
  }
}

final undoProvider = Provider((ref) => GameUndo());
