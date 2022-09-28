import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:minesweeper/pages/splash_screen_page.dart';

import 'pages/game_page.dart';
import 'pages/log_file_page.dart';
import 'pages/settings_page.dart';

main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  MyApp({super.key});

  final logger = Logger(level: Level.error);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d(state.name);
    if (state == AppLifecycleState.resumed) {
      logger.d('Resuming game page');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        SettingsPage.routeName: ((context) => SettingsPage()),
        GamePage.routeName: (context) => GamePage(),
        SplashScreenPage.routeName: (context) => const SplashScreenPage(),
        LogFilePage.routeName: (context) => const LogFilePage(),
      },
      initialRoute: SplashScreenPage.routeName,
    );
  }
}
