import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/controller/message_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/constant.dart';


class GuruMessage extends StatefulWidget {
  const GuruMessage({super.key});

  @override
  State<GuruMessage> createState() => _GuruMessageState();
}

class _GuruMessageState extends State<GuruMessage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MessageController>(context, listen: false).guruMessage("1");
  }

  @override
  Widget build(BuildContext context) {
    var messageController = Provider.of<MessageController>(context);


    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messageController.guruMessages.length,
              itemBuilder: (context, index) {
                List<String>? splitDatetime = messageController.guruMessages[index].messageTime?.split(" at ");

                // Extract date and time components
                String? datePart = splitDatetime?[0]??"";
                String? timePart = splitDatetime?[1]??"";
                return  getSenderView(ChatBubbleClipper10(type: BubbleType.sendBubble), context,"${messageController.guruMessages[index].message}",timePart,"",datePart);
              },
            ),
          ),
          SizedBox(height: 8.sp,),
          Container(
            color: Colors.white,
            height: 96.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(
                  flex: 4,
                ),
                Text("${messageController.guruIndex.toString()} of ${messageController.guruMessagesPageNo.toString()}"),
                Spacer(
                  flex: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            messageController.guruSubtract();
                          }, icon: Icon(Icons.chevron_left)),
                      SizedBox(width: 20,),
                      IconButton(
                          onPressed: () {
                            messageController.guruAdd(messageController.guruMessagesPageNo - 1);
                          }, icon: Icon(Icons.chevron_right)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// getSenderView(CustomClipper clipper, BuildContext context, String note) =>
//     ChatBubble(
//       clipper: clipper,
//       alignment: Alignment.topRight,
//       margin: EdgeInsets.only(top: 20),
//       backGroundColor: Colors.grey.shade300,
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.7,
//         ),
//         child: Text(
//           note,
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//     );
getSenderView(CustomClipper clipper, BuildContext context, String note,String time,
    String messageName, String messageDate) =>
    ChatBubble(
      clipper: clipper,
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 20),
      backGroundColor: Colors.grey.shade300,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   width:150.w,
                  //   child: Text(
                  //     messageName,
                  //     style: TextStyle(
                  //         fontSize: 16.sp,
                  //         color: darkShade,
                  //         fontWeight: FontWeight.w500),
                  //   ),
                  // ),

                  Text(
                    messageDate,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: darkShade,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Linkify(
                onOpen: (link) async {
                  // This function will be called when a link is clicked
                  if (await canLaunchUrl(Uri.parse(link.url))) {
                    await launchUrl(Uri.parse(link.url));
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: note,
                style: TextStyle(color: Colors.black,fontSize: 16.sp),
                linkStyle: TextStyle(color: Colors.blue),
                // Optional, set to false to disable @mentions
                // humanize: false,
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(time,style: TextStyle(fontSize: 10.sp),))
          ],
        ),
      ),
    );