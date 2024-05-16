import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';
import '../../controller/meditationController.dart';
import '../../controller/message_controller.dart';


class PrivateMessage extends StatefulWidget {
  const PrivateMessage({super.key});

  @override
  State<PrivateMessage> createState() => _PrivateMessageState();
}

class _PrivateMessageState extends State<PrivateMessage> {

  TextEditingController _userMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<MessageController>(context, listen: false).privateMessage("1");
  }
  @override
  Widget build(BuildContext context) {
    var meditation = Provider.of<MeditationController>(context);
    var messageController = Provider.of<MessageController>(context);
    return Scaffold(
      body: Column(
          children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  messageController.privateSubtract();
                }, icon: Icon(Icons.chevron_left)),
            IconButton(
                onPressed: () {
                  messageController.privateAdd(messageController.privatePageNo-1);
                }, icon: Icon(Icons.chevron_right)),
          ],
        ),
        Expanded(
          child:
          ListView.builder(
            reverse: true,
            itemCount: messageController.privateMessages.length,
            itemBuilder: (context, index) {
              return  getSenderView(
                  ChatBubbleClipper10(type: BubbleType.sendBubble), context,"${messageController.privateMessages[index].message}");
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
                    border: Border.all(color: Colors.black, width: .5),
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
                    padding: const EdgeInsets.only(left: 20, right: 5, top: 5, bottom: 5),
                    child: Container(
                      child: new ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 130.h,
                        ),
                        child: new Scrollbar(
                          child: new SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: new TextField(
                              maxLines: null,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.black,
                        controller: _userMessageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                        ),
                        // onChanged: (val) {},
                      ),
                    ),
    )))
                  ),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: goldShade,
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: brown,
                  ),
                  onPressed: () async{
                    String messageTDate = DateFormat('MMMM dd').format(DateTime.now());
                    String formattedTime = DateFormat('h:mm a').format(DateTime.now());
                    if(_userMessageController.text.isNotEmpty){
                     await meditation.meditationNote( _userMessageController.text,"private", formattedTime,messageTDate);
                    }
                    _userMessageController.clear();
                   await Provider.of<MessageController>(context, listen: false).privateMessage("1");
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

getSenderView(CustomClipper clipper, BuildContext context,String note) => ChatBubble(
  clipper: clipper,
  alignment: Alignment.topRight,
  margin: EdgeInsets.only(top: 20),
  backGroundColor: Colors.grey.shade300,
  child: Container(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.7,
    ),
    child: Text(
      note,
      style: TextStyle(color: Colors.black),
    ),
  ),
);

getReceiverView(CustomClipper clipper, BuildContext context) => ChatBubble(
  clipper: clipper,
  backGroundColor: Color(0xffE7E7ED),
  margin: EdgeInsets.only(top: 20),
  child: Container(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.7,
    ),
    child: Text(
      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
      style: TextStyle(color: Colors.black),
    ),
  ),
);