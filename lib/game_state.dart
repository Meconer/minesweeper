import 'board.dart';

class GameState {
  Board board;
  bool isFlagging;
  bool isGameOver;
  bool isWon;

  GameState({
    required this.board,
    required this.isFlagging,
    required this.isGameOver,
    required this.isWon,
  });

  GameState copyWith(
      {Board? board,
      bool? isFlagging,
      bool? isGameOver,
      bool? isWon,
      bool? hasPlacedMines}) {
    return GameState(
      board: board ?? this.board,
      isFlagging: isFlagging ?? this.isFlagging,
      isGameOver: isGameOver ?? this.isGameOver,
      isWon: isWon ?? this.isWon,
    );
  }
}
