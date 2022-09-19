import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/game_settings.dart';
import 'package:minesweeper/game_state_notifier.dart';

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
    var gameSettings = ref.watch(gameStateNotifierProvider).settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: DropdownButton<String>(
          items: dropDownMenuItems,
          value: gameSettings.settingName,
          onChanged: (value) {
            gameSettings = GameSettings.byName(value)!;
            ref
                .read(gameStateNotifierProvider.notifier)
                .changeSettings(gameSettings);
          },
        ),
      ),
    );
  }
}
