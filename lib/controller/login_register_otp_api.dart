import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/models/userdata.dart';
import 'package:thusmai_appointmrent/models/userlogin.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import '../models/flagsmode.dart';
import '../pages/bottom_navbar.dart';
import '../constant/constant.dart';
import '../pages/login_register_otp/changepassword.dart';
import '../pages/login_register_otp/login.dart';
import '../pages/login_register_otp/meditationdata.dart';
import '../pages/login_register_otp/otpPage.dart';
import '../pages/login_register_otp/reset_password.dart';
import '../pages/profile/password_reset/resetpage_two.dart';
import '../pages/profile/password_reset/resetpasge_three.dart';

class AppLogin extends ChangeNotifier {
// firstLogin check

  int _currentIndex = 1;

  int get currentIndex => _currentIndex;

  set currentIndex(int newIndex) {
    if (_currentIndex != newIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }

  bool _firstLogin = true;

  bool get firstLogin => _firstLogin;

  set firstLogin(bool value) {
    _firstLogin = value;
    notifyListeners();
  }

  // updated and manage moving tile

  List<String> _myTiles = ["Financial", "Health", "Mental", "Relationship"];

  List<String> get myTiles => _myTiles;

  void updateMyTile(int oldIndex, int newIndex) {
    // An adjustment is needed when moving the tile down
    if (oldIndex < newIndex) {
      newIndex--;
    }
    // get the tile we are moving
    final tile = _myTiles.removeAt(oldIndex);
    // place the tile in new position
    _myTiles.insert(newIndex, tile);
    notifyListeners(); // Notify listeners to rebuild widgets
  }

  UserClass? _userData;

  UserClass? get userData => _userData;

  Future<void> getUserByID() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.get(
        Uri.parse("$baseUrl/getUserById"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        _userData = UserClass.fromJson(decode["user"]);
        tokenSave();
      } else if (response.statusCode == 404) {
        // Handle 404 Not Found error
        _userData = null;
      } else {
        // Handle other status codes
      }
    } catch (e) {
      print("getUserByID : $e");
    }
    notifyListeners();
  }

  Future<void> meditationData(
    BuildContext context,
    List<String> data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$baseUrl/meditation-data"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({"ans": data, "isans": true}));
    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        prefs.setString("isAnswered", "true");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(decode["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("meditationData : $e");
    }
  }

  Message _flagModel = Message();

  Message get flagModel => _flagModel;

  Future<void> importantFlags() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.get(
      Uri.parse("$baseUrl/flag"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (cookies != null) 'Cookie': cookies,
      },
    );
    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        _flagModel = Message.fromJson(decode["message"]);
        prefs.setString("isAnswered", "true");
      } else {
      }
    } catch (e) {
    }
    notifyListeners();
  }

  UserLoginData? _userLoginData;

  UserLoginData? get userLoginData => _userLoginData;

  Future<void> loginApi(BuildContext context, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/login"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 3)); // Set timeout to 5 seconds

      var decode = jsonDecode(response.body);
      print(decode.toString());

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _userLoginData = UserLoginData.fromJson(decode["user"]);
        final String? specificCookie = response.headers['set-cookie'];
        final sessionId = specificCookie;
        prefs.setString("cookie", sessionId!);
        prefs.setString("isAnswered", _userLoginData!.isans.toString());
        var isAnswered = prefs.getString("isAnswered");
        var fCMToken = prefs.getString("fCMToken");
        if (fCMToken != null) {
          print(data);
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                isAnswered != "true" ? MeditationData() : CustomBottomNavBar(),
          ),
        );
      } else if (response.statusCode == 404) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(decode["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } on http.ClientException catch (e) {
      // Handle timeout or other http client exceptions
      print("HTTP Client Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Request timed out or other network error occurred."),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Handle other exceptions
      print("Other Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Something wentwrong"),
          duration: Duration(seconds: 1),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> requestPasswordReset(
    BuildContext context,
    String data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$baseUrl/requestPasswordReset"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": data}));
    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        if (cookies == null || cookies == "" || cookies.isEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => otpPage(data: data),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPageTwo(data: data),
              ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(decode["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("requestPasswordReset : $e");
    }
  }

  Future<void> otpVerification(
      BuildContext context, Map<String, dynamic> data) async {
    print(data.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$baseUrl/verify-userotp"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text(decode["message"]),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
        if (cookies == null || cookies == "" || cookies.isEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePassword(data: data),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPageThree(data: data),
              ));
        }
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ChangePassword(data: data["email"]),
        //     ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(decode["error"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("otpVerification : $e");
    }
  }

  Future<void> resetPassword(
      BuildContext context, Map<String, dynamic> data) async {
    print(data.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    final response = await http.post(Uri.parse("$baseUrl/resetPassword"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text(decode["message"]),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
        if (cookies == null || cookies == "" || cookies.isEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Profile()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(decode["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("resetPassword : $e");
    }
  }

  Future<void> tokenSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    var token = prefs.getString("fCMToken");
    print(token);
    final response = await http.post(Uri.parse("$paymentBaseUrl/save-token"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({"token": token, "UId": userData?.uId}));
    try {
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print("otpVerification : $e");
    }
  }
}
