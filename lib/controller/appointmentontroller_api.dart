import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../models/appointment_model.dart';
import '../pages/login_register_otp/login.dart';
import '../widgets/dialogbox.dart';

class AppointmentController extends ChangeNotifier {

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  int _countOfPeople = 0;
  int get countOfPeople => _countOfPeople;
  set countOfPeople(int value) {
    _countOfPeople = value;
    notifyListeners();
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

  Future<void> postAppointment(BuildContext context,Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      final response = await http.post(Uri.parse("$baseUrl/appointment"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode(data),
      );

      var message = jsonDecode(response.body);

      if (response.statusCode == 200) {
        countOfPeople = 0;
        if(response.statusCode == 401){
          prefs.clear();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
        }else{
          showPlatformDialog(context,alertCompleted,bookingCompleted,message["message"].toString(),"Continue",Color.fromRGBO(81, 100, 64, 1) );
        }
      }else {
        showPlatformDialog(context,alertDeleted,bookingFailed,message["error"].toString(),"cancel",Color.fromRGBO(186, 26, 26, 1));
        print('Failed to create appointment. Status code: ${response.statusCode}');
      }
    }on http.ClientException catch (_) {
      showPlatformDialog(context,alertDeleted,bookingFailed,"something went wrong","cancel",Color.fromRGBO(186, 26, 26, 1));
    }  catch (error) {
      showPlatformDialog(context,alertDeleted,bookingFailed,"something went wrong","cancel",Color.fromRGBO(186, 26, 26, 1));

      print('Error creating appointment: $error');
      throw Exception('Failed to create appointment');
    }
  }


  Future<void> deleteAppointment(BuildContext context,String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      final response = await http.delete(Uri.parse('$baseUrl/appointment/?id=$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      ).timeout(const Duration(seconds: 10));
      var decode = jsonDecode(response.body);
      if (response.statusCode == 200) {

      } else {
        showPlatformDialog(context,alertDeleted,deleteFailed,decode["error"].toString(),"cancel",Color.fromRGBO(186, 26, 26, 1));
        // print('Failed to delete appointment. Status code: ${response.statusCode}');
      }
    }on http.ClientException catch (_) {
      showPlatformDialog(context,alertDeleted,bookingFailed,"something went wrong","cancel",Color.fromRGBO(186, 26, 26, 1));
    }  catch (error) {
      print( "This ERROR $error");
      showPlatformDialog(context,alertDeleted,deleteFailed,"unable to delete","cancel",Color.fromRGBO(186, 26, 26, 1));
      // throw Exception('Failed to delete appointment');
    }
  }
}
