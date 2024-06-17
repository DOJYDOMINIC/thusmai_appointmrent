import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import '../pages/meditation/meditationtimer.dart';

class TimerProvider extends ChangeNotifier {
  int mint = 45;
  static const int _initialSeconds = 45 * 60;
  int _currentSeconds = _initialSeconds;
  Timer? _timer;
  bool _isRunning = false;
  DateTime? _startDateTime;
  AudioPlayer _audioPlayer = AudioPlayer();

  int get initialSeconds => _initialSeconds;

  int get currentSeconds => _currentSeconds;

  bool get isRunning => _isRunning;

  DateTime? get startDateTime => _startDateTime;

  String get timerText {
    int minutes = (_currentSeconds ~/ 60);
    int seconds = _currentSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    _scheduleAlarm();
    // _startDateTime = DateTime.now();
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        _scheduleAlarm();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void _scheduleAlarm() async {
    await AndroidAlarmManager.oneShot(
      Duration(seconds: _currentSeconds),
      alarmId,
      startAlarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  void _stopScheduleAlarm() async {
    await _audioPlayer.stop();
    await AndroidAlarmManager.oneShot(
      const Duration(microseconds: 0),
      alarmId,
      stopAlarmCallback,
      exact: true,
      wakeup: true,
    );
  }

  void pauseTimer() {
    _stopScheduleAlarm();
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resumeTimer() {
    if (_currentSeconds > (mint * 60) - 1) {
      _startDateTime = DateTime.now();
      print(_startDateTime.toString());
    }
    _scheduleAlarm();
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void resetTimer() {
    _stopScheduleAlarm();
    _timer?.cancel();
    _currentSeconds = _initialSeconds;
    _isRunning = false;
    _startDateTime = null;
    notifyListeners();
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("App is running in the background");
    } else if (state == AppLifecycleState.resumed) {
      print("App is running in the foreground");
    }
  }
}
