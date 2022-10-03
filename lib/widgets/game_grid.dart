import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../controllers/game_controller.dart';
import 'grid_button.dart';

class GameGrid extends ConsumerWidget {
  final double size;

  GameGrid(this.size, {Key? key}) : super(key: key);
  final logger = Logger(level: Level.error);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    final cellSize = (size - 48) / gameState.board.boardWidth;

    return InteractiveViewer(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: size - 48,
          height: size - 48,
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  gameState.board.boardWidth * gameState.board.boardWidth,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gameState.board.boardWidth,
                mainAxisExtent: cellSize,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return GridButton(index, cellSize);
              }),
        ),
      ),
    );
  }
}
