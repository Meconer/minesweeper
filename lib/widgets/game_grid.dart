import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../controllers/game_controller.dart';
import 'grid_button.dart';

class GameGrid extends ConsumerWidget {
  GameGrid({Key? key}) : super(key: key);
  final logger = Logger(level: Level.error);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gameState.board.boardWidth * gameState.board.boardWidth,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gameState.board.boardWidth),
          itemBuilder: (context, index) {
            return GridButton(index);
          }),
    );
  }
}
