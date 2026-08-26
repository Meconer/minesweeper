import 'package:flutter/material.dart';
import 'package:minesweeper/services/log_to_file.dart';

class LogFilePage extends StatelessWidget {
  const LogFilePage({super.key});
  static String routeName = '/logFilePage';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LogToFile().getLogFileContents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Logg'),
            ),
            body: SingleChildScrollView(child: Text(snapshot.data!)),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
