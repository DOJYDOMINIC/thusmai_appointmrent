// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:video_player/video_player.dart';
// // // // //
// // // // // class VideoPlayerScreen extends StatefulWidget {
// // // // //   @override
// // // // //   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// // // // // }
// // // // //
// // // // // class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
// // // // //   late VideoPlayerController _controller;
// // // // //   late VoidCallback _listener;
// // // // //   double _sliderValue = 0.0;
// // // // //
// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _controller = VideoPlayerController.network(
// // // // //       'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
// // // // //     )..initialize().then((_) {
// // // // //       setState(() {});
// // // // //     });
// // // // //
// // // // //     _listener = () {
// // // // //       setState(() {
// // // // //         _sliderValue = _controller.value.position.inMilliseconds.toDouble();
// // // // //       });
// // // // //     };
// // // // //     _controller.addListener(_listener);
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       body: SafeArea(
// // // // //         child: Column(
// // // // //           children: [
// // // // //             IconButton(
// // // // //               onPressed: () {
// // // // //                 _controller.play();
// // // // //               },
// // // // //               icon: Icon(Icons.play_arrow),
// // // // //             ),
// // // // //             IconButton(
// // // // //               onPressed: () {
// // // // //                 _controller.pause();
// // // // //               },
// // // // //               icon: Icon(Icons.pause),
// // // // //             ),
// // // // //             Container(
// // // // //               width: 300, // Adjust as needed
// // // // //               height: 200, // Adjust as needed
// // // // //               child: Stack(
// // // // //                 children: [
// // // // //                   _controller.value.isInitialized
// // // // //                       ? AspectRatio(
// // // // //                     aspectRatio: _controller.value.aspectRatio,
// // // // //                     child: VideoPlayer(_controller),
// // // // //                   )
// // // // //                       : CircularProgressIndicator(),
// // // // //                   Positioned.fill(
// // // // //                     child: Align(
// // // // //                       alignment: Alignment.bottomCenter,
// // // // //                       child: Slider(
// // // // //                         value: _sliderValue,
// // // // //                         min: 0.0,
// // // // //                         max: _controller.value.duration.inMilliseconds.toDouble(),
// // // // //                         onChanged: (value) {
// // // // //                           setState(() {
// // // // //                             _sliderValue = value;
// // // // //                           });
// // // // //                           _controller.seekTo(Duration(milliseconds: value.toInt()));
// // // // //                         },
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //
// // // // //   @override
// // // // //   void dispose() {
// // // // //     _controller.removeListener(_listener);
// // // // //     _controller.dispose();
// // // // //     super.dispose();
// // // // //   }
// // // // // }
// // // //
// // // // import 'package:flutter/cupertino.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:provider/provider.dart';
// // // // import 'package:thusmai_appointmrent/constant/constant.dart';
// // // // import 'package:video_player/video_player.dart';
// // // //
// // // // import '../controller/videoplayer.dart';
// // // //
// // // // class VideoPlayerScreen extends StatelessWidget {
// // // //
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     var state = Provider.of<VideoPlayerState>(context);
// // // //     return Scaffold(
// // // //       body: SafeArea(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             GestureDetector(
// // // //               onTap: (){
// // // //                 state.controller.value.isPlaying ? state.pause(): state.pause();
// // // //               },
// // // //               child: Center(
// // // //                 child: GestureDetector(
// // // //                   onTap: (){
// // // //                     state.changeValueAfterDelay();
// // // //                   },
// // // //                   child: Container(
// // // //                     width: 300, // Adjust as needed
// // // //                     height: 170, // Adjust as needed
// // // //                     child: Stack(
// // // //                       children: [
// // // //                         state.controller.value.isInitialized
// // // //                             ? AspectRatio(
// // // //                                 aspectRatio: state.controller.value.aspectRatio,
// // // //                                 child: VideoPlayer(state.controller),
// // // //                               )
// // // //                             : CircularProgressIndicator(),
// // // //                         Positioned.fill(
// // // //                           child: Container(
// // // //                             color: state.controller.value.isPlaying ? null:Colors.black.withOpacity(.3),
// // // //                             child: Align(
// // // //                               alignment: Alignment.bottomCenter,
// // // //                               child: Column(
// // // //                                 mainAxisSize: MainAxisSize.min,
// // // //                                 children: [
// // // //                               AnimatedOpacity(
// // // //                               opacity: state.controller.value.isPlaying ? 0.0 : 1.0,
// // // //                                 duration: Duration(seconds: 3), // Adjust the duration as needed
// // // //                                 child: Column(
// // // //                                   children: [
// // // //                                     CircleAvatar(
// // // //                                       backgroundColor: Colors.black.withOpacity(.3),
// // // //                                       radius: 28,
// // // //                                       child: IconButton(
// // // //                                         enableFeedback: false,
// // // //                                         onPressed: () {
// // // //                                           state.controller.value.isPlaying ? state.pause() : state.play();},
// // // //                                         icon: Icon(
// // // //                                           state.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
// // // //                                           size: 30,
// // // //                                           color: Colors.white,
// // // //                                         ),
// // // //                                       ),
// // // //                                     ),
// // // //                                     Slider(
// // // //                                       activeColor: goldShade,
// // // //                                       value: state.sliderValue,
// // // //                                       min: 0.0,
// // // //                                       max: state.controller.value.duration.inMilliseconds.toDouble(),
// // // //                                       onChanged: (value) {
// // // //                                         state.seekTo(value);
// // // //                                       },
// // // //                                     ),
// // // //                                   ],
// // // //                                 ),
// // // //                               ),
// // // //                                 Container(
// // // //                                     color: Colors.black.withOpacity(.3),
// // // //                                     child: Padding(
// // // //                                       padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
// // // //                                       child: Row(
// // // //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                                         children: [
// // // //                                           Text(state.formatDuration(
// // // //                                               state.controller.value.position),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
// // // //                                           Text(state.formatDuration(
// // // //                                               state.controller.value.duration),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
// // // //                                         ],
// // // //                                       ),
// // // //                                     ),
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // import 'package:flutter/material.dart';
// // //
// // // class profilePage extends StatefulWidget {
// // //   @override
// // //   profilePageState createState() => profilePageState();
// // // }
// // //
// // // class profilePageState extends State<profilePage> {
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return DefaultTabController(
// // //       length: 2,
// // //       child: Scaffold(
// // //         appBar: AppBar(
// // //           title: Text(
// // //             'My Profile',
// // //           ),
// // //           centerTitle: true,
// // //           backgroundColor: Colors.grey[700]?.withOpacity(0.4),
// // //           elevation: 0,
// // //           // give the app bar rounded corners
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.only(
// // //               bottomLeft: Radius.circular(20.0),
// // //               bottomRight: Radius.circular(20.0),
// // //             ),
// // //           ),
// // //           leading: Icon(
// // //             Icons.menu,
// // //           ),
// // //         ),
// // //         body: Column(
// // //           children: <Widget>[
// // //             // construct the profile details widget here
// // //             SizedBox(
// // //               height: 180,
// // //               child: Center(
// // //                 child: Text(
// // //                   'Profile Details Goes here',
// // //                 ),
// // //               ),
// // //             ),
// // //
// // //             // the tab bar with two items
// // //             SizedBox(
// // //               height: 50,
// // //               child: AppBar(
// // //                 bottom: TabBar(
// // //                   tabs: [
// // //                     Tab(
// // //                       icon: Icon(Icons.directions_bike),
// // //                     ),
// // //                     Tab(
// // //                       icon: Icon(
// // //                         Icons.directions_car,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //
// // //             // create widgets for each tab bar here
// // //             Expanded(
// // //               child: TabBarView(
// // //                 children: [
// // //                   // first tab bar view widget
// // //                   Container(
// // //                     color: Colors.red,
// // //                     child: Center(
// // //                       child: Text(
// // //                         'Bike',
// // //                       ),
// // //                     ),
// // //                   ),
// // //
// // //                   // second tab bar viiew widget
// // //                   Container(
// // //                     color: Colors.pink,
// // //                     child: Center(
// // //                       child: Text(
// // //                         'Car',
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// // import 'package:flutter/material.dart';
// // class MyHomePage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Flutter Demo'),
// //       ),
// //       body: Center(
// //         child: Container(
// //           width: 500,
// //           height: 500,
// //           child: Row(
// //             children: [
// //               Container(
// //                 width: 100,
// //                 height: 100,
// //                 child: Image.asset('path/to/image.jpg'),
// //               ),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'Title',
// //                       style: TextStyle(
// //                         fontSize: 24,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: 16),
// //                     Text(
// //                       'Description',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_bubble/chat_bubble.dart';
//
//
// class MainScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
//         child: ListView(
//           children: <Widget>[
//             getTitleText("Example 1"),
//             getSenderView(
//                 ChatBubbleClipper1(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper1(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 2"),
//             getSenderView(
//                 ChatBubbleClipper2(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper2(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 3"),
//             getSenderView(
//                 ChatBubbleClipper3(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper3(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 4"),
//             getSenderView(
//                 ChatBubbleClipper4(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper4(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 5"),
//             getSenderView(
//                 ChatBubbleClipper5(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper5(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 6"),
//             getSenderView(
//                 ChatBubbleClipper6(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper6(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 7"),
//             getSenderView(
//                 ChatBubbleClipper7(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper7(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 8"),
//             getSenderView(
//                 ChatBubbleClipper8(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper8(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 9"),
//             getSenderView(
//                 ChatBubbleClipper9(type: BubbleType.sendBubble), context),
//             getReceiverView(
//                 ChatBubbleClipper9(type: BubbleType.receiverBubble), context),
//             SizedBox(
//               height: 30,
//             ),
//             getTitleText("Example 10"),
//             getSenderView(
//                 ChatBubbleClipper10(type: BubbleType.sendBubble), context),
//             Padding(
//               padding: EdgeInsets.only(bottom: 10),
//               child: getReceiverView(
//                   ChatBubbleClipper10(type: BubbleType.receiverBubble), context),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   getTitleText(String title) => Text(
//     title,
//     style: TextStyle(
//       color: Colors.black,
//       fontSize: 20,
//     ),
//   );
//
//   getSenderView(CustomClipper clipper, BuildContext context) => ChatBubble(
//     clipper: clipper,
//     alignment: Alignment.topRight,
//     margin: EdgeInsets.only(top: 20),
//     backGroundColor: Colors.blue,
//     child: Container(
//       constraints: BoxConstraints(
//         maxWidth: MediaQuery.of(context).size.width * 0.7,
//       ),
//       child: Text(
//         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
//         style: TextStyle(color: Colors.white),
//       ),
//     ),
//   );
//
//   getReceiverView(CustomClipper clipper, BuildContext context) => ChatBubble(
//     clipper: clipper,
//     backGroundColor: Color(0xffE7E7ED),
//     margin: EdgeInsets.only(top: 20),
//     child: Container(
//       constraints: BoxConstraints(
//         maxWidth: MediaQuery.of(context).size.width * 0.7,
//       ),
//       child: Text(
//         "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
//         style: TextStyle(color: Colors.black),
//       ),
//     ),
//   );
// }



import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('BottomNavigationBar Sample'),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 1: Business',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    Text(
      'Index 2: School',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];
}