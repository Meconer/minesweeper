import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:minesweeper/pages/splash_screen_page.dart';

import 'pages/game_page.dart';
import 'pages/settings_page.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        SettingsPage.routeName: ((context) => SettingsPage()),
        GamePage.routeName: (context) => const GamePage(),
        SplashScreenPage.routeName: (context) => const SplashScreenPage(),
      },
      initialRoute: SplashScreenPage.routeName,
    );
  }
}
