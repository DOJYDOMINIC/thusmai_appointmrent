import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/controller/message_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';

class GeneralMessage extends StatefulWidget {
  const GeneralMessage({super.key});

  @override
  State<GeneralMessage> createState() => _GeneralMessageState();
}

class _GeneralMessageState extends State<GeneralMessage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
    Provider.of<MessageController>(context, listen: false).generalMessage("1");
  }
TextEditingController _userMessageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var meditation = Provider.of<MeditationController>(context);
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
                      getSenderView(
                          ChatBubbleClipper10(type: BubbleType.sendBubble),
                          context,
                          "${messageController.globalMessages[index].message}",
                          "${messageController.globalMessages[index].messageTime}",
                          "${messageController.globalMessages[index].userName}",
                          "${messageController.globalMessages[index].messageDate}"),
                    if (messageController.globalMessages[index].isAdminMessage)
                      getReceiverView(
                          ChatBubbleClipper10(type: BubbleType.receiverBubble),
                          context,
                          messageController.globalMessages[index].message
                              .toString(),
                          messageController.globalMessages[index].userName
                              .toString(),
                          messageController.globalMessages[index].messageTime
                              .toString()),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 8.sp,
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
                            child:  ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 130.h,
                                ),
                                child:  Scrollbar(
                                  child:  SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    reverse: true,
                                    child:  TextField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      cursorColor: Colors.black,
                                      controller: _userMessageController,
                                      decoration: InputDecoration(
                                        hintText: 'Type your Note...',
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
                        await meditation.meditationNote( context,_userMessageController.text,"global", formattedTime,messageTDate).then((value) {
                           Provider.of<MessageController>(context, listen: false).generalMessage("1");
                        },);
                      }
                      _userMessageController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: PopupMenuExample(),
                  );
                }),
            // PopupMenuExample(),
            child: Container(
              color: shadeOne,
              height: 46.h,
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
                              messageController
                                  .addCount(messageController.totalPage - 1);
                            },
                            icon: Icon(Icons.chevron_right)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

getSenderView(CustomClipper clipper, BuildContext context, String note,
        String time, String messageName, String messageDate) =>
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
                  SizedBox(
                    width: 150.w,
                    child: Text(
                      messageName,
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: darkShade,
                          fontWeight: FontWeight.w500),
                    ),
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
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
                linkStyle: TextStyle(color: Colors.blue),
                // Optional, set to false to disable @mentions
                // humanize: false,
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  time,
                  style: TextStyle(fontSize: 10.sp),
                ))
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
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
                linkStyle: TextStyle(color: Colors.blue),
                // Optional, set to false to disable @mentions
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                messageDate,
                style: TextStyle(
                    fontSize: 12,
                    color: darkShade,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );

enum Menu { preview, share, getLink, remove, download }

class PopupMenuExample extends StatefulWidget {
  const PopupMenuExample({Key? key}) : super(key: key);

  @override
  State<PopupMenuExample> createState() => _PopupMenuExampleState();
}

class _PopupMenuExampleState extends State<PopupMenuExample> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) {
        // Handle the selected menu action
        switch (item) {
          case Menu.preview:
            // Handle preview action
            break;
          case Menu.share:
            // Handle share action
            break;
          case Menu.getLink:
            // Handle get link action
            break;
          case Menu.remove:
            // Handle remove action
            break;
          case Menu.download:
            // Handle download action
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.preview,
          child: ListTile(
            leading: Icon(Icons.visibility_outlined),
            title: Text('Preview'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.share,
          child: ListTile(
            leading: Icon(Icons.share_outlined),
            title: Text('Share'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.getLink,
          child: ListTile(
            leading: Icon(Icons.link_outlined),
            title: Text('Get link'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<Menu>(
          value: Menu.remove,
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Remove'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.download,
          child: ListTile(
            leading: Icon(Icons.download_outlined),
            title: Text('Download'),
          ),
        ),
      ],
    );
  }
}
