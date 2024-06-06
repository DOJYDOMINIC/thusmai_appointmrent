import 'package:flutter/material.dart';
import 'dart:async';

class TimeObserver with ChangeNotifier {
  final String fromTime;
  final String toTime;
  late Timer _timer;

  TimeObserver({required this.fromTime, required this.toTime}) {
    _timer = Timer.periodic(Duration(seconds: 1), _checkTime);
  }

  void _checkTime(Timer timer) {
    final now = TimeOfDay.now();
    final nowString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00";

    if (nowString == fromTime || nowString == toTime) {
      onTimeMatch(nowString);
    }
  }

  void onTimeMatch(String matchedTime) {
    // Define the action to be taken when the time matches
    print("Time matched: $matchedTime");
    // Notify listeners if needed
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
