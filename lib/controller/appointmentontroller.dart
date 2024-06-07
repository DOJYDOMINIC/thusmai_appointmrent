import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:thusmai_appointmrent/models/disabledates.dart';
import '../constant/constant.dart';
import '../models/appointment_add_model.dart';
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

  //no of people count managing on appointment added

  int _countOfPeople = 0;

  int get countOfPeople => _countOfPeople;

  set countOfPeople(int value) {
    _countOfPeople = value;
    notifyListeners();
  }

  void addCount() {
    if (_countOfPeople < 5) {
      _countOfPeople++;
      notifyListeners();
    }
  }

  void subtract() {
    if (_countOfPeople >= 1) {
      _countOfPeople--;
      notifyListeners();
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
      // _appointments = [];
    }
    notifyListeners();
  }

  String tAndC = "";

  Future<void> termsAndCondition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/rulesAndConditions"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> dataList = jsonDecode(response.body);
        tAndC = dataList["condition"].toString();
      } else {
        print('Failed to load appointments: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
    notifyListeners();
  }

  Future<void> updateAppointment(BuildContext context, ListElement data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    // var id = data["id"];

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/updateAppointment/${data.id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode(data),
      );

      var message = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showPlatformDialog(
            context,
            alertCompleted,
            bookingCompleted,
            message["message"].toString(),
            "Continue",
            Color.fromRGBO(81, 100, 64, 1));
      } else if (response.statusCode == 401) {
        prefs.clear();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      } else {
        showPlatformDialog(
            context,
            alertDeleted,
            bookingFailed,
            message["error"].toString(),
            "cancel",
            Color.fromRGBO(186, 26, 26, 1));
        print(
            'Failed to create appointment. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (_) {
      showPlatformDialog(context, alertDeleted, bookingFailed,
          "something went wrong", "cancel", Color.fromRGBO(186, 26, 26, 1));
    } catch (error) {
      showPlatformDialog(context, alertDeleted, bookingFailed,
          "something went wrong", "cancel", Color.fromRGBO(186, 26, 26, 1));

      print('Error creating appointment: $error');
      throw Exception('Failed to create appointment');
    }
  }

  Future<void> postAppointment(
      BuildContext context, AppointmentAddData data) async {
    print(data.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/appointment"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode(data),
      );

      var message = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Provider.of<AppointmentController>(context, listen: false)
            .fetchAppointments();
        countOfPeople = 0;
        // if(response.statusCode == 401){
        //   prefs.clear();
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
        // }else{
        showPlatformDialog(
            context,
            alertCompleted,
            bookingCompleted,
            message["message"].toString(),
            "Continue",
            Color.fromRGBO(81, 100, 64, 1));
        // }
      } else {
        showPlatformDialog(
            context,
            alertDeleted,
            bookingFailed,
            message["error"].toString(),
            "cancel",
            Color.fromRGBO(186, 26, 26, 1));
        print(
            'Failed to create appointment. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (_) {
      showPlatformDialog(context, alertDeleted, bookingFailed,
          "something went wrong", "cancel", Color.fromRGBO(186, 26, 26, 1));
    } catch (error) {
      showPlatformDialog(context, alertDeleted, bookingFailed,
          "something went wrong", "cancel", Color.fromRGBO(186, 26, 26, 1));

      print('Error creating appointment: $error');
      throw Exception('Failed to create appointment');
    }
  }

  Future<void> deleteAppointment(BuildContext context, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete-appointment/?id=$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      ).timeout(const Duration(seconds: 10));
      var decode = jsonDecode(response.body);
      if (response.statusCode == 200) {
        fetchAppointments();
      } else {
        showPlatformDialog(
            context,
            alertDeleted,
            deleteFailed,
            decode["error"].toString(),
            "cancel",
            Color.fromRGBO(186, 26, 26, 1));
        // print('Failed to delete appointment. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (_) {
      showPlatformDialog(context, alertDeleted, bookingFailed,
          "something went wrong", "cancel", Color.fromRGBO(186, 26, 26, 1));
    } catch (error) {
      print("This ERROR $error");
      showPlatformDialog(context, alertDeleted, deleteFailed,
          "unable to delete", "cancel", Color.fromRGBO(186, 26, 26, 1));
      // throw Exception('Failed to delete appointment');
    }
  }

  Future<void> deleteMember(BuildContext context, int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/group-members/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      ).timeout(const Duration(seconds: 10));
      var decode = jsonDecode(response.body);
      if (response.statusCode == 200) {
      } else {
        showPlatformDialog(
            context,
            alertDeleted,
            deleteFailed,
            decode["error"].toString(),
            "cancel",
            Color.fromRGBO(186, 26, 26, 1));
        // print('Failed to delete appointment. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (_) {
      showPlatformDialog(context, alertDeleted, deleteFailed,
          "something went wrong", "cancel", Color.fromRGBO(186, 26, 26, 1));
    } catch (error) {
      print("This ERROR $error");
      showPlatformDialog(context, alertDeleted, deleteFailed,
          "unable to delete", "cancel", Color.fromRGBO(186, 26, 26, 1));
      // throw Exception('Failed to delete appointment');
    }
  }

  Future<void> appointmentFeedback(BuildContext context, var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/rating"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(" Feedback Shared Successfully"),
            backgroundColor: Colors.green,
          ),
        );
        if (response.statusCode == 401) {
          prefs.clear();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on http.ClientException catch (_) {
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DisableDates _disableDate = DisableDates();

  DisableDates get disabledDate => _disableDate;

  Future<void> disableDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/guruji-date"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        var disableDates = jsonDecode(response.body);
        _disableDate = DisableDates.fromJson(disableDates);
        print(_disableDate.disabledDates);

      } else {
        print('Failed to load appointments: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
    notifyListeners();
  }
}
