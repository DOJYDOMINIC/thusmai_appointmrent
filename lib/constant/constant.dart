import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Const Api link

const baseUrl = "https://thasmai.tstsvc.in/api/v1/User";
// const baseUrl = "http://192.168.1.84:5000/api/v1/User";

const  adminBaseUrl = "https://thasmai.tstsvc.in/api/v1/admin";
const  paymentBaseUrl = "https://thasmai.tstsvc.in/api/v1/payment";

// const  adminBaseUrl = "http://192.168.1.84:5000/api/v1/admin";


// Url to Launch
final Uri registerUrl = Uri.parse("https://thasmai.tstsvc.in");






// images
const String alertCompleted = "assets/images/Alert Completed.png";
const String alertDeleted = "assets/images/Alert Delete.png";
const String logo = "assets/images/Tasmai logo.png";
const String guruji = "assets/images/guruji.png";


// svg
const String errorSvg = "assets/svgImage/error.svg";
const String gift = "assets/svgImage/Gift.svg";
const String megaphone = "assets/svgImage/Megaphone.svg";
const String ratingAverage = "assets/svgImage/RatingAverage.svg";
const String ratingBad = "assets/svgImage/RatingBad.svg";
const String ratingExcellent = "assets/svgImage/RatingExcellent.svg";
const String smiley = "assets/svgImage/Smiley.svg";
const String smileyMeh = "assets/svgImage/SmileyMeh.svg";
const String smileySad = "assets/svgImage/SmileySad.svg";



// New
Color shadeOne = Color.fromRGBO(255, 251, 255, 1);

Color shadeTwo = Color.fromRGBO(234, 225, 217, 1);

Color shadeThree = Color.fromRGBO(234,225,217, 1);

Color shadeFour = Color.fromRGBO(240, 224, 207, 1);

Color shadeFive = Color.fromRGBO(211, 196, 180, 1);

Color shadeSix = Color.fromRGBO(250,222,188, 1);

Color shadeSeven = Color.fromRGBO(255,221,178, 1);

Color shadeEight = Color.fromRGBO(221,194,161, 1);

Color shadeNine = Color.fromRGBO(129, 117, 103, 1);

Color shadeTen = Color.fromRGBO(79, 69, 57, 1);

Color eventSubText = Color.fromRGBO(79,69,57, 1);

Color shadeEleven = Color.fromRGBO(86, 68, 42, 1);

Color brown = Color.fromRGBO(68, 43, 0, 1);

Color darkShade = Color.fromRGBO(31, 27, 22, 1);

Color goldShade = Color.fromRGBO(255, 185, 76, 1);
Color lightRed = Color.fromRGBO(255,180,171, 1);
Color midRed = Color.fromRGBO(105,0,5, 1);

Color red = Color.fromRGBO(186,26,26, 1);

Color ringColor = Color.fromRGBO(156,143,128, 1);
Color greenColor = Color.fromRGBO(183,206,162, 1);
Color profileTextFieldDillColor = Color.fromRGBO(240,224,207, 1);
Color meditationLogGreen = Color.fromRGBO(81,100,64, 1);
Color meditationLogRed = Color.fromRGBO(186,26,26, 1);



// Text
const String ddMmYyyy = "DD/MM/YYYY";
const String tryAgain = "Try Again Later";
const String noData = "No data";
const String overview = " Overview";
const String appointment = " Appointment";
const String pageNotAvailable = " Page Not Avilable";
const String registeredPhone = "Registered Phone";
const String noAppointmentsBooked = "No Appointments Booked !";
const String somethingWentWrong = "Something went wrong. ";
const String pageUnderWork = "Page Not Available. ";

// Dialog box
const String bookingCompleted = "Booking Complete";
const String bookingFailed = "Booking Failed";
const String deleteFailed = "Delete Failed";
const String deleteSuccess = "Delete Sucess";
const String areYouSure = "Are you sure to delete ? ";
const String bookingCancelMessage = "Booking cancellation occurs when an \nappointment is deleted. ";
const String confirm = "Confirm";
const String cancel = 'Cancel';
const String save = 'Save';
const String clear = "Clear";
const String editAppointment = "Edit Appointment";
const String na = "N/A";


const String appointmentDateValidation = "Please select appointment date";
const String meditation = "Meditation";
const String videos = "Videos";
const String home = "Home";
const String payment = "Payments";
const String enable = "Please Do payment to enable Meditation";
const String name = "Name";
const String age = "Age";
const String pickupValidation = 'Please enter a Valid Pickup Point';
const String termsAndCondition = "Terms and conditions ";
const String declaration = "I hereby acknowledge that I have read and accept the ";
const String declarationBalance = "governing appointments.";
const String phoneRequired = 'Phone number is required';
const String validNumber = 'Enter a valid phone number';


