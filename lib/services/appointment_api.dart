import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:thusmai_appointmrent/constant/appointment_constant.dart';
import '../models/appointment_model.dart';
import '../widgets/dialogbox.dart';


Future<List<ListElement>> fetchAppointments(String phone) async {
  try {
    var response = await http.get(
      Uri.parse("$baseUrl/list-appointment?phone=$phone"),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      dynamic datas = jsonDecode(response.body);
      var data = datas["list"];
      // log(data.toString());
      // Check if data is a list or a single object
      if (data is List) {
        return data.map((json) => ListElement.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        return [ListElement.fromJson(data)];
      } else {
        print("no data");
        throw Exception('Invalid data format');
      }
    } else {
      print('Failed to load appointments: ${response.reasonPhrase}');
      return [];
    }
  } catch (e) {
    print('Error fetching appointments: $e');
    return [];
  }
}

Future<void> postAppointment(BuildContext context,Map<String, dynamic> data) async {
  try {
    final response = await http.post(Uri.parse("$baseUrl/appointment"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    var message = jsonDecode(response.body);

    if (response.statusCode == 200) {
      showPlatformDialog(context,alertCompleted,bookingCompleted,message["message"].toString(),"Continue",Color.fromRGBO(81, 100, 64, 1) );
    } else {
      showPlatformDialog(context,alertDeleted,bookingFailed,message["error"].toString(),"cancel",Color.fromRGBO(186, 26, 26, 1));

      print('Failed to create appointment. Status code: ${response.statusCode}');
    }
  } catch (error) {
    showPlatformDialog(context,alertDeleted,bookingFailed,"something went wrong","cancel",Color.fromRGBO(186, 26, 26, 1));

    print('Error creating appointment: $error');
    throw Exception('Failed to create appointment');
  }
}


Future<void> deleteAppointment(BuildContext context,String id,String phone) async {

  try {
    final response = await http.delete(Uri.parse('$baseUrl/appointment/?id=$id&phone=$phone'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(Duration(seconds: 10));

var decode = jsonDecode(response.body);
    final String specificCookie = response.headers['set-cookie']?.split(';')[0] ?? "";
    final sessionId = specificCookie.split('=')[1];
    print(sessionId);

    if (response.statusCode == 200) {
    } else {
      showPlatformDialog(context,alertDeleted,deleteFailed,decode["error"].toString(),"cancel",Color.fromRGBO(186, 26, 26, 1));
      print('Failed to delete appointment. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print(error);
    // showPlatformDialog(context,alertDeleted,deleteFailed,"unable to delete","cancel",Color.fromRGBO(186, 26, 26, 1));
    // throw Exception('Failed to delete appointment');
  }
}

// Future<http.Response> deleteAp(String id) async {
//   final http.Response response = await http.delete(
//     Uri.parse('$baseUrl/appointment/$id'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
// if(response.statusCode == 200){
//   print("sucess");
//   print(response.body);
//   return response;
// }else{
//   print("object");
//   print(response.body);
//   return response;
// }
// }