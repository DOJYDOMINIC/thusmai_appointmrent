import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

const int alarmId = 0;

class TimerProvider extends ChangeNotifier {
  static const int _initialSeconds = 1 * 60;
  int _currentSeconds = _initialSeconds;
  Timer? _timer;
  bool _isRunning = false;
  DateTime? _startDateTime;
  
  AudioPlayer _audioPlayer = AudioPlayer();

  TimerProvider() {
    _loadTimerState();
    Workmanager().initialize(callbackDispatcher);
  }

  int get initialSeconds => _initialSeconds;

  int get currentSeconds => _currentSeconds;

  bool get isRunning => _isRunning;

  DateTime? get startDateTime => _startDateTime;

  String get timerText {
    int minutes = (_currentSeconds ~/ 60);
    int seconds = _currentSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _loadTimerState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentSeconds = prefs.getInt('currentSeconds') ?? _initialSeconds;
    notifyListeners();
  }

  Future<void> _saveCurrentSeconds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentSeconds', _currentSeconds);
  }


  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    _cancelBackgroundTask();
    notifyListeners();
  }
  
  
  void resumeTimer() async {
    WakelockPlus.enable();
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        await _saveCurrentSeconds();
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        notifyListeners();
        // await _audioPlayer.setSource(AssetSource('audio/thasmainamah.mp3'));
        await _audioPlayer.play(AssetSource('audio/thasmainamah.mp3'));
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      }
    });
    _scheduleBackgroundTask();
    notifyListeners();
  }

  void resetTimer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isRunning = false;
    _audioPlayer.stop();
    _timer?.cancel();
    _currentSeconds = _initialSeconds;
    _startDateTime = null;
    _cancelBackgroundTask();
    // _saveCurrentSeconds();
    prefs.remove("currentSeconds");
    WakelockPlus.disable();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.stop();
    _cancelBackgroundTask();
    super.dispose();
  }

  void _scheduleBackgroundTask() {
    Workmanager().registerPeriodicTask(
      '1',
      'timerTask',
      frequency: const Duration(minutes: 1),
      inputData: <String, dynamic>{
        'currentSeconds': _currentSeconds,
      },
    );
  }

  void _cancelBackgroundTask() {
    Workmanager().cancelByUniqueName('timerTask');
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    int currentSeconds = inputData!['currentSeconds'] ?? TimerProvider._initialSeconds;
    if (currentSeconds > 0) {
      currentSeconds--;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentSeconds', currentSeconds);
    }
    return Future.value(true);
  });
}




