import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Const Api link

const baseUrl = "https://thasmai.tstsvc.in/api/v1/User";

// const  baseUrl = "http://192.168.1.78:5000/api/v1/User";

// images
const String alertCompleted = "assets/images/Alert Completed.png";
const String alertDeleted = "assets/images/Alert Delete.png";
const String logo = "assets/images/Tasmai logo.png";
const String error = "assets/images/error.svg";
const String guruji = "assets/images/guruji.png";

// appbarColor
Color pageBackground = Color.fromRGBO(255, 251, 255, 1);
Color textFieldOutline = Color.fromRGBO(129, 117, 103, 1);
Color tabInactive = Color.fromRGBO(234, 225, 217, 1);

Color iconColor = Color.fromRGBO(79, 69, 57, 1);
Color iconContainer = Color.fromRGBO(86, 68, 42, 1);

Color placeHolder = Color.fromRGBO(79, 69, 57, 1);
Color buttonText = Color.fromRGBO(68, 43, 0, 1);
Color dividerLine = Color.fromRGBO(240, 224, 207, 1);

Color subtext = Color.fromRGBO(79, 69, 57, 1);

Color appbar = Color.fromRGBO(31, 27, 22, 1);
Color heading = Color.fromRGBO(31, 27, 22, 1);
Color inputText = Color.fromRGBO(31, 27, 22, 1);

Color bottomNavLabel = Color.fromRGBO(234, 225, 217, 1);
Color buttonColor = Color.fromRGBO(255, 185, 76, 1);

Color navIcon = Color.fromRGBO(250, 222, 188, 1);
Color bottomNavLabelUnSelected = Color.fromRGBO(211, 196, 180, 1);
Color floatingAction = Color.fromRGBO(221,194,161, 1);



// Text box when Clicked/Selected
Color onSelectTextFieldOutline = Color.fromRGBO(31, 27, 22, 1);
Color textContainer = Color.fromRGBO(240, 224, 207, 1);

// Delete
Color red = Color.fromRGBO(186,26,26, 1);
// profile

Color profileBackground = Color.fromRGBO(234,225,217, 1);
Color rewardRefer = Color.fromRGBO(250,222,188, 1);

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
const String appointmentForOther = "Appointment booked other than the user";

// default image
String defaultImage = "/9j/4AAQSkZJRgABAQACWAJYAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wgALCADIAMgBAREA/8QAHAABAAIDAQEBAAAAAAAAAAAAAAYIAwUHAgEE/9oACAEBAAAAAO/gAAAAAAAAAAAAAAAAAAAAAAAAAD8PDIfMO5/uAAA81AgJPrf+gAAQumgXLmgAAIJTsLiTsAAGGmEVJVc/MAABoq8Q+YWH3oAAB8wZ/oAACH8I53rtj0Tu8wAADjdasIZrK9kAAOfVE8Ae7d9BAAU4g4BOLjgAaWjnkA+3k3QAIvXIALGygAAAAAAAAAAAAAAAAAAAAAAAAAH/xAA5EAABAgQCBgYIBgMAAAAAAAABAgMEBQYRAAcSFyExUWETQFSBlKEUFSAwQVJxsQgWImJwwXOR0f/aAAgBAQABPwD+IJvOICRS52YTKKbhoVoXU4s27hxPLFTfiLWHls03LEFsGwiYu91cwgbu84191z0un6VB6PyejJt/3FM/iLWXkM1JLEBsmxiYS908yg7+44lE4gJ7LmphLYpuJhXRdLiDfuPA8uqOOJabU4tQShIKlKO4AYzSzAia0qJ1DTqhKYVZRDNA7FW2aZ5n7exlbmBE0XUTSHXVGUxSwiJaJ2Jvs0xzH2w24h1tLiFBSFAKSobiD1PNmaOSjLOcxDSilxbQZSR8NMhP2J9rKaaOTfLOTRDqipxDRZUT8dAlI8gOp5xQC5hldOENglTSEvWHBKgT5X9rJ2AXL8rpOhwFKnUKeseClEjyt1OKhmoyFdhn0BbLqChaT8UkWIxmBRsXRVTPwDyFGFUSuFetscbO7vG4+xl/RsXWtTMQDKFCFSQuKetsbbG/vO4YhYZqDhWoZhIQ00gIQkbgkCwHVKqpKUVhKVS+bQ4Wje24nYtpXFJ+GKmyBqWWPLckym5pC70gKCHQOaTsPccas616Xo/y1MNL/Fs/3uxTOQNSzN5Dk5U3K4XeoFQW6RySNg7zilaSlFHylMvlMOEI3uOK2rdVxUfj1ZSkoF1EAcSbY9OhL29KYvw6QYSpKxdJBHEG/VayzJp+imimPieljSLohGLKcP1+UfXFSZ+VRNVrblQalUMdg6Mabluaj/QxH1HOpo4Vx02jYhR39I+o+V8dM5e/SLvx0jiAqOdytwOQM2jYdQ3dG+oeV8U3n5VEqWhuahqaww2HpBoOW5KH9jFG5k0/WrQTARPRRoF1wj9kuD6fMPp1LNnN8U6XJHIHErmhFnnxtEPyHFX2xFRT8bEuRMS8t59xWktxxV1KPEn2oWKfgoluJhnlsvtq0kONqspJ4g4ymzfFRFuRz9xKJoBZl87BEcjwV9+oZs14KLpgiFWPWkZduGHycV933w885EPLeeWpbi1FSlKNyoneT7hl5yHeQ8ytSHEKCkqSbFJG4jGU1eCtaYAilj1pB2biR8/Bff8Af327GbFUKqivY55KyqEhVGGhxfZopNie83Pusp6oVS9ewLy3CmEilCGiBfZoqNge42ON/vavmfqaj5vMQbKh4RxaT+7R2edsKUVqKlG5JuT7pKihQUk2INweBxSEz9c0fKJiTdT8I2tR/do7fO/vcxJRHz+hJpKpYhK4uJbCEJUoJB/UCdp5Y1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGXcoj5BQkrlUzQlEXDNlC0pUFAfqJG0crfw7/9k=";


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




