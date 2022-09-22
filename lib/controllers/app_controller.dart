import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/controllers/game_controller.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:minesweeper/services/stored_settings.dart';

class AppController {
  final GameController gameController;
  AppController(this.gameController);

  Future<void> initApp() async {
    GameSettings settings = await StoredSettings().loadSettings();
    await Future.delayed(const Duration(milliseconds: 100));
    gameController.changeSettings(settings);
  }
}

final appControllerProvider = Provider<AppController>(
    (ref) => AppController(ref.read(gameStateProvider.notifier)));
