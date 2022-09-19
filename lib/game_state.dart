import 'package:minesweeper/game_settings.dart';

import 'board.dart';

class GameState {
  Board board;
  bool isFlagging;
  bool isGameOver;
  bool isWon;
  GameSettings settings;

  GameState({
    required this.board,
    required this.isFlagging,
    required this.isGameOver,
    required this.isWon,
    required this.settings,
  });

  GameState copyWith({
    Board? board,
    bool? isFlagging,
    bool? isGameOver,
    bool? isWon,
    bool? hasPlacedMines,
    GameSettings? settings,
  }) {
    return GameState(
      board: board ?? this.board,
      isFlagging: isFlagging ?? this.isFlagging,
      isGameOver: isGameOver ?? this.isGameOver,
      isWon: isWon ?? this.isWon,
      settings: settings ?? this.settings,
    );
  }
}
