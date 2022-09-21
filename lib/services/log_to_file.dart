import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LogToFile extends LogOutput {
  @override
  Future<void> output(OutputEvent event) async {
    String path = await getLogFilePath();
    debugPrint(path);
    File logFile = File(path);
    logFile.open(mode: FileMode.append);
    final writer = logFile.openWrite();
    writer.writeln(DateTime.now().toIso8601String());
    for (final line in event.lines) {
      writer.writeln(line);
    }
    await writer.flush();
    await writer.done;
  }

  Future<String> getLogFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/logFile.log';
    return path;
  }

  Future<String> getLogFileContents() async {
    final path = await getLogFilePath();
    File logFile = File(path);
    logFile.open(mode: FileMode.read);
    final content = await logFile.readAsString();
    return content;
  }
}
