import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/main.dart';
import '../constant/appointment_constant.dart';
import '../controller/appointment_controller.dart';
import 'appointment_list.dart';



class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {


  TextEditingController _phoneRegistered = TextEditingController(text: phone);

  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        // No internet connection
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('No internet connection'),
        ));
      } else {
        // Internet connection established
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
          backgroundColor: Colors.green,
          content: Text('Connected to the internet'),
        ));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage(logo),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: Icon(
              Icons.circle_notifications_outlined,
              color: iconColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle,
              color: iconColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: buttonColor,
              indicatorWeight: 2,
              background: Container(
                color: appbar,
              ),
            ),
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    color: pro.selectedIndex == 0 ? pageBackground : Colors.grey,
                  ),
                  Text(
                    overview,
                    style: TextStyle(
                      color: pro.selectedIndex == 0 ? pageBackground : Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    color: pro.selectedIndex == 1 ? pageBackground : Colors.grey,
                  ),
                  Text(
                    appointment,
                    style: TextStyle(
                      color: pro.selectedIndex == 1 ? pageBackground : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
            views: [
              Container(
                color: pageBackground,
                child: Center(child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _phoneRegistered,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly, // Allow only digits
                          LengthLimitingTextInputFormatter(10), // Limit length to 10 digits
                        ],
                        decoration: InputDecoration(
                          label: Text(
                            registeredPhone,
                            style: TextStyle(color: textFieldOutline),
                          ),
                          labelStyle: TextStyle(
                            color: textFieldOutline,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          suffix: InkWell(
                            onTap: () {
                              _phoneRegistered.clear();
                            },
                            child: Icon(Icons.highlight_off_outlined,color: iconColor,),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textFieldOutline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textFieldOutline),
                          ),
                        ),
                        onChanged: (val){
                          pro.phone = val;
                        },
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: ()async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("phone", pro.phone);
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black, // Customize the shadow color
                            elevation: 4, // Adjust the elevation for the shadow
                            // Customize the background color
                            primary: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16), // Adjust the radius as needed
                            ), // Example color, change it according to your preference
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(
                              //   Icons.check,
                              //   color: buttonText,
                              // ),
                              Text(
                                "Save",
                                style: TextStyle(color: buttonText),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),),
              ),
              if(_phoneRegistered.text.isEmpty || _phoneRegistered.text == "")
              Container(
                color: pageBackground,
                child: Center(
                    child: Text(
                      noAppointmentsBooked,
                      style: GoogleFonts.schoolbell(
                          fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
                    )),
              ),
              if(_phoneRegistered.text.isNotEmpty)
              AppointmentListPage(phone:_phoneRegistered.text,)
            ],
            onChange: (index) {
              pro.selectedIndex = index;
              print(index);
            },
          ),
        ),
      ),
    );
  }

}
