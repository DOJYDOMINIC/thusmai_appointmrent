import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/controller/message_controller.dart';

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
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    messageController.guruSubtract();
                  },
                  icon: Icon(Icons.chevron_left)),
              IconButton(
                  onPressed: () {
                    messageController
                        .guruAdd(messageController.guruMessagesPageNo - 1);
                  },
                  icon: Icon(Icons.chevron_right)),
            ],
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messageController.guruMessages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: getSenderView(
                      ChatBubbleClipper10(type: BubbleType.sendBubble),
                      context,
                      "${messageController.guruMessages[index].message}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

getSenderView(CustomClipper clipper, BuildContext context, String note) =>
    ChatBubble(
      clipper: clipper,
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 20),
      backGroundColor: Colors.grey.shade400,
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