Map<String,dynamic> tAndC =
{
  "content": """The following are some essential things anyone who visit the Ashram to see and stay with Guruji should be aware of.

No entry to Guruji's residence without prior permission. If you have any queries you can call +91 90082 90027.If not, consult Lakshman.

If at all possible, anybody with fever, cough, cold, or any other infectious disease should postpone their visit to the Ashram until a later day.

Intoxicants and foreign food are prohibited from the ashram, apart from fruits and veggies.

4:30 in the morning There will be tea in the kitchen.

You have to sit under the open sky at 5 am to listen to the classes.

Exercise from 6 am to 6:30 am.

Meditating before to 7 am. Special care should be taken to leave the mobile room at the top for meditation and exercise.

Breakfast after eight in the morning. Sleeping during the day is not permitted; ashrama seva is permitted in the later hours.

Lunch at 1 pm and tea at 4 pm.

It is forbidden to leave the ashram and eat after 6 o'clock in the evening.

Unnecessary use of mobile phone, staying in the room all the time etc. are against ashram rules.

Every person who comes here should have the full conviction that they are coming to see the Guru to gain knowledge. The knowledge you gain will be with you as a guide in each of your future lives.Therefore, no one should expect any luxuries in the ashram. Those who come to meet the Guru should try to live seriously, seeing any work they see as a service to the Guru. It is requested that you try to use every moment here in a way that is beneficial to you and those who are with you.

If you find any equipment damaged beyond use while entering the room, you should immediately inform the ashram.

When we use the room, the premises, the toilet, the bathroom bed sheet, etc., clean and wash ourselves, the ego in us will disappear. You will understand how those who have gone before you have used it, and the person who comes after you will be lucky to use clean and tidy rooms, surroundings and things. "It can send a great message to others."

Water and electricity are precious and precious, use only when needed. Take special care to switch off lights, fans, heaters, etc. in and around the ashram rooms when needed.

Special care should be taken to close windows and doors while leaving the room. Monkeys here may be attracted to things like mobiles, purses, gold, etc.

The ashram residents need just inform Lakshman if they wish to see Guruji.

Those who come to see and talk to Guruji should leave their mobiles in the room.

Everyone should understand that the experiences we get are according to the actions we do.

It is good to carry blankets, pillowcases etc. for your own use. If you leave the used cloth and mat material unwashed and go away, it will be considered as Dakshina by you to the Guru.

Minors / women / sick / incapacitated are not allowed to stay alone.

Please be careful not to bring any specially prepared food items or other gifts for Guruji and his family. Those who are interested in donating anything to the Ashram can hand it over to Lakshman"""
};
