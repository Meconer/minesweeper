import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameTimer extends StateNotifier<int> with WidgetsBindingObserver {
  GameTimer(super.state) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        timer?.cancel();
        break;
      case AppLifecycleState.resumed:
        if (timerStarted) startTimer();
        break;
      default:
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  Timer? timer;
  int timerCount = 0;
  bool timerStarted = false;

  void startTimer() {
    if (!timerStarted) {
      timerStarted = true;
      timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
          timerCount++;
          state = timerCount;
        },
      );
    }
  }

  void stopTimer() {
    timerStarted = false;
    timer?.cancel();
  }

  void resetTimer() {
    timerCount = 0;
    state = timerCount;
    timerStarted = false;
    timer?.cancel();
  }
}

final gameTimeProvider =
    StateNotifierProvider<GameTimer, int>(((ref) => GameTimer(0)));
