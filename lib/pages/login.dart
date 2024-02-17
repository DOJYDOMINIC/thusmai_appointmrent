import 'package:flutter/material.dart';

import '../constant/appointment_constant.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          Image(
              fit: BoxFit.fill,
              image: AssetImage(guruji)),
          Container(
            height: double.infinity,
            width:double.infinity,
             color: Colors.black.withOpacity(.5),
          ),
        ],
      ),
    );
  }
}
