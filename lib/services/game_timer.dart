import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameTimer extends StateNotifier<int> {
  GameTimer(super.state);

  Timer? timer;
  int timerCount = 0;

  void startTimer() {
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        timerCount++;
        state = timerCount;
      },
    );
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    timerCount = 0;
    timer?.cancel();
  }
}

final gameTimeProvider =
    StateNotifierProvider<GameTimer, int>(((ref) => GameTimer(0)));
