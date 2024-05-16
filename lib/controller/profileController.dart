

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constant/constant.dart';
import '../models/bankdetails.dart';
import '../models/update_user_details.dart';
class ProfileController extends ChangeNotifier{



  // Future<File> _compressImage(File image) async {
  //   // Read the image file as bytes
  //   Uint8List imageBytes = await image.readAsBytes();
  //   // Compress the image with target size (50 KB)
  //   List<int> compressedBytes = await FlutterImageCompress.compressWithList(
  //     imageBytes,
  //     minHeight: 250, // Adjust the height and width based on your requirements
  //     minWidth: 250,
  //     quality: 70, // Adjust the quality as needed
  //     format: CompressFormat.jpeg,
  //   );
  //
  //   // Create a temporary file and write the compressed bytes to it
  //   File compressedFile =
  //   File('${Directory.systemTemp.path}/compressed_image.jpg');
  //   compressedFile.writeAsBytesSync(compressedBytes);
  //   return compressedFile;
  // }


  Future<void> uploadData(File? image,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    if (image != null) {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/updateUser'));
    // Add the image file as a MultipartFile
    // File compressedImage = await _compressImage(image!);
    var imageFile = await http.MultipartFile.fromPath(
        'profilePic', image.path,
        contentType: MediaType('profilePic', 'jpeg'),
        filename: "profilePic${DateTime.now().toString()}.jpeg");
    request.headers['cookie'] = cookies ?? '';
    request.files.add(imageFile);
    // Send the request
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Request sent successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print(response.statusCode.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      SnackBar(
        content: Text("Failed"),
        backgroundColor: Colors.red,
      );
    }
  }else{
      SnackBar(
        content: Text("image Not Selected"),
        backgroundColor: Colors.red,
      );
  }
  }

  Future<void> appFeedback(BuildContext context,var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      final response = await http.post(Uri.parse("$baseUrl/appFeedback"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode(data),
      );

      // var message = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        // if(response.statusCode == 401){
        //   prefs.clear();
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
        // }
        // else{
        //   showPlatformDialog(context,alertCompleted,bookingCompleted,message["message"].toString(),"Continue",Color.fromRGBO(81, 100, 64, 1) );
        // }
      }else {
        // showPlatformDialog(context,alertDeleted,bookingFailed,message["error"].toString(),"cancel",Color.fromRGBO(186, 26, 26, 1));
        // print('Failed to create appointment. Status code: ${response.statusCode}');
      }
    }on http.ClientException catch (_) {
      // showPlatformDialog(context,alertDeleted,bookingFailed,"something went wrong","cancel",Color.fromRGBO(186, 26, 26, 1));
    }  catch (error) {
      // showPlatformDialog(context,alertDeleted,bookingFailed,"something went wrong","cancel",Color.fromRGBO(186, 26, 26, 1));
      print('Error creating appointment: $error');
      throw Exception('Failed to create appointment');
    }
  }

  Future<void> profileEdit(BuildContext context, UpdateUserDetail data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.put(
        Uri.parse("$baseUrl/updateUserDetails"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: json.encode(data.toJson())
      );

      if (response.statusCode == 200) {

        // Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pop(context);
        print("Sucess");
      } else {
        // Handle other status codes if needed
        print("Failed to load updateUserDetails : ${response.statusCode}");
      }
    } catch (e) {
      print("Error updateUserDetails: $e");
    }
    notifyListeners();
  }

  Future<void> bankDetailsData(BuildContext context, BankDetail data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.put(
          Uri.parse("$baseUrl/updteBankDetails"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            if (cookies != null) 'Cookie': cookies,
          },
          body: json.encode(data.toJson())
      );

      if (response.statusCode == 200) {
        Navigator.popUntil(context, (route) => route.isFirst);
        print("Sucess");
      } else {
        // Handle other status codes if needed
        print("Failed to load updateUserDetails : ${response.statusCode}");
      }
    } catch (e) {
      print("Error updateUserDetails: $e");
    }
    notifyListeners();
  }


  BankDetail? _bankDataDetails;

  BankDetail? get bankDataDetails => _bankDataDetails;

  Future<void> getBankDetails() async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var cookies = prefs.getString("cookie");
        final response = await http.get(
            Uri.parse("$baseUrl/getBankDetails"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              if (cookies != null) 'Cookie': cookies,
            },
        );
        var decode = jsonDecode(response.body);
        if (response.statusCode == 200) {
          _bankDataDetails = BankDetail.fromJson(decode);
          print(decode.toString());
        } else {
          // Handle other status codes if needed
          print("Failed to load updateUserDetails : ${response.statusCode}");
        }
      } catch (e) {
        print("Error updateUserDetails: $e");
      }
      notifyListeners();
    }

}