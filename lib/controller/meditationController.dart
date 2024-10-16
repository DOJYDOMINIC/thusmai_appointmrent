import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:thusmai_appointmrent/models/meditationtime_model.dart';
import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';
import '../constant/constant.dart';
import '../models/meditatiologmodel.dart';
import '../models/meditationfulltime.dart';
import '../tabs/messsagetab.dart';

class MeditationController extends ChangeNotifier {
  Future<void> meditationTime(
    String start,
    String end,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    try {
      var response = await http.post(
        Uri.parse("$userBaseUrl/meditation"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({
          "startdatetime": start, "stopdatetime": end,
          // "morning_meditation": morning, "evening_meditation": evening
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

  bool _buttonBlock = false;

  bool get buttonBlock => _buttonBlock;

  Future<void> buttonBlockRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    try {
      final response = await http.post(
        Uri.parse("$userBaseUrl/button-block"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({"date": dateTime}),
      );

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        _buttonBlock = decode['key'];
        print("200 : ${decode.toString()}");
        print("200 : ${_buttonBlock.toString()}");
        notifyListeners();
      } else if (response.statusCode == 404) {
        var decode = jsonDecode(response.body);
        _buttonBlock = decode['key'];
        print("404 : ${decode.toString()}");
        print("404 : ${_buttonBlock.toString()}");
        notifyListeners();
      } else {
        print('Failed to block button: ${response.statusCode}');
      }
    } catch (e) {
      print("buttonBlockRequest: $e");
    }
  }

  MeditationTimeDetails _meditationFullTime = MeditationTimeDetails();
  MeditationTimeDetails get meditationFullTime => _meditationFullTime;

  Future<void> meditationDetailsTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    try {
      var response = await http.get(
        Uri.parse("$userBaseUrl/meditationTimeDetails"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        _meditationFullTime =
            MeditationTimeDetails.fromJson(jsonData["meditationTimeDetails"]);
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
        Uri.parse("$userBaseUrl/meditation-date?page=$count"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response JSON
        var jsonData = jsonDecode(response.body);
        print('Parsed Data: $jsonData');
        _meditatedDatesTotalPage = jsonData["totalPages"];
        // Parse the JSON data into MeditationLodData object
        MeditationLodData meditationData = MeditationLodData.fromJson(jsonData);
        print('Meditation Data: $meditationData');
        // Store the parsed data into _medDates
        _medDates = meditationData.data ?? [];
        print('medDates: $_medDates');
        _updateCounts();
      } else {
        print('MeditationDates Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error meditationDates: $e');
    }
    notifyListeners();
  }

  bool? _clearNote;
  bool? get clearNote => _clearNote;

  Future<void> meditationNote(BuildContext context, String note, String type,
      String messageTime, String? messageDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    try {
      var response = await http.post(
        Uri.parse("$userBaseUrl/messages"),
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
        _clearNote = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
          ),
        );
      } else {
        _clearNote = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ),
        );
        // print('Failed to send time: ${response.reasonPhrase}');
      }
      notifyListeners();
    } catch (e) {
      _clearNote = false;
      // print('Error to send time:: $e');
    }
  }

  MeditationTime _meditationTime = MeditationTime();
  MeditationTime get meditationTimeData => _meditationTime;

  Future<void> meditationTimeDetails(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    // print(cookies);
    var time = DateTime.now();
    String formattedTime =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

    try {
      var response = await http.get(
        Uri.parse("$userBaseUrl/meditation-time?time=$formattedTime"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        final dataList = jsonDecode(response.body);
        _meditationTime = MeditationTime.fromJson(dataList);
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
    DateTime minDate = medDates
        .map((item) => DateTime.parse(item.medStarttime.toString()))
        .reduce((value, element) => value.isBefore(element) ? value : element);

    // Calculate the number of days to display in the calendar
    DateTime startDate = minDate.subtract(Duration(days: 1));

    // Update the counters based on the data
    for (int index = 0; index < medDates.length; index++) {
      DateTime currentDate = startDate.add(Duration(days: index));
      bool isGreen = medDates.any((item) {
        if (item.medStarttime != null) {
          DateTime medDate = DateTime.parse(item.medStarttime.toString());
          return medDate.day == currentDate.day &&
              medDate.month == currentDate.month;
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
