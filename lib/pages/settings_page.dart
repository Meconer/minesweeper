import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/controllers/game_controller.dart';
import 'package:minesweeper/models/game_state.dart';
import 'package:minesweeper/pages/log_file_page.dart';
import 'package:minesweeper/services/game_saver.dart';
import 'package:minesweeper/services/log_to_file.dart';

class SettingsPage extends ConsumerWidget {
  static const routeName = '/settings';

  final dropDownMenuItems = GameSettings.standardSettings
      .map((setting) => DropdownMenuItem<String>(
            value: setting.settingName,
            child: Text(setting.settingName),
          ))
      .toList();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var gameState = ref.watch(gameStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton<String>(
              items: dropDownMenuItems,
              value: gameState.settings.settingName,
              onChanged: (value) {
                gameState.settings = GameSettings.byName(value)!;
                ref
                    .read(gameStateProvider.notifier)
                    .changeSettings(gameState.settings);
              },
            ),
            if (kDebugMode)
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed(LogFilePage.routeName);
                },
                child: const Text('Logfil'),
              ),
            if (kDebugMode)
              ElevatedButton(
                onPressed: () async {
                  await LogToFile().clearLogFile();
                },
                child: const Text('Rensa logfil'),
              ),
            ElevatedButton(
              onPressed: () => saveGame(gameState),
              child: const Text('Save game'),
            ),
            ElevatedButton(
              onPressed: () =>
                  restoreGame(ref.read(gameStateProvider.notifier)),
              child: const Text('Restore last saved game'),
            ),
          ],
        ),
      ),
    );
  }

  void saveGame(GameState state) {
    GameSaver().saveGame(state);
  }

  Future<void> restoreGame(GameController controller) async {
    final restoredState = GameSaver().restoreGame();
    controller.loadState(await restoredState);
  }
}
