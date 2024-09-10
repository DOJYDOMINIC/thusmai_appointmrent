

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';

class notificationController extends ChangeNotifier{

  // List<ListElement> _appointments = [];
  // List<ListElement> get appointments => _appointments;

  Future<void> fetchAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      var response = await http.get(
        Uri.parse("$userBaseUrl/"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> dataList = jsonDecode(response.body);
        var data = dataList["appointments"];
        // if (data is List) {
        //   _appointments = data.map((json) => ListElement.fromJson(json)).toList();
        // } else if (data is Map<String, dynamic>) {
        //   _appointments = [ListElement.fromJson(data)];
        // } else {
        //   throw Exception('Invalid data format');
        // }
      } else {
        print('Failed to load appointments: ${response.reasonPhrase}');
        // _appointments = [];
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      // _appointments = [];
    }
    notifyListeners();
  }


}