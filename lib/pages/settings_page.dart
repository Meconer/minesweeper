import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/controllers/game_controller.dart';
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
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  final fileContent = await LogToFile().getLogFileContents();
                  showDialog(
                      context: context,
                      builder: ((context) =>
                          Scaffold(body: Center(child: Text(fileContent)))));
                },
                child: const Text('Logfil')),
          ],
        ),
      ),
    );
  }
}
