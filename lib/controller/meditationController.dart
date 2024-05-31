import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      _updateCounts();
      notifyListeners();
    }
  }

  void meditatedDatesSubtract() {
    if (_meditatedDatesIndex > 1) {
      _meditatedDatesIndex--;
      meditatedDates(_meditatedDatesIndex.toString());
      _updateCounts();
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
        _updateCounts();

      } else {
        print('MeditationDates Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error meditationDates: $e');
    }
    notifyListeners();
  }

  Future<void> meditationNote( BuildContext context,String note, String type, String messageTime,String? messageDate) async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ),
        );
        print("sucess");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ),
        );
        print('Failed to send time: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error to send time:: $e');
    }
    notifyListeners();
  }

  Future<void> meditationTimeDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    var time = DateTime.now();
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/meditation-time?UId=1&time=${time.hour}:${time.minute}:${time.minute}"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        final dataList = jsonDecode(response.body);
      } else {
        print('Failed to load appointments: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
    notifyListeners();
  }


  int greenCount = 0;
  int redCount = 0;



  void _updateCounts() {
    // Reset the counters
    greenCount = 0;
    redCount = 0;

    if (medDates.isEmpty) return;

    // Calculate the minimum date from the data
    DateTime minDate = medDates.map((item) => DateTime.parse(item.medStarttime.toString())).reduce((value, element) => value.isBefore(element) ? value : element);

    // Calculate the number of days to display in the calendar
    DateTime startDate = minDate.subtract(Duration(days: 1));

    // Update the counters based on the data
    for (int index = 0; index < medDates.length; index++) {
      DateTime currentDate = startDate.add(Duration(days: index));
      bool isGreen = medDates.any((item) {
        if (item.medStarttime != null) {
          DateTime medDate = DateTime.parse(item.medStarttime.toString());
          return medDate.day == currentDate.day && medDate.month == currentDate.month;
        }
        return false;
      });

      if (isGreen) {
        greenCount++;
      } else {
        redCount++;
      }
    }
  }

  double _progress = 0.0;
  double _maxDuration = 0.0;

  double get progress => _progress;
  double get maxDuration => _maxDuration;

  void setProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void setMaxDuration(double value) {
    _maxDuration = value;
    notifyListeners();
  }
}



