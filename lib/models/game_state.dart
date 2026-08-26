import 'package:minesweeper/models/game_settings.dart';

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

  GameState copy() {
    Board newBoard = board.copy();
    return GameState(
        board: newBoard,
        isFlagging: isFlagging,
        isGameOver: isGameOver,
        isWon: isWon,
        settings: settings);
  }

  Map<String, dynamic> toJson() {
    return {
      'board': board.toJson(),
      'isFlagging': isFlagging,
      'isGameOver': isGameOver,
      'isWon': isWon,
      'settings': settings.toJson(),
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    final board = Board.fromJson(json['board']);
    return GameState(
        board: board,
        isFlagging: json['isFlagging'],
        isGameOver: json['isGameOver'],
        isWon: json['isWon'],
        settings: GameSettings.fromJson(json['settings']));
  }
}
