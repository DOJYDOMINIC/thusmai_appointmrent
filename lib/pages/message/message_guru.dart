import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thusmai_appointmrent/constant/appointment_constant.dart';
import 'package:http/http.dart' as http;
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

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userMessageController = TextEditingController();
  final TextEditingController _adminMessageController = TextEditingController();

  final List<Message> _messages = []; // Initialize list of messages

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get-messages"));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<Message> messages = responseData.map((data) {
          return Message(
            content: data['message'],
            isAdminMessage: data['isAdminMessage'],
            sendTime: data['messageTime'],
          );
        }).toList();
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
Timer? _timer;
  @override
  void initState() {
    super.initState();
    _fetchMessages();
  _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _fetchMessages();
    });
  }
  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    padding: const EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      cursorHeight: 20,
                      controller: _userMessageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: buttonColor,
                child: IconButton(
                  icon: Icon(Icons.send,color: appbar,),
                  onPressed: () {
                    _addUserMessage(_userMessageController.text);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addUserMessage(String text) async {
    String formattedTime = DateFormat.jm().format(DateTime.now());
    final newMessage = Message(
      content: text,
      isAdminMessage: false,
      sendTime: formattedTime,
    );
    setState(() {
      _messages.insert(0, newMessage);
    });
    _userMessageController.clear();
    // Construct the message payload
    Map<String, dynamic> messagePayload = {
      "message": text,
      "messageTime": formattedTime,
      "isAdminMessage": false,
      "message_priority": "high",
      "UId": 0,
    };

    // Convert the payload to JSON
    // var jsonPayload = jsonEncode(messagePayload);

    // Make the API call
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/message"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(messagePayload),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // If successful, add the message to the UI
        final newMessage = Message(
          content: text,
          isAdminMessage: false,
          sendTime: formattedTime,
        );
        setState(() {
          _messages.insert(0, newMessage);
        });
        _userMessageController.clear(); // Clear the text field after sending message
      } else {
        // If request failed, show an error message
        throw Exception('Failed to send message');
      }
    } catch (e) {
      // Catch any errors and display them
      print('Error: $e');
    }
  }

  Widget _buildMessageBubble(Message message) {
    final isUserMessage = !message.isAdminMessage;
    return Column(
      crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
