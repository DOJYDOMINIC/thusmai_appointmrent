import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/controller/message_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/general_message_model.dart';

class GeneralMessage extends StatefulWidget {
  const GeneralMessage({super.key});

  @override
  State<GeneralMessage> createState() => _GeneralMessageState();
}

class _GeneralMessageState extends State<GeneralMessage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MessageController>(context, listen: false).generalMessage("1");
  }

  @override
  Widget build(BuildContext context) {
    var messageController = Provider.of<MessageController>(context);
    return Scaffold(
      backgroundColor: shadeOne,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messageController.globalMessages.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (messageController
                            .globalMessages[index].isAdminMessage ==
                        false)
                      getSenderView(ChatBubbleClipper10(type: BubbleType.sendBubble), context, "${messageController.globalMessages[index].message}", "${messageController.globalMessages[index].messageTime}", "${messageController.globalMessages[index].userName}","${messageController.globalMessages[index].messageDate}"),
                    if (messageController.globalMessages[index].isAdminMessage)
                      getReceiverView(ChatBubbleClipper10(type: BubbleType.receiverBubble), context, "${messageController.globalMessages[index].message}","${messageController.globalMessages[index].userName}", "${messageController.globalMessages[index].messageDate}"),
                  ],
                );

                //   Column(children: [
                //   Padding(
                //     padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                //     child: Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               "${messageController.globalMessages[index].userName}",
                //               style:
                //                   TextStyle(fontSize: 14, color:messageController.globalMessages[index].isAdminMessage?Colors.red : darkShade,fontWeight: FontWeight.w500),
                //             ),
                //             Text(
                //                 "${messageController.globalMessages[index].messageDate}",
                //             style:
                //             TextStyle(fontSize: 12, color: darkShade,fontWeight: FontWeight.w400),)
                //           ],
                //         ),
                //         SizedBox(
                //           height: 8.h,
                //         ),
                //         Align(
                //             alignment: Alignment.centerLeft,
                //             child: Text(
                //               "${messageController.globalMessages[index].message}",
                //               style:
                //                   TextStyle(fontSize: 12, color: darkShade),
                //             )),
                //       ],
                //     ),
                //   ),
                //   Divider(),
                // ]);
              },
            ),
            // FutureBuilder(
            //   future: messageController.generalMessage(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: CircularProgressIndicator(), // Loading indicator
            //       );
            //     } else if (snapshot.hasError) {
            //       return Center(
            //         child: Text('Error: ${snapshot.error}'), // Error message
            //       );
            //     } else {
            //       return ListView.builder(
            //         itemCount: messageController.globalMessages.length,
            //         itemBuilder: (context, index) {
            //         var data =  messageController.globalMessages[index];
            //           return Column(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            //                 child: Column(
            //                   children: [
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text(
            //                           "${data.message}",
            //                           style: TextStyle(fontSize: 14, color: darkShade,fontWeight: FontWeight.w400,height: 1.6),
            //                         ),
            //                         Text("${data.messageTime}",style: TextStyle(fontSize: 12, color: darkShade),)
            //                       ],
            //                     ),
            //                     SizedBox(
            //                       height: 4.h,
            //                     ),
            //                     Align(
            //                       alignment: Alignment.centerLeft,
            //                       child: Text(
            //                         "${data.message}",
            //                         style: TextStyle(fontSize: 12, color: darkShade),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               Divider(),
            //             ],
            //           );
            //         },
            //       );
            //     }
            //   },
            // )
          ),
          Container(
            color: Colors.white,
            height: 96.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(
                  flex: 4,
                ),
                Text(
                    "${messageController.pageIndex.toString()} of ${messageController.totalPage.toString()}"),
                Spacer(
                  flex: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            messageController.subtract();
                          },
                          icon: Icon(Icons.chevron_left)),
                      SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            messageController.addCount(messageController.totalPage - 1);
                          },
                          icon: Icon(Icons.chevron_right)),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    messageName,
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: darkShade,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    messageDate,
                    style: TextStyle(
                        fontSize: 13.sp,
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

getReceiverView(CustomClipper clipper, BuildContext context, String text,
    String messageName, String messageDate) =>
    ChatBubble(
      clipper: clipper,
      backGroundColor: Color(0xffE7E7ED),
      margin: EdgeInsets.only(top: 20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    messageName,
                    style: TextStyle(
                        fontSize: 14,
                        color: darkShade,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    messageDate,
                    style: TextStyle(
                        fontSize: 12,
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
                text: text,
                style: TextStyle(color: Colors.black,fontSize: 16.sp),
                linkStyle: TextStyle(color: Colors.blue),
                // Optional, set to false to disable @mentions
              ),
            ),
          ],
        ),
      ),
    );