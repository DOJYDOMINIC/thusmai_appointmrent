
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Const Api link

const  baseUrl = "https://thasmai.tstsvc.in/api/v1/User";

// const  baseUrl = "https://192.168.1.45:5000/api/v1/User";

// images
const String alertCompleted = "assets/images/Alert Completed.png";
const String alertDeleted = "assets/images/Alert Delete.png";
const String logo = "assets/images/Tasmai logo.png";
const String error = "assets/images/error.svg";
const String guruji = "assets/images/guruji.png";


// appbarColor
const Color pageBackground = Color.fromRGBO(255, 251, 255, 1);
Color  textFieldOutline = Color.fromRGBO(129, 117, 103, 1);
const Color  iconColor = Color.fromRGBO(79, 69, 57, 1);
Color  placeHolder = Color.fromRGBO(79, 69, 57, 1);
Color  buttonColor = Color.fromRGBO(255, 185, 76,1);
Color  buttonText = Color.fromRGBO(68, 43, 0,1);
Color  dividerLine = Color.fromRGBO(240, 224, 207,1);
Color  heading = Color.fromRGBO(31, 27, 22,1);
Color  subtext = Color.fromRGBO(79, 69, 57,1);
Color  appbar = Color.fromRGBO(31, 27, 22, 1);
Color  inputText = Color.fromRGBO(31, 27, 22, 1);


Color  bottomNavLabel = Color.fromRGBO(234, 225, 217, 1);
Color  iconContainer = Color.fromRGBO(86, 68, 42, 1);
Color  navIcon = Color.fromRGBO(250, 222, 188, 1);
Color  bottomNavLabelUnSelected = Color.fromRGBO(211, 196, 180, 1);


// Text box when Clicked/Selected
Color  onSelectTextFieldOutline = Color.fromRGBO(31, 27, 22,1);
Color  textContainer = Color.fromRGBO(240, 224, 207,1);



 // other
 // Color textFieldOutline =

// Text
const String ddMmYyyy = "DD/MM/YYYY";
const String tryAgain = "Try Again Later";
const String noData = "No data";
const String overview = " Overview";
const String appointment = " Appointment";
const String pageNotAvailable = " Page Not Avilable";
const String registeredPhone = "Registered Phone";
const String noAppointmentsBooked =  "No Appointments Booked !";
const String somethingWentWrong =  "Something went wrong. ";
const String pageUnderWork =  "Page Not Available. ";



// Dialog box
const String bookingCompleted = "Booking Complete";
const String bookingFailed = "Booking Failed";
const String deleteFailed = "Delete Failed";
const String deleteSucess = "Delete Sucess";



// Appointment Add Page
const String bookAppointment = "Book Appointment";
const String appointmentDate = "Appointment Date";
const String noOfDays = "No. of days";
const String noOfPeople = "No. of people";
const String pickupCheckbox = "Pick Up ?";
const String pickUpPoint = "Pickup Point";
const String destination =  "Destination";
const String emergencyContact =  "Emergency Contact";
const String remark = "Remarks";
const String confirmBooking = "Confirm Booking";



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

