import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/controllers/game_controller.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/services/stored_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppController {
  final GameController gameController;
  AppController(this.gameController);
  late String versionInfo;
  late String appName;

  Future<void> initApp() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    versionInfo =
        'ver: ${packageInfo.version} build: ${packageInfo.buildNumber}';
    GameSettings settings = await StoredSettings().loadSettings();
    gameController.changeSettings(settings);
  }
}

final appControllerProvider = Provider<AppController>(
    (ref) => AppController(ref.read(gameStateProvider.notifier)));
