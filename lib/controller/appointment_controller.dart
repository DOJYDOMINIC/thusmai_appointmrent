
import 'package:flutter/cupertino.dart';

class AppointmentProvider extends ChangeNotifier {

  int _selectedIndex = 0;
  String _phone = "";
  int get selectedIndex => _selectedIndex;
//
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  String get phone => _phone;
//
  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

}