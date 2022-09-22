import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:minesweeper/controllers/game_controller.dart';
import 'package:minesweeper/services/log_to_file.dart';
import 'package:minesweeper/services/my_log_printer.dart';

import '../widgets/game_button.dart';
import '../widgets/game_grid.dart';
import '../models/game_state.dart';
import 'settings_page.dart';

class GamePage extends ConsumerWidget {
  static const String routeName = '/gamePage';
  final logger = Logger(
    level: Level.debug,
    output: LogToFile(),
    printer: MyLogPrinter(),
  );

  GamePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameController = ref.watch(gameStateProvider.notifier);
    final GameState gameState = ref.watch(gameStateProvider);
    logger.d('Rebuild');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        backgroundColor: Colors.grey[500],
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: (() {
              Navigator.pushNamed(context, SettingsPage.routeName);
            }),
            icon: const Icon(Icons.menu_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[300],
              child: GameGrid(),
            ),
          ),
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            alignment: Alignment.center,
            child: const WinWidget(),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GameButton(
                    icon: Icons.refresh,
                    callback: () {
                      gameController.initGameBoard(
                          gameSettings: gameState.settings);
                    },
                  ),
                  GameButton(
                      icon: gameState.isFlagging
                          ? Icons.flag_rounded
                          : Icons.arrow_downward_rounded,
                      callback: () {
                        gameController.toggleDigOrFlag();
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WinWidget extends ConsumerWidget {
  const WinWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    if (gameState.isWon) {
      return const Text(
        'WIN!',
        style: TextStyle(
          color: Colors.green,
          fontSize: 36,
        ),
      );
    } else if (gameState.isGameOver) {
      return const Text(
        'BOOM!',
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 36),
      );
    } else {
      return const Text(
        'Playing',
        style: TextStyle(
          backgroundColor: Colors.transparent,
          fontSize: 36,
        ),
      );
    }
  }
}
