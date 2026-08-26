import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/constants.dart';
import 'package:minesweeper/controllers/game_controller.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/services/stored_settings.dart';

class AppController {
  final GameController gameController;
  AppController(this.gameController);
  late String versionInfo;
  late String appName;

  Future<void> initApp() async {
    appName = appCName;
    versionInfo = 'ver: $appVersion build: $appBuildNo';
    GameSettings settings = await StoredSettings().loadSettings();
    gameController.changeSettings(settings);
  }
}

final appControllerProvider = Provider<AppController>(
    (ref) => AppController(ref.read(gameStateProvider.notifier)));
