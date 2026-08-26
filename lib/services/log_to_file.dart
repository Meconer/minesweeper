import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LogToFile extends LogOutput {
  @override
  Future<void> output(OutputEvent event) async {
    String path = await getLogFilePath();
    File logFile = File(path);
    final writer = logFile.openWrite(mode: FileMode.append);
    writer.writeln(DateTime.now().toIso8601String());
    for (final line in event.lines) {
      writer.writeln(line);
    }
    await writer.flush();
    await writer.close();
  }

  Future<String> getLogFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/logFile.log';
    return path;
  }

  Future<String> getLogFileContents() async {
    final path = await getLogFilePath();
    try {
      final content = await File(path).readAsString();
      return content;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> clearLogFile() async {
    final path = await getLogFilePath();
    File logFile = File(path);
    try {
      logFile.delete();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
