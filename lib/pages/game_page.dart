import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/link.dart';

import '../constants.dart';
import '../controllers/app_controller.dart';
import '../services/game_timer.dart';
import '../controllers/game_controller.dart';
import '../models/game_settings.dart';
import '../widgets/game_button.dart';
import '../widgets/game_grid.dart';
import 'settings_page.dart';

class GamePage extends ConsumerWidget {
  static const String routeName = '/gamePage';
  final logger = Logger(
    level: Level.error,
  );

  GamePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(gameStateProvider);
    final gameController = ref.watch(gameStateProvider.notifier);
    final timerTick = ref.watch(gameTimeProvider);
    final appController = ref.watch(appControllerProvider);

    double time = timerTick / 10;

    logger.d('Rebuild');
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Minesweeper'),
        backgroundColor: Colors.grey[500],
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: (() {
              showAboutDialog(
                context: context,
                //applicationIcon: Image.asset('assets/images/bomb_C01.png')),
                applicationName: appController.appName,
                applicationVersion: appController.versionInfo,
                children: [
                  Link(
                    target: LinkTarget.blank,
                    uri: Uri.parse('https://matc.se/minesweeper/policy.html'),
                    builder: ((context, followLink) => ElevatedButton(
                        onPressed: followLink,
                        child: const Text('Privacy policy'))),
                  ),
                ],
              );
            }),
            icon: const Icon(Icons.help),
          ),
          if (kDebugMode)
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
            child: LayoutBuilder(builder: (context, constraints) {
              final size = min(constraints.maxHeight, constraints.maxWidth);
              return Container(
                color: bgColor,
                child: GameGrid(size),
              );
            }),
          ),
          Container(
            color: bgColor,
            width: double.infinity,
            alignment: Alignment.center,
            height: 50,
            child: const WinWidget(),
          ),
          Container(
            color: bgColor,
            child: Column(
              children: [
                DifficultySetting(controller: gameController),
                const SizedBox(
                  width: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SolvableSetting(controller: gameController),
                    const Text('Logically solvable boards'),
                  ],
                ),
                Text('$time'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            color: bgColor,
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              children: [
                GameButton(
                  icon: Icons.refresh,
                  callback: () {
                    final timerNotifier = ref.read(gameTimeProvider.notifier);
                    timerNotifier.resetTimer();
                    gameController.initGameBoard(
                        gameSettings: gameController.getSettings());
                  },
                ),
                GameButton(
                  icon: gameController.isFlagging()
                      ? MdiIcons.flag
                      : MdiIcons.shovel,
                  callback: () {
                    gameController.toggleDigOrFlag();
                  },
                ),
                // GameButton(
                //     icon: Icons.save_rounded,
                //     callback: () {
                //       GameSaver().saveGame(gameState);
                //     }),
                // GameButton(
                //   icon: Icons.restore_rounded,
                //   callback: () async {
                //     final restoredState = await GameSaver().restoreGame();
                //     gameController.loadState(restoredState);
                //   },
                // ),
                GameButton(
                  icon: Icons.undo_rounded,
                  callback: () {
                    gameController.undo();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DifficultySetting extends StatelessWidget {
  final GameController controller;

  DifficultySetting({super.key, required this.controller});
  final dropDownMenuItems = GameSettings.standardSettings
      .map((setting) => DropdownMenuItem<String>(
            value: setting.settingName,
            child: Text(setting.settingName),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        items: dropDownMenuItems,
        value: controller.getSettings().settingName,
        onChanged: (value) {
          final settings = GameSettings.byName(value)!;
          controller.changeSettings(settings);
        });
  }
}

class SolvableSetting extends StatelessWidget {
  final GameController controller;

  const SolvableSetting({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    GameSettings settings = controller.getSettings();
    return Checkbox(
      value: settings.generateSolvable,
      onChanged: (bool? checked) {
        settings.generateSolvable = checked!;
        controller.changeSettings(settings);
      },
    );
  }
}

class WinWidget extends ConsumerWidget {
  const WinWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final timerTick = ref.watch(gameTimeProvider);

    double time = timerTick / 10;

    if (gameState.isWon) {
      ref.read(gameTimeProvider.notifier).stopTimer();
      return Text(
        'WIN in $time s!',
        style: const TextStyle(
          color: Colors.green,
          fontSize: 36,
        ),
      );
    } else if (gameState.isGameOver) {
      ref.read(gameTimeProvider.notifier).stopTimer();
      return Text(
        'BOOM after $time s!',
        style: const TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 36),
      );
    } else {
      return const Text(
        'Playing',
        style: TextStyle(
          fontSize: 36,
        ),
      );
    }
  }
}
