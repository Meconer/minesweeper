import 'dart:convert';
import 'dart:io';

import 'package:minesweeper/models/board.dart';
import 'package:minesweeper/models/game_settings.dart';
import 'package:path_provider/path_provider.dart';

import '../models/game_state.dart';

class GameSaver {
  Future<bool> saveGame(GameState gameState) async {
    final jsonInput = gameState.toJson();
    final json = jsonEncode(jsonInput);
    File saveFile = File(await getSaveFilePath());
    try {
      final writer = saveFile.openWrite(mode: FileMode.write);
      writer.write(json);
      await writer.flush();
      await writer.done;
      return true;
    } catch (e) {
      // Something went wrong
      return false;
    }
  }

  Future<GameState> restoreGame() async {
    try {
      final content = await File(await getSaveFilePath()).readAsString();
      final restoredState = GameState.fromJson(jsonDecode(content));
      return restoredState;
    } catch (e) {
      return GameState(
        board: Board.init(GameSettings.easy()),
        isFlagging: false,
        isGameOver: false,
        isWon: false,
        settings: GameSettings.easy(),
      );
    }
  }

  Future<String> getSaveFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/saveFile.json';
    return path;
  }
}
