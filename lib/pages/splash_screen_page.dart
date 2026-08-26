import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minesweeper/controllers/app_controller.dart';
import 'package:minesweeper/pages/game_page.dart';

class SplashScreenPage extends ConsumerWidget {
  static const routeName = '/';

  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appController = ref.read(appControllerProvider);
    return FutureBuilder(
        future: appController.initApp(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GamePage();
          } else {
            return Image.asset('assets/images/bomb_01.png');
          }
        }));
  }
}
