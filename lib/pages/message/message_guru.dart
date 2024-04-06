import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../controller/socket_provider.dart';

class Message {
  final String content;
  final bool isAdminMessage;
  final String sendTime;

  Message({
    required this.content,
    required this.isAdminMessage,
    required this.sendTime,
  });
}

class ChatScreenGuru extends StatefulWidget {

  @override
  _ChatScreenGuruState createState() => _ChatScreenGuruState();
}

class _ChatScreenGuruState extends State<ChatScreenGuru> {
  bool wave = false;
// final record = FlutterSoundRecorder();

// Future startRecord ()async{
//   await record.startRecorder(toFile: "audio");
// }
//   Future stopRecord ()async{
//   final path = await record.stopRecorder();
//   final audioFile = File(path!);
//   print("record File : $audioFile");
//   }

  final TextEditingController _userMessageController = TextEditingController();

  // final TextEditingController _adminMessageController = TextEditingController();

  final List<Message> _messages = []; // Initialize list of messages

  // Future<void> _fetchMessages() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var cookies = prefs.getString("cookie");
  //   try {
  //     final response = await http.get(Uri.parse("$baseUrl/get-messages"),
  //       headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',
  //         if (cookies != null) 'Cookie': cookies,
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final List<dynamic> responseData = json.decode(response.body);
  //       final List<Message> messages = responseData.map((data) {
  //         return Message(
  //           content: data['message'],
  //           isAdminMessage: data['isAdminMessage'],
  //           sendTime: data['messageTime'],
  //         );
  //       }).toList();
  //       setState(() {
  //         _messages.clear();
  //         _messages.addAll(messages);
  //       });
  //     } else {
  //       throw Exception('Failed to load messages');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // initRecord();
    // Provider.of<SocketProvider>(context, listen: false).socket.connect();
  }

  // Future initRecord ()async{
  //   final status = await Permission.microphone.request();
  //   if(status != PermissionStatus.granted){
  //     throw "Microphone Permission Not Granted";
  //   }
  //   await record.openRecorder();
  // }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    // record.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true, // Start from the bottom of the list
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 8.sp),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 5, top: 5, bottom: 5),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.black,
                        // cursorHeight: 20,
                        controller: _userMessageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                        ),
                        onChanged: (val){
                          setState(() {
                          });
                        },
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: goldShade,
                  child: IconButton(
                    icon: Icon( Icons.send,
                      color: brown,
                    ),
                    onPressed: () {
                      _addUserMessage(_userMessageController.text);
                    },
                  ),)
                // ): GestureDetector(
                //   onLongPress: ()async{
                //     wave = true;
                //     await startRecord() ;
                //     setState(() {
                //     });
                //     print("longpress");
                //   },
                //   onLongPressEnd: (val)async{
                //     wave = false;
                //     await stopRecord();
                //     setState(() {
                //     });
                //     print("longpress canceld");
                //
                //   },
                //   child: CircleAvatar(
                //     radius:wave ? 40:30,
                //     backgroundColor: goldShade,
                //     child: Icon(wave ?Icons.multitrack_audio :Icons.mic,color: darkShade,)
                //   ),
                // ) ,
              ],
            ),
          ),
        ],
      ),
    );
  }



  Future<void> _addUserMessage(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    String formattedTime = DateFormat.jm().format(DateTime.now());
    final newMessage = Message(
      content: text,
      isAdminMessage: false,
      sendTime: formattedTime,
    );
    setState(() {
      _messages.insert(0, newMessage);
    });
    print(_messages.toString());
    _userMessageController.clear();
    // Construct the message payload
    Map<String, dynamic> messagePayload = {
      "id":1,
      "message": text,
      "messageTime": formattedTime,
      "isAdminMessage": "false",
      "message_priority": "Guru",
    };
    Provider.of<SocketProvider>(context, listen: false).sendMessage(messagePayload);

    // Convert the payload to JSON
    // var jsonPayload = jsonEncode(messagePayload);

    // Make the API call
    // try {
    //   final response = await http.post(
    //     Uri.parse("$baseUrl/messages"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       if (cookies != null) 'Cookie': cookies,
    //     },
    //     body: jsonEncode(messagePayload),
    //   );
    //
    //   // Check if the request was successful
    //   if (response.statusCode == 200) {
    //     // If successful, add the message to the UI
    //     final newMessage = Message(
    //       content: text,
    //       isAdminMessage: false,
    //       sendTime: formattedTime,
    //     );
    //     setState(() {
    //       _messages.insert(0, newMessage);
    //     });
    //     _userMessageController
    //         .clear(); // Clear the text field after sending message
    //   } else {
    //     // If request failed, show an error message
    //     throw Exception('Failed to send message');
    //   }
    // } catch (e) {
    //   // Catch any errors and display them
    //   print('Error: $e');
    // }
  }
  // Future<void> _addUserVoiceMessage(String voiceFilePath) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var cookies = prefs.getString("cookie");
  //   String formattedTime = DateFormat.jm().format(DateTime.now());
  //   final newMessage = Message(
  //     content: voiceFilePath, // Assuming voiceFilePath is the path to the recorded voice file
  //     isAdminMessage: false,
  //     sendTime: formattedTime,
  //   );
  //   setState(() {
  //     _messages.insert(0, newMessage);
  //   });
  //   print(_messages.toString());
  //
  //   // Clear the text field after sending message
  //   _userMessageController.clear();
  //
  //   // Construct the message payload
  //   Map<String, dynamic> messagePayload = {
  //     "id": 1,
  //     "message": voiceFilePath,
  //     "messageTime": formattedTime,
  //     "isAdminMessage": "false",
  //     "message_priority": "Guru",
  //     // Add any additional metadata about the voice message if needed
  //   };
  //
  //   // Send the voice message payload
  //   Provider.of<SocketProvider>(context, listen: false).sendMessage(messagePayload);
  //
  //   // You may need to handle uploading the voice file to a server if necessary
  //   // For simplicity, this example assumes that the voiceFilePath is already a valid path to the recorded voice file.
  // }


  Widget _buildMessageBubble(Message message) {
    final isUserMessage = !message.isAdminMessage;
    return Column(
      crossAxisAlignment:
      isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: isUserMessage ? Colors.green.shade50 : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(message.isAdminMessage ? 20.0 : 0),
              topLeft: Radius.circular(isUserMessage ? 20.0 : 0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: isUserMessage ? Colors.black : Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${message.sendTime}',
                style: TextStyle(
                  fontSize: 12,
                  color: isUserMessage ? Colors.grey : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}