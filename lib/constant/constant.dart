
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Const Api link

const  baseUrl = "http://94.176.237.33:3000/api/v1/User";

// images
const String alertCompleted = "assets/images/Alert Completed.png";
const String alertDeleted = "assets/images/Alert Delete.png";
const String logo = "assets/images/Tasmai logo.png";

// appbarColor
 Color appBackground = Color.fromRGBO(255, 251, 255, 1);
 Color pageBackground = Color.fromRGBO(234, 225, 217, 1);
 Color  textFieldOutline = Color.fromRGBO(129, 117, 103, 1);
 Color  tabIndicator = Color.fromRGBO(79, 69, 57, 1);
 Color textBoxBorder = Color.fromRGBO(31, 27, 22, 1);
 Color  buttonColor = Color.fromRGBO(254,185,77,1);

// Text
const String bookAppointment = "Book Appointment";
const String appointmentDate = "Appointment Date";
const String ddMmYyyy = "DD/MM/YYYY";
const String tryAgain = "Try Again Later";
const String noData = "No data";
const String confirmBooking = "Confirm Booking";
const String bookingCompleted = "Booking Complete";
const String bookingFailed = "Booking Failed";
const String deleteSucess = "Delete Sucess";
const String deleteFailed = "Delete Failed";
const String overview = " Overview";
const String appointment = " Appointment";
const String pageNotAvailable = " Page Not Avilable";


//Space between textFields
var spaceBetween = SizedBox(height: 16.sp);


// TextField date format
class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    //this fixes backspace bug
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    return newValue.copyWith(text: dateText, selection: updateCursorPosition(dateText));
  }

  String _addSeperators(String value, String seperator) {
    value = value.replaceAll('/', '');
    var newString = '';
    for (int i = 0; i < value.length; i++) {
      newString += value[i];
      if (i == 1) {
        newString += seperator;
      }
      if (i == 3) {
        newString += seperator;
      }
    }
    return newString;
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

prefsSet(str,val)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("$str",val);
}


prefsGet(str)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
 String? data = prefs.getString(str);
  return data;
}