// Appointment Add Page
const String bookAppointment = "Book Appointment";
const String appointmentDate = "Appointment Date";
const String noOfDays = "No. of days";
const String noOfPeople = "No. of people";
const String pickupCheckbox = "Pick Up ?";
const String pickUpPoint = "Pickup Point";
const String destination = "Destination";
const String emergencyContact = "Emergency Contact";
const String remark = "Remarks";
const String confirmBooking = "Confirm Booking";
const String appointmentForOther = "Who are you booking for ?";



// default image
String defaultImage = "/9j/4AAQSkZJRgABAQACWAJYAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wgALCADIAMgBAREA/8QAHAABAAIDAQEBAAAAAAAAAAAAAAYIAwUHAgEE/9oACAEBAAAAAO/gAAAAAAAAAAAAAAAAAAAAAAAAAD8PDIfMO5/uAAA81AgJPrf+gAAQumgXLmgAAIJTsLiTsAAGGmEVJVc/MAABoq8Q+YWH3oAAB8wZ/oAACH8I53rtj0Tu8wAADjdasIZrK9kAAOfVE8Ae7d9BAAU4g4BOLjgAaWjnkA+3k3QAIvXIALGygAAAAAAAAAAAAAAAAAAAAAAAAAH/xAA5EAABAgQCBgYIBgMAAAAAAAABAgMEBQYRAAcSFyExUWETQFSBlKEUFSAwQVJxsQgWImJwwXOR0f/aAAgBAQABPwD+IJvOICRS52YTKKbhoVoXU4s27hxPLFTfiLWHls03LEFsGwiYu91cwgbu84191z0un6VB6PyejJt/3FM/iLWXkM1JLEBsmxiYS908yg7+44lE4gJ7LmphLYpuJhXRdLiDfuPA8uqOOJabU4tQShIKlKO4AYzSzAia0qJ1DTqhKYVZRDNA7FW2aZ5n7exlbmBE0XUTSHXVGUxSwiJaJ2Jvs0xzH2w24h1tLiFBSFAKSobiD1PNmaOSjLOcxDSilxbQZSR8NMhP2J9rKaaOTfLOTRDqipxDRZUT8dAlI8gOp5xQC5hldOENglTSEvWHBKgT5X9rJ2AXL8rpOhwFKnUKeseClEjyt1OKhmoyFdhn0BbLqChaT8UkWIxmBRsXRVTPwDyFGFUSuFetscbO7vG4+xl/RsXWtTMQDKFCFSQuKetsbbG/vO4YhYZqDhWoZhIQ00gIQkbgkCwHVKqpKUVhKVS+bQ4Wje24nYtpXFJ+GKmyBqWWPLckym5pC70gKCHQOaTsPccas616Xo/y1MNL/Fs/3uxTOQNSzN5Dk5U3K4XeoFQW6RySNg7zilaSlFHylMvlMOEI3uOK2rdVxUfj1ZSkoF1EAcSbY9OhL29KYvw6QYSpKxdJBHEG/VayzJp+imimPieljSLohGLKcP1+UfXFSZ+VRNVrblQalUMdg6Mabluaj/QxH1HOpo4Vx02jYhR39I+o+V8dM5e/SLvx0jiAqOdytwOQM2jYdQ3dG+oeV8U3n5VEqWhuahqaww2HpBoOW5KH9jFG5k0/WrQTARPRRoF1wj9kuD6fMPp1LNnN8U6XJHIHErmhFnnxtEPyHFX2xFRT8bEuRMS8t59xWktxxV1KPEn2oWKfgoluJhnlsvtq0kONqspJ4g4ymzfFRFuRz9xKJoBZl87BEcjwV9+oZs14KLpgiFWPWkZduGHycV933w885EPLeeWpbi1FSlKNyoneT7hl5yHeQ8ytSHEKCkqSbFJG4jGU1eCtaYAilj1pB2biR8/Bff8Af327GbFUKqivY55KyqEhVGGhxfZopNie83Pusp6oVS9ewLy3CmEilCGiBfZoqNge42ON/vavmfqaj5vMQbKh4RxaT+7R2edsKUVqKlG5JuT7pKihQUk2INweBxSEz9c0fKJiTdT8I2tR/do7fO/vcxJRHz+hJpKpYhK4uJbCEJUoJB/UCdp5Y1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGXcoj5BQkrlUzQlEXDNlC0pUFAfqJG0crfw7/9k=";
String imgFromFirebase = "https://firebasestorage.googleapis.com/v0/b/thasmai-star-life.appspot.com/o/general_images%2Fistockphoto-1337144146-612x612.jpg?alt=media&token=d9e5ec85-15af-4b48-a96b-4cb5beef82f5";


// profile
const String profile = "Profile";


//Space between textFields
var spaceBetween = SizedBox(height: 16.sp);



// TextField date format
class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    //this fixes backspace bug
    if (oldValue.text.length >= newValue.text.length) {
      return newValue;
    }

    var dateText = _addSeperators(newValue.text, '/');
    return newValue.copyWith(
        text: dateText, selection: updateCursorPosition(dateText));
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
