import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import 'message_controller.dart';


class MeditationController extends ChangeNotifier {
  Future<void> meditationTime(String start, String end) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/meditation"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({"startdatetime": start, "stopdatetime": end}),
      );
      if (response.statusCode == 200) {
        print("sucess");
      } else {
        print('Failed to send time: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error to send time:: $e');
    }
    notifyListeners();
  }

  Future<void> meditationNote( String note, String type, String messageTime,String? messageDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    try {
      var response = await http.post(
        Uri.parse("$baseUrl/messages"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({
          "message": note,
          "messageTime": messageTime,
          "isAdminMessage": false,
          "messagetype": type,
          "messageDate": messageDate,
        }),
      );
      if (response.statusCode == 200) {

        print("sucess");
      } else {
        print('Failed to send time: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error to send time:: $e');
    }
    notifyListeners();
  }
}
