import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/models/userdata.dart';
import 'package:thusmai_appointmrent/models/userlogin.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import '../login/otp_verification.dart';
import '../login/register.dart';
import '../models/flagsmode.dart';
import '../models/listQuestions.dart';
import '../pages/bottom_navbar.dart';
import '../constant/constant.dart';
import '../pages/login_register_otp/changepassword.dart';
import '../pages/login_register_otp/login.dart';
import '../pages/login_register_otp/meditationdata.dart';
import '../pages/login_register_otp/otpPage.dart';
import '../pages/profile/password_reset/resetpage_two.dart';
import '../pages/profile/password_reset/resetpasge_three.dart';
import '../widgets/additionnalwidget.dart';

class AppLogin extends ChangeNotifier {
  bool _isButtonDisabled = false;

  bool get isButtonDisabled => _isButtonDisabled;

  void disableButton() {
    _isButtonDisabled = true;
    notifyListeners();

    Timer(Duration(seconds: 2), () {
      _isButtonDisabled = false;
      notifyListeners();
    });
  }

// firstLogin check

  int _currentIndex = 0;

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

  late List<String> _myTiles = [
    "Financial",
    "Health",
    "Mental",
    "Relationship"
  ];

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
        Uri.parse("$userBaseUrl/getUserById"),
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

  ListQuestions _listQuestions = ListQuestions();

  ListQuestions get listQuestion => _listQuestions;

  Future<void> listQuestions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.get(
        Uri.parse("$userBaseUrl/list-questions"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      var decode = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _listQuestions = ListQuestions.fromJson(decode[0]);

        _myTiles = [
          _listQuestions.ans1 ?? "N/A",
          _listQuestions.ans2 ?? "N/A",
          _listQuestions.ans3 ?? "N/A",
          _listQuestions.ans4 ?? "N/A",
          _listQuestions.ans5 ?? "N/A",
        ];
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print("getUserByID : $e");
      }
    }
    notifyListeners();
  }

  Future<void> deleteUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.delete(
        Uri.parse("$userBaseUrl/delete-user"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      var res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        prefs.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(res["message"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("getUserByID : $e");
      }
    }
  }

  Future<void> validateSession(BuildContext context) async {
    // try {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var cookies = prefs.getString("cookie");
    //   final response = await http.get(
    //     Uri.parse("$userBaseUrl/validate-session"),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       if (cookies != null) 'Cookie': cookies,
    //     },
    //   );
    //
    //   if (response.statusCode == 200) {
    //     print("valid user");
    //   } else if (response.statusCode == 401) {
    //     _currentIndex = 1;
    //     print("Not valid user");
    //     prefs.clear();
    //     // slidePageRoute(context, Login());
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => Login()),
    //       (Route<dynamic> route) => false,
    //     );
    //   } else {}
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("getUserByID : $e");
    //   }
    // }
  }

  Future<void> backendSessionClear() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.get(
        Uri.parse("$userBaseUrl/logout"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
      } else if (response.statusCode == 401) {
      } else {}
    } catch (e) {
      if (kDebugMode) {
        print("getUserByID : $e");
      }
    }
  }

  Future<void> meditationData(
    BuildContext context,
    List<String> data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$userBaseUrl/meditation-data"),
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
      Uri.parse("$userBaseUrl/flag"),
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
      } else {}
    } catch (e) {}
    notifyListeners();
  }

  UserLoginData? _userLoginData;

  UserLoginData? get userLoginData => _userLoginData;

  Future<void> loginApi(BuildContext context, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse("$userBaseUrl/login"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 3)); // Set timeout to 5 seconds

      var decode = jsonDecode(response.body);

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
        // requestPasswordReset(context, data["email"]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => otpPage(),
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



  Future<void> otpVerification(
      BuildContext context, UserContactInfo data,String otp) async {
    var otpData  = { "email":data.email??"test@gmail.com", "phone":data.phone??"000000000", "country":data.country,"otp":otp};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$userBaseUrl/verify-userotp"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },

        body: jsonEncode(otpData));

    var decode = jsonDecode(response.body);
    try {
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
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text(decode["message"]),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
        if (decode["verify"] == true){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomBottomNavBar(),));
        }else{
          print("User not registerds");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage(),));
        }
        // if (cookies == null || cookies == "" || cookies.isEmpty) {
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ChangePassword(data: data),
        //       ));
        // } else {
        //   Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ResetPageThree(data: data),
        //       ));
        // }
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    final response = await http.post(Uri.parse("$userBaseUrl/resetPassword"),
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


  Future<void> sendOtp(BuildContext context, UserContactInfo data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var cookies = prefs.getString("cookie");

    try {
      final response = await http.post(
        Uri.parse("$userBaseUrl/send-otp"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      var decode = jsonDecode(
          response.body); // Correctly decode the response body

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decode["verify"] == true) {
          // Handle successful response
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => otpPageData(data: data),
            ),
          );
          print(decode);
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterPage(),));
        }
      } else {
        // Handle non-2xx status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed to send OTP: ${response.statusCode}"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Handle any errors during the request
      print("Error in sendOtp: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}






  class UserContactInfo {
  final String? phone; // Optional
  final String? email; // Optional
  final String? country; // Optional

  UserContactInfo({
    this.phone, // No required keyword
    this.email, // No required keyword
    this.country, // No required keyword
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone??"0000000000",
      'email': email??"dasdfghjkl@gmail.com",
      'country': country??"",
    };
  }

  factory UserContactInfo.fromJson(Map<String, dynamic> json) {
    return UserContactInfo(
      phone: json['phone'],
      email: json['email'],
      country: json['country'],
    );
  }
}
