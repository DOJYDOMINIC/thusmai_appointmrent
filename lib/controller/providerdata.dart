import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../models/appointment_model.dart';

class ProviderController extends ChangeNotifier {

  int _selectedIndex = 0;

  String _phone = "";
  String _messageTabHead = "Messages";
  String _cookies = "";


  int get selectedIndex => _selectedIndex;



  String get cookies => _cookies;

  set cookies(String value) {
    _cookies = value;
    notifyListeners();
  }


  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  String get messageTabHead => _messageTabHead;

  set messageTabHead(String value) {
    _messageTabHead = value;
    notifyListeners();
  }

  String getMessageTabHeadings(int index) {
    switch (index) {
      case 0:
        return "Private Heading";
      case 1:
        return "Guru Heading";
      case 2:
        return "Global Heading";
      default:
        return "";
    }
  }


  List<ListElement> _appointments = [];
  List<ListElement> get appointments => _appointments;

  Future<void> fetchAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/list-appointment"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataList = jsonDecode(response.body);
        var data = dataList["appointments"];
        if (data is List) {
          _appointments = data.map((json) => ListElement.fromJson(json)).toList();
        } else if (data is Map<String, dynamic>) {
          _appointments = [ListElement.fromJson(data)];
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        print('Failed to load appointments: ${response.reasonPhrase}');
        _appointments = [];
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      _appointments = [];
    }
    notifyListeners();
  }

  late Timer _timer;
  int _seconds = 20;

  int get seconds => _seconds;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
      } else {
        _seconds = 20;
        // Reset to 20 seconds
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
