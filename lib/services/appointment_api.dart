import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import '../widgets/dialogbox.dart';



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
      print('Failed to delete appointment. Status code: ${response.statusCode}');
    }
  }on http.ClientException catch (_) {
    showPlatformDialog(context,alertDeleted,bookingFailed,"something went wrong","cancel",Color.fromRGBO(186, 26, 26, 1));
  }  catch (error) {
    print( "This ERROR $error");
    showPlatformDialog(context,alertDeleted,deleteFailed,"unable to delete","cancel",Color.fromRGBO(186, 26, 26, 1));
    // throw Exception('Failed to delete appointment');
  }
}