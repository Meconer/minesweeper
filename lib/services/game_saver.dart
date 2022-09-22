import 'package:minesweeper/models/board.dart';
import 'package:minesweeper/models/game_settings.dart';

import '../models/game_state.dart';

class GameSaver {
  void saveGame(GameState gameState) {}

  GameState restoreGame() {
    return GameState(
        board: Board.init(GameSettings.easy()),
        isFlagging: false,
        isGameOver: false,
        isWon: false,
        settings: GameSettings.easy());
  }
}
