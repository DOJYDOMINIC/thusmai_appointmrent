import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonStateNotifier extends ChangeNotifier {
  bool _meditationDisable = false;
  bool get meditationDisable => _meditationDisable;

  static const String _prefsKey = 'meditationDisabled';
  static const String _prefsTimeKey = 'meditationDisabledTime';

  // ButtonStateNotifier() {
  //   _loadButtonState();
  // }

  void loadButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _meditationDisable = prefs.getBool(_prefsKey) ?? false;
    if (_meditationDisable) {
      final disableTime = prefs.getInt(_prefsTimeKey);
      if (disableTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - disableTime >= Duration(hours: 3).inMilliseconds) {
          _meditationDisable = false;
          await prefs.setBool(_prefsKey, false);
          await prefs.remove(_prefsTimeKey);
        }
      }
    }
    notifyListeners();
  }

  void disableButton() async {
    _meditationDisable = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, true);
    await prefs.setInt(_prefsTimeKey, DateTime.now().millisecondsSinceEpoch);

    Timer(Duration(hours: 3), () async {
      _meditationDisable = false;
      notifyListeners();
      await prefs.setBool(_prefsKey, false);
      await prefs.remove(_prefsTimeKey);
    });
  }
}
