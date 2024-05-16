import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../models/meditatiologmodel.dart';


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


  int get meditatedDatesTotalPage => _meditatedDatesTotalPage;
   int _meditatedDatesTotalPage = 1;
  int _meditatedDatesIndex = 1;
  int get meditatedDatesIndex => _meditatedDatesIndex;

  void meditatedDatesAdd(int totalPage) {
    if (_meditatedDatesIndex <= totalPage) {
      _meditatedDatesIndex++;
      meditatedDates(_meditatedDatesIndex.toString());
      notifyListeners();
    }
  }

  void meditatedDatesSubtract() {
    if (_meditatedDatesIndex > 1) {
      _meditatedDatesIndex--;
      meditatedDates(_meditatedDatesIndex.toString());
      notifyListeners();
    }
  }
  List<Datum> _medDates = [];
  List<Datum> get medDates => _medDates;


  Future<void> meditatedDates(String count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/meditation-date?page=$count"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        var jsonData = jsonDecode(response.body);
        _meditatedDatesTotalPage = jsonData["totalPages"];
        // Parse the JSON data into MeditationLodData object
        MeditationLodData meditationData = MeditationLodData.fromJson(jsonData);

        // Store the parsed data into _medDates
        _medDates = meditationData.data ?? [];

        print("New Data: ${_medDates.length.toString()}");
      } else {
        print('MeditationDates Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error meditationDates: $e');
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


