// import 'dart:async';
//
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/cupertino.dart';
// import '../pages/meditation/meditationtimer.dart';
//
// class TimerProvider extends ChangeNotifier {
//   int mint = 1;
//   static const int _initialSeconds = 1 * 60;
//   int _currentSeconds = _initialSeconds;
//   Timer? _timer;
//   bool _isRunning = false;
//   DateTime? _startDateTime;
//   AudioPlayer _audioPlayer = AudioPlayer();
//
//   int get initialSeconds => _initialSeconds;
//
//   int get currentSeconds => _currentSeconds;
//
//   bool get isRunning => _isRunning;
//
//   DateTime? get startDateTime => _startDateTime;
//
//   String get timerText {
//     int minutes = (_currentSeconds ~/ 60);
//     int seconds = _currentSeconds % 60;
//     return '$minutes:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   void startTimer() {
//     _scheduleAlarm();
//     _isRunning = true;
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_currentSeconds > 0) {
//         _currentSeconds--;
//         notifyListeners();
//       } else {
//         _timer?.cancel();
//         _isRunning = false;
//         _scheduleAlarm();
//         notifyListeners();
//       }
//     });
//     notifyListeners();
//   }
//
//   void _scheduleAlarm() async {
//     await AndroidAlarmManager.oneShot(
//       Duration(seconds: _currentSeconds),
//       alarmId,
//       startAlarmCallback,
//       exact: true,
//       wakeup: true,
//     );
//   }
//
//   void _stopScheduleAlarm() async {
//     await _audioPlayer.stop();
//   }
//
//   void pauseTimer() {
//     _stopScheduleAlarm();
//     _timer?.cancel();
//     _isRunning = false;
//     notifyListeners();
//   }
//
//   void resumeTimer() {
//     if (_currentSeconds > (mint * 60) - 1) {
//       _startDateTime = DateTime.now();
//       print(_startDateTime.toString());
//     }
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (_currentSeconds > 0) {
//         _currentSeconds--;
//         notifyListeners();
//       } else {
//         _timer?.cancel();
//         _isRunning = false;
//         notifyListeners();
//       }
//     });
//     notifyListeners();
//   }
//
//   void resetTimer() {
//     _stopScheduleAlarm();
//     _timer?.cancel();
//     _currentSeconds = _initialSeconds;
//     _isRunning = false;
//     _startDateTime = null;
//     notifyListeners();
//   }
// }
