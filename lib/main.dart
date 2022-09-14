import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'game_button.dart';
import 'game_grid.dart';
import 'game_state_notifier.dart';

const int boardWidth = 8;
const int noOfMines = 10;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameStateNotifier = ref.watch(gameStateNotifierProvider.notifier);
    final gameState = ref.watch(gameStateNotifierProvider);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Minesweeper'),
            backgroundColor: Colors.grey[500],
            foregroundColor: Colors.black87,
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
              const WinWidget(),
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GameButton(
                        icon: Icons.refresh,
                        callback: () {
                          gameStateNotifier.initGameBoard(
                              boardWidth: boardWidth, noOfMines: noOfMines);
                        },
                      ),
                      GameButton(
                          icon: gameState.isFlagging
                              ? Icons.flag_rounded
                              : Icons.arrow_downward_rounded,
                          callback: () {
                            gameStateNotifier.toggleDigOrFlag();
                          }),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class WinWidget extends ConsumerWidget {
  const WinWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateNotifierProvider);
    if (gameState.isWon) {
      return const Text(
        'WIN!',
        style: TextStyle(backgroundColor: Colors.transparent, fontSize: 36),
      );
    } else {
      return const Text(
        'Playing',
        style: TextStyle(backgroundColor: Colors.transparent, fontSize: 36),
      );
    }
  }
}
