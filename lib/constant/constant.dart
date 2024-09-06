import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Const Urls
const url = "https://starlife.co.in";
const coreUrl = "$url/api/v1";
const baseUrl = "$coreUrl/User";
const  adminBaseUrl = "$coreUrl/admin";
const  paymentBaseUrl = "$coreUrl/payment";
const  superAdmin = coreUrl;

// Urls Launching
final Uri registerUrl = Uri.parse(url);
final Uri privacyPolicy = Uri.parse("$url/privacyPolicy");

// const baseUrl = "http://192.168.1.53:5000/api/v1/User";
// const  adminBaseUrl = "http://192.168.1.53:5000/api/v1/admin";
// const  paymentBaseUrl = "http://192.168.1.53:5000/api/v1/payment";
// const  superAdmin = "http://192.168.1.53:5000/api/v1";



final String audioUrl = "https://firebasestorage.googleapis.com/v0/b/thasmai-star-life.appspot.com/o/general_images%2FY2meta.app%20-%20Shivashtakam%20Thasmai%20Namah%20Paramakarana%20written%20by%20Aadi%20Shankaracharya%20(320%20kbps).mp3?alt=media&token=845e902d-dccf-46fb-9a97-1013a6987c04";
// final String audioUrl = "assets/audio/thasmainamah.mp3";





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
const String deleteForever = "assets/svgImage/Frame 2608397.svg";
const String currencyRupee =  "assets/svgImage/currency_rupee.svg";



// New
Color shadeOne = const Color.fromRGBO(255, 251, 255, 1);

Color videoBox = const Color.fromRGBO(255, 248, 244, 1);

Color shadeTwo = const Color.fromRGBO(234, 225, 217, 1);

Color shadeThree = const Color.fromRGBO(234,225,217, 1);

Color shadeFour = const Color.fromRGBO(240, 224, 207, 1);

Color shadeFive = const Color.fromRGBO(211, 196, 180, 1);

Color shadeSix = const Color.fromRGBO(250,222,188, 1);

Color shadeSeven = const Color.fromRGBO(255,221,178, 1);

Color shadeEight = const Color.fromRGBO(221,194,161, 1);

Color shadeNine = const Color.fromRGBO(129, 117, 103, 1);

Color shadeTen = const Color.fromRGBO(79, 69, 57, 1);

Color eventSubText = const Color.fromRGBO(79,69,57, 1);

Color shadeEleven = const Color.fromRGBO(86, 68, 42, 1);

Color brown = const Color.fromRGBO(68, 43, 0, 1);

Color darkShade = const Color.fromRGBO(31, 27, 22, 1);

Color goldShade = const Color.fromRGBO(255, 185, 76, 1);
Color lightRed = const Color.fromRGBO(255,180,171, 1);
Color midRed = const Color.fromRGBO(105,0,5, 1);

Color red = const Color.fromRGBO(186,26,26, 1);

Color ringColor = const Color.fromRGBO(156,143,128, 1);
Color greenColor = const Color.fromRGBO(183,206,162, 1);
Color profileTextFieldDillColor = const Color.fromRGBO(240,224,207, 1);
Color meditationLogGreen = const Color.fromRGBO(81,100,64, 1);
Color meditationLogRed = const Color.fromRGBO(186,26,26, 1);



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
const String logout = "Logout";
const String privacyPolicyTxt = "Privacy Policy";
const String deleteAccount = "Delete Account";
const String feedback = "Feedback";
const String resetPassword = "Reset password";
const String bankInfo = "Bank info";
const String personalInfo = "Personal info";
const String deleteQus = "Are you sure that you need to \nDelete The Account ?";
const String deleteDeclaration = "By deleting your account, you will permanently lose access to all data and content associated with it, including:";


const String appointmentDateValidation = "Please select appointment date";
const String meditation = "Meditation";
const String videos = "Videos";
const String home = "Home";
const String payment = "Payments";
const String pay = "Pay";
const String dakshina = "Dakshina";
const String enable = "Please pay the Meditation fee to enable access to Meditation.";
const String enableMessage = "Please pay the platform maintenance fee of 500 to enable messaging.";
const String name = "Name";
const String age = "Age";
const String pickupValidation = 'Please enter a Valid Pickup Point';
const String termsAndCondition = "Terms and conditions ";
const String declaration = "I hereby acknowledge that I have read and accept the ";
const String declarationBalance = "governing appointments.";
const String phoneRequired = 'Phone number is required';
const String validNumber = 'Enter a valid phone number';
const String failedCreateOrder = 'Failed to create order';


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
const String zoomVideoDescription = "Ready to find your inner peace? Your meditation session is about to begin! Join our Zoom meeting now for a tranquil journey:";
const String zoomVideoDescription2 = "Join in developing mindfulness.I'll see you there!";





