import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/controllers/game_controller.dart';
import 'package:minesweeper/pages/log_file_page.dart';
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
    var gameSettings = ref.watch(gameStateProvider).settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton<String>(
              items: dropDownMenuItems,
              value: gameSettings.settingName,
              onChanged: (value) {
                gameSettings = GameSettings.byName(value)!;
                ref
                    .read(gameStateProvider.notifier)
                    .changeSettings(gameSettings);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed(LogFilePage.routeName);
              },
              child: const Text('Logfil'),
            ),
            ElevatedButton(
              onPressed: () async {
                await LogToFile().clearLogFile();
              },
              child: const Text('Rensa logfil'),
            ),
            ElevatedButton(
              onPressed: () => saveGame(),
              child: const Text('Save game'),
            ),
          ],
        ),
      ),
    );
  }

  saveGame() {}
}
