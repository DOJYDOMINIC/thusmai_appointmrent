import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';

class PopupWidget extends StatefulWidget {
  const PopupWidget({super.key, required this.heading, required this.subHeading, required this.amount, required this.buttonOneText, required this.buttonTwoText, required this.onPressTwo, required this.onPressOne, required this.icon, required this.buttonColorOne, required this.buttonColorTwo});
  final String heading;
  final String subHeading;
  final String amount;
  final String buttonOneText;
  final String buttonTwoText;
  final IconData icon;
  final Color buttonColorOne;
  final Color buttonColorTwo;
  final void Function() onPressOne;
  final void Function() onPressTwo;


  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shadeOne,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                widget.heading,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(widget.subHeading,textAlign: TextAlign.center),
              Icon(
                widget.icon,
                size: 100.sp,
              ),
              Text(
                widget.amount,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            // width: 128.w,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(widget.buttonColorOne)),
                onPressed: widget.onPressOne,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.buttonOneText,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,),
                    ),
                  ],
                )),
          ),
          SizedBox(
            // width: 128.w,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.black, width: .5), // Adding border
                      ),
                    ),
                    elevation: WidgetStateProperty.all(2),
                    backgroundColor: WidgetStateProperty.all(widget.buttonColorTwo)),
                onPressed: widget.onPressTwo,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.buttonTwoText,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold,),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
