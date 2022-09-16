import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'game_cell_content.dart';
import 'game_state_notifier.dart';

class GridButton extends ConsumerWidget {
  final int index;
  final Logger logger = Logger(level: Level.error);

  GridButton(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateNotifierProvider);
    final gameStateNotifier = ref.watch(gameStateNotifierProvider.notifier);

    final cellContent = gameState.board.cells[index].gameCellContent;

    return GestureDetector(
      onTap: () {
        logger.d('Cell $index tapped');
        gameStateNotifier.tapCell(index);
      },
      onLongPress: (() {
        logger.d('Cell $index longpresed');
        gameStateNotifier.longPressCell(index);
      }),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: getDecoration(cellContent),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: getCellArt(cellContent, index),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration getDecoration(GameCellContent cellContent) {
    const blur = 2.0;
    const ofsDist = 2.0;
    const offset = Offset(ofsDist, ofsDist);
    return cellContent.isDown()
        ? BoxDecoration(
            color: Colors.grey[300],
          )
        : BoxDecoration(color: Colors.grey[300], boxShadow: [
            BoxShadow(blurRadius: blur, offset: -offset, color: Colors.white),
            const BoxShadow(
                blurRadius: blur, offset: offset, color: Colors.black38),
          ]);
  }

  Widget getCellArt(GameCellContent cellContent, int cellIndex) {
    switch (cellContent.gameCellType) {
      case GameCellType.hidden:
      case GameCellType.hiddenMine:
        return cellContent.isFlagged
            ? const Icon(
                Icons.flag_outlined,
                color: Colors.orange,
              )
            : const Text(' ');

      case GameCellType.empty:
        return const Text(' ');

      case GameCellType.explodedMine:
        return const Image(image: AssetImage('assets/images/bomb_03.png'));

      case GameCellType.mineNeighbour:
        return Text('${cellContent.noOfNeighbourMines}');
    }
  }
}