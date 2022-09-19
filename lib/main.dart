import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'game_button.dart';
import 'game_grid.dart';
import 'game_state_notifier.dart';
import 'settings_page.dart';

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
      routes: {SettingsPage.routeName: ((context) => SettingsPage())},
      home: Builder(builder: (context) {
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
                            gameStateNotifier.initGameBoard(
                                gameSettings: gameState.settings);
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
            ));
      }),
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