// default image
String defaultImage = "/9j/4AAQSkZJRgABAQACWAJYAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wgALCADIAMgBAREA/8QAHAABAAIDAQEBAAAAAAAAAAAAAAYIAwUHAgEE/9oACAEBAAAAAO/gAAAAAAAAAAAAAAAAAAAAAAAAAD8PDIfMO5/uAAA81AgJPrf+gAAQumgXLmgAAIJTsLiTsAAGGmEVJVc/MAABoq8Q+YWH3oAAB8wZ/oAACH8I53rtj0Tu8wAADjdasIZrK9kAAOfVE8Ae7d9BAAU4g4BOLjgAaWjnkA+3k3QAIvXIALGygAAAAAAAAAAAAAAAAAAAAAAAAAH/xAA5EAABAgQCBgYIBgMAAAAAAAABAgMEBQYRAAcSFyExUWETQFSBlKEUFSAwQVJxsQgWImJwwXOR0f/aAAgBAQABPwD+IJvOICRS52YTKKbhoVoXU4s27hxPLFTfiLWHls03LEFsGwiYu91cwgbu84191z0un6VB6PyejJt/3FM/iLWXkM1JLEBsmxiYS908yg7+44lE4gJ7LmphLYpuJhXRdLiDfuPA8uqOOJabU4tQShIKlKO4AYzSzAia0qJ1DTqhKYVZRDNA7FW2aZ5n7exlbmBE0XUTSHXVGUxSwiJaJ2Jvs0xzH2w24h1tLiFBSFAKSobiD1PNmaOSjLOcxDSilxbQZSR8NMhP2J9rKaaOTfLOTRDqipxDRZUT8dAlI8gOp5xQC5hldOENglTSEvWHBKgT5X9rJ2AXL8rpOhwFKnUKeseClEjyt1OKhmoyFdhn0BbLqChaT8UkWIxmBRsXRVTPwDyFGFUSuFetscbO7vG4+xl/RsXWtTMQDKFCFSQuKetsbbG/vO4YhYZqDhWoZhIQ00gIQkbgkCwHVKqpKUVhKVS+bQ4Wje24nYtpXFJ+GKmyBqWWPLckym5pC70gKCHQOaTsPccas616Xo/y1MNL/Fs/3uxTOQNSzN5Dk5U3K4XeoFQW6RySNg7zilaSlFHylMvlMOEI3uOK2rdVxUfj1ZSkoF1EAcSbY9OhL29KYvw6QYSpKxdJBHEG/VayzJp+imimPieljSLohGLKcP1+UfXFSZ+VRNVrblQalUMdg6Mabluaj/QxH1HOpo4Vx02jYhR39I+o+V8dM5e/SLvx0jiAqOdytwOQM2jYdQ3dG+oeV8U3n5VEqWhuahqaww2HpBoOW5KH9jFG5k0/WrQTARPRRoF1wj9kuD6fMPp1LNnN8U6XJHIHErmhFnnxtEPyHFX2xFRT8bEuRMS8t59xWktxxV1KPEn2oWKfgoluJhnlsvtq0kONqspJ4g4ymzfFRFuRz9xKJoBZl87BEcjwV9+oZs14KLpgiFWPWkZduGHycV933w885EPLeeWpbi1FSlKNyoneT7hl5yHeQ8ytSHEKCkqSbFJG4jGU1eCtaYAilj1pB2biR8/Bff8Af327GbFUKqivY55KyqEhVGGhxfZopNie83Pusp6oVS9ewLy3CmEilCGiBfZoqNge42ON/vavmfqaj5vMQbKh4RxaT+7R2edsKUVqKlG5JuT7pKihQUk2INweBxSEz9c0fKJiTdT8I2tR/do7fO/vcxJRHz+hJpKpYhK4uJbCEJUoJB/UCdp5Y1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGXcoj5BQkrlUzQlEXDNlC0pUFAfqJG0crfw7/9k=";
String imgFromFirebase = "https://firebasestorage.googleapis.com/v0/b/thasmai-star-life.appspot.com/o/general_images%2Fistockphoto-1337144146-612x612.jpg?alt=media&token=d9e5ec85-15af-4b48-a96b-4cb5beef82f5";
String noImage = "https://firebasestorage.googleapis.com/v0/b/thasmai-star-life.appspot.com/o/general_images%2Fpngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg?alt=media&token=708c7abf-84da-4f07-8fa6-a2a82f790cdc";

// Url

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
