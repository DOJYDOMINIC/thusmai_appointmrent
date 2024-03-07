import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/bottom_navbar.dart';
import '../constant/constant.dart';
import '../pages/login_register_otp/changepassword.dart';
import '../pages/login_register_otp/login.dart';
import '../pages/login_register_otp/otpPage.dart';
import '../pages/login_register_otp/reset_password.dart';


class AppLogin extends ChangeNotifier {
  Future<void> loginApi(BuildContext context,Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse("$baseUrl/login"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    // final String specificCookie = response.headers['set-cookie']?.split(';')[0] ?? "";
    // final sessionId = specificCookie.split('=')[1];
    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200){
        print(decode);
        final String? specificCookie = response.headers['set-cookie'];
        final sessionId = specificCookie;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cookie", sessionId!);
        print(sessionId);
        Navigator.pushReplacement(context,
            MaterialPageRoute(
              builder: (context) => CustomBottomNavBar(),
            ));
      } else if (response.statusCode == 404) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Register(),
            ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red,
            content: Text(decode["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // print("Login Error : $e");
    }
  }

  Future<void> requestPasswordReset(BuildContext context,String data,) async {
    print(data);
    final response = await http.post(Uri.parse("$baseUrl/requestPasswordReset"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": data}));
    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => otpPage(data: data),
            ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red,
            content: Text(decode["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Login Error : $e");
    }
  }
  Future<void> otpVerification(BuildContext context,Map<String,dynamic> data) async {
    final response = await http.post(Uri.parse("$baseUrl/verify-userotp"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green,
            content: Text(decode["message"]),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePassword(data: data["email"]),
            ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red,
            content: Text(decode["error"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Login Error : $e");
    }
  }

  Future<void> resetPassword(BuildContext context,Map<String,dynamic> data) async {

    final response = await http.post(Uri.parse("$baseUrl/resetPassword"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green,
            content: Text(decode["message"]),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red,
            content: Text(decode["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Login Error : $e");
    }
  }
}
