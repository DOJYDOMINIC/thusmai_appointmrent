import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/models/userlogin.dart';
import '../controller/login_register_otp_api.dart';
import 'package:flutter/material.dart';

import '../login/otp_verification.dart';

class ApiService {
  final String apiUrl = '${userBaseUrl}/register';
  UserLoginData? _userLoginData;

  UserLoginData? get userLoginData => _userLoginData;

  Future<void> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String dob,
    required String gender,
    required String country,
    required String phone,
    required String reference,
    required String refId,
    required String languages,
    required String remark,
    File? profilePic,
    required BuildContext context,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['email'] = email;
      request.fields['DOB'] = dob;
      request.fields['gender'] = gender;
      request.fields['country'] = country;
      request.fields['phone'] = phone;
      request.fields['reference'] = reference;
      request.fields['ref_id'] = refId;
      request.fields['languages'] = languages;
      request.fields['remark'] = remark;

      if (profilePic != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePic',
            profilePic.path,
          ),
        );
      }

      var response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        print('Response: $responseString');
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // final String? specificCookie = response.headers['set-cookie'];
        // if (specificCookie != null) {
        //   final sessionId = specificCookie;
        //   prefs.setString("cookie", sessionId);
        // }

        // Check if _userLoginData is not null before accessing its properties
        // if (_userLoginData != null) {
        //   prefs.setString("isAnswered", _userLoginData!.isans.toString());
        // }

        // final responseString = String.fromCharCodes(responseData);

        print('Response: $responseString');

        UserContactInfo data = UserContactInfo(
          phone: country == "India" ? phone : phone,
          country: country,
          email: country == "India" ? email : email,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => otpPageData(
                data: data,
              ),
            ));
      } else if (response.statusCode == 400) {
        // Parse the response body to extract the message
        final errorResponse = jsonDecode(responseString);
        final errorMessage = errorResponse['message'] ?? 'An error occurred';

        // Show the message in a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(errorMessage)),
            backgroundColor: Colors.red, // Change to your preferred color
          ),
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
}
