// // import 'dart:convert';
// // import 'dart:io';
// //
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart' show rootBundle;
// // import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// // import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image_picker/image_picker.dart';
// // import 'package:mime/mime.dart';
// // import 'package:open_filex/open_filex.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:uuid/uuid.dart';
// //
// //
// // class ChatPage extends StatefulWidget {
// //   const ChatPage({super.key});
// //
// //   @override
// //   State<ChatPage> createState() => _ChatPageState();
// // }
// //
// // class _ChatPageState extends State<ChatPage> {
// //   List<types.Message> _messages = [];
// //   final _user = const types.User(
// //     id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
// //   );
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadMessages();
// //   }
// //
// //   void _addMessage(types.Message message) {
// //     setState(() {
// //       _messages.insert(0, message);
// //     });
// //   }
// //
// //   void _handleAttachmentPressed() {
// //     showModalBottomSheet<void>(
// //       context: context,
// //       builder: (BuildContext context) => SafeArea(
// //         child: SizedBox(
// //           height: 144,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: <Widget>[
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                   _handleImageSelection();
// //                 },
// //                 child: const Align(
// //                   alignment: AlignmentDirectional.centerStart,
// //                   child: Text('Photo'),
// //                 ),
// //               ),
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                   _handleFileSelection();
// //                 },
// //                 child: const Align(
// //                   alignment: AlignmentDirectional.centerStart,
// //                   child: Text('File'),
// //                 ),
// //               ),
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context),
// //                 child: const Align(
// //                   alignment: AlignmentDirectional.centerStart,
// //                   child: Text('Cancel'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _handleFileSelection() async {
// //     final result = await FilePicker.platform.pickFiles(
// //       type: FileType.any,
// //     );
// //
// //     if (result != null && result.files.single.path != null) {
// //       final message = types.FileMessage(
// //         author: _user,
// //         createdAt: DateTime.now().millisecondsSinceEpoch,
// //         id: const Uuid().v4(),
// //         mimeType: lookupMimeType(result.files.single.path!),
// //         name: result.files.single.name,
// //         size: result.files.single.size,
// //         uri: result.files.single.path!,
// //       );
// //       _addMessage(message);
// //     }
// //   }
// //
// //   void _handleImageSelection() async {
// //     final result = await ImagePicker().pickImage(
// //       imageQuality: 70,
// //       maxWidth: 1440,
// //       source: ImageSource.gallery,
// //     );
// //
// //     if (result != null) {
// //       final bytes = await result.readAsBytes();
// //       final image = await decodeImageFromList(bytes);
// //
// //       final message = types.ImageMessage(
// //         author: _user,
// //         createdAt: DateTime.now().millisecondsSinceEpoch,
// //         height: image.height.toDouble(),
// //         id: const Uuid().v4(),
// //         name: result.name,
// //         size: bytes.length,
// //         uri: result.path,
// //         width: image.width.toDouble(),
// //       );
// //
// //       _addMessage(message);
// //     }
// //   }
// //
// //   void _handleMessageTap(BuildContext _, types.Message message) async {
// //     print("object");
// //     if (message is types.FileMessage) {
// //       var localPath = message.uri;
// //
// //       if (message.uri.startsWith('http')) {
// //         try {
// //           final index =
// //           _messages.indexWhere((element) => element.id == message.id);
// //           final updatedMessage =
// //           (_messages[index] as types.FileMessage).copyWith(
// //             isLoading: true,
// //           );
// //
// //           setState(() {
// //             _messages[index] = updatedMessage;
// //           });
// //
// //           final client = http.Client();
// //           final request = await client.get(Uri.parse(message.uri));
// //           final bytes = request.bodyBytes;
// //           final documentsDir = (await getApplicationDocumentsDirectory()).path;
// //           localPath = '$documentsDir/${message.name}';
// //
// //           if (!File(localPath).existsSync()) {
// //             final file = File(localPath);
// //             await file.writeAsBytes(bytes);
// //           }
// //         } finally {
// //           final index =
// //           _messages.indexWhere((element) => element.id == message.id);
// //           final updatedMessage =
// //           (_messages[index] as types.FileMessage).copyWith(
// //             isLoading: null,
// //           );
// //
// //           setState(() {
// //             _messages[index] = updatedMessage;
// //           });
// //         }
// //       }
// //
// //       await OpenFilex.open(localPath);
// //     }
// //   }
// //
// //   void _handlePreviewDataFetched(
// //       types.TextMessage message,
// //       types.PreviewData previewData,
// //       ) {
// //     final index = _messages.indexWhere((element) => element.id == message.id);
// //     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
// //       previewData: previewData,
// //     );
// //
// //     setState(() {
// //       _messages[index] = updatedMessage;
// //     });
// //   }
// //
// //   void _handleSendPressed(types.PartialText message) {
// //     final textMessage = types.TextMessage(
// //       author: _user,
// //       createdAt: DateTime.now().millisecondsSinceEpoch,
// //       id: const Uuid().v4(),
// //       text: message.text,
// //     );
// //
// //     _addMessage(textMessage);
// //   }
// //
// //   void _loadMessages() async {
// //     final response = await rootBundle.loadString('assets/messages.json');
// //     final messages = (jsonDecode(response) as List).map((e) => types.Message.fromJson(e as Map<String, dynamic>)).toList();
// //
// //     setState(() {
// //       _messages = messages;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) => Scaffold(
// //     body: Chat(
// //       messages: _messages,
// //       onAttachmentPressed: _handleAttachmentPressed,
// //       onMessageTap: _handleMessageTap,
// //       onPreviewDataFetched: _handlePreviewDataFetched,
// //       onSendPressed: _handleSendPressed,
// //       showUserAvatars: true,
// //       showUserNames: true,
// //       user: _user,
// //       theme: const DefaultChatTheme(seenIcon: Text(
// //           'read',
// //           style: TextStyle(
// //             fontSize: 10.0,
// //           ),
// //         ),
// //       ),
// //     ),
// //   );
// // }
// //
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// //
// //
// //
// // class ChatScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Chat'),
// //       ),
// //       body: Center(
// //         child: ElevatedButton(
// //           onPressed: () async {
// //             // Example usage of the sendMessage function
// //             await sendMessage(
// //               messageType: MessageType.text,
// //               text: 'Hello, World!',
// //             );
// //             await sendMessage(
// //               messageType: MessageType.audio,
// //               audioPath: 'path/to/audio.mp3',
// //             );
// //             await sendMessage(
// //               messageType: MessageType.video,
// //               videoPath: 'path/to/video.mp4',
// //             );
// //             await sendMessage(
// //               messageType: MessageType.file,
// //               filePath: 'path/to/file.pdf',
// //             );
// //           },
// //           child: Text('Send Message'),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // enum MessageType { text, audio, video, file }
// //
// // Future<void> sendMessage({
// //   required MessageType messageType,
// //   String? text,
// //   String? audioPath,
// //   String? videoPath,
// //   String? filePath,
// // }) async {
// //   try {
// //     // Connect to the server
// //     Socket socket = await Socket.connect('https://thasmai.tstsvc.in/chat',5000);
// //
// //     // Create a JSON object with message data based on message type
// //     Map<String, dynamic> jsonData = {
// //       'type': messageType.toString().split('.').last,
// //     };
// //
// //     switch (messageType) {
// //       case MessageType.text:
// //         jsonData['text'] = text;
// //         break;
// //       case MessageType.audio:
// //       // Open the audio file
// //         File audioFile = File(audioPath!);
// //         List<int> audioData = await audioFile.readAsBytes();
// //         jsonData['audio'] = base64Encode(audioData); // Convert audio data to base64 string
// //         break;
// //       case MessageType.video:
// //       // Open the video file
// //         File videoFile = File(videoPath!);
// //         List<int> videoData = await videoFile.readAsBytes();
// //         jsonData['video'] = base64Encode(videoData); // Convert video data to base64 string
// //         break;
// //       case MessageType.file:
// //       // Open the file
// //         File file = File(filePath!);
// //         List<int> fileData = await file.readAsBytes();
// //         jsonData['file'] = base64Encode(fileData); // Convert file data to base64 string
// //         break;
// //     }
// //
// //     // Convert JSON object to string and send it over the socket
// //     socket.writeln(jsonEncode(jsonData));
// //
// //     // Close the socket
// //     socket.close();
// //
// //     print('Message sent successfully');
// //   } catch (e) {
// //     print('Failed to send message: $e');
// //   }
// // }
//
//
// import 'package:chatview/chatview.dart';
// import 'package:flutter/material.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   AppTheme theme = LightTheme();
//   bool isDarkTheme = false;
//   final currentUser = ChatUser(
//     id: '1',
//     name: 'Flutter',
//     profilePhoto: 'assets/profile_image.png', // Assuming Data.profileImage is a path to the image
//   );
//
//   final _chatController = ChatController(
//     initialMessageList: [], // Assuming Data.messageList is the initial message list
//     scrollController: ScrollController(),
//     chatUsers: [
//       ChatUser(
//         id: '2',
//         name: 'Simform',
//         profilePhoto: 'assets/profile_image.png', // Assuming Data.profileImage is a path to the image
//       ),
//       ChatUser(
//         id: '3',
//         name: 'John',
//         profilePhoto: 'assets/profile_image.png', // Assuming Data.profileImage is a path to the image
//       ),
//       ChatUser(
//         id: '4',
//         name: 'Mike',
//         profilePhoto: 'assets/profile_image.png', // Assuming Data.profileImage is a path to the image
//       ),
//       ChatUser(
//         id: '5',
//         name: 'Rich',
//         profilePhoto: 'assets/profile_image.png', // Assuming Data.profileImage is a path to the image
//       ),
//     ],
//   );
//
//   void _showHideTypingIndicator() {
//     _chatController.setTypingIndicator = !_chatController.showTypingIndicator;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ChatView(
//         currentUser: currentUser,
//         chatController: _chatController,
//         onSendTap: _onSendTap,
//         featureActiveConfig: const FeatureActiveConfig(
//           lastSeenAgoBuilderVisibility: true,
//           receiptsBuilderVisibility: true,
//         ),
//         chatViewState: ChatViewState.hasMessages,
//         chatViewStateConfig: ChatViewStateConfiguration(
//           loadingWidgetConfig: ChatViewStateWidgetConfiguration(
//             loadingIndicatorColor: theme.outgoingChatBubbleColor,
//           ),
//           onReloadButtonTap: () {},
//         ),
//         typeIndicatorConfig: TypeIndicatorConfiguration(
//           flashingCircleBrightColor: theme.flashingCircleBrightColor,
//           flashingCircleDarkColor: theme.flashingCircleDarkColor,
//         ),
//         appBar: ChatViewAppBar(
//           elevation: theme.elevation,
//           backGroundColor: theme.appBarColor,
//           profilePicture: currentUser.id,
//           backArrowColor: theme.backArrowColor,
//           chatTitle: "Chat view",
//           chatTitleTextStyle: TextStyle(
//             color: theme.appBarTitleTextStyle,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             letterSpacing: 0.25,
//           ),
//           userStatus: "online",
//           userStatusTextStyle: const TextStyle(color: Colors.grey),
//           actions: [
//             IconButton(
//               onPressed:(){},
//               // _onThemeIconTap,
//               icon: Icon(
//                 isDarkTheme
//                     ? Icons.brightness_4_outlined
//                     : Icons.dark_mode_outlined,
//                 color: theme.themeIconColor,
//               ),
//             ),
//             IconButton(
//               tooltip: 'Toggle TypingIndicator',
//               onPressed: _showHideTypingIndicator,
//               icon: Icon(
//                 Icons.keyboard,
//                 color: theme.themeIconColor,
//               ),
//             ),
//           ],
//         ),
//         chatBackgroundConfig: ChatBackgroundConfiguration(
//           messageTimeIconColor: theme.messageTimeIconColor,
//           messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
//           defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
//             textStyle: TextStyle(
//               color: theme.chatHeaderColor,
//               fontSize: 17,
//             ),
//           ),
//           backgroundColor: theme.backgroundColor,
//         ),
//         sendMessageConfig: SendMessageConfiguration(
//           imagePickerIconsConfig: ImagePickerIconsConfiguration(
//             cameraIconColor: theme.cameraIconColor,
//             galleryIconColor: theme.galleryIconColor,
//           ),
//           replyMessageColor: theme.replyMessageColor,
//           defaultSendButtonColor: theme.sendButtonColor,
//           replyDialogColor: theme.replyDialogColor,
//           replyTitleColor: theme.replyTitleColor,
//           textFieldBackgroundColor: theme.textFieldBackgroundColor,
//           closeIconColor: theme.closeIconColor,
//           textFieldConfig: TextFieldConfiguration(
//             onMessageTyping: (status) {
//               /// Do with status
//               debugPrint(status.toString());
//             },
//             compositionThresholdTime: const Duration(seconds: 1),
//             textStyle: TextStyle(color: theme.textFieldTextColor),
//           ),
//           micIconColor: theme.replyMicIconColor,
//           voiceRecordingConfiguration: VoiceRecordingConfiguration(
//             backgroundColor: theme.waveformBackgroundColor,
//             recorderIconColor: theme.recordIconColor,
//             waveStyle: WaveStyle(
//               showMiddleLine: false,
//               waveColor: theme.waveColor ?? Colors.white,
//               extendWaveform: true,
//             ),
//           ),
//         ),
//         chatBubbleConfig: ChatBubbleConfiguration(
//           outgoingChatBubbleConfig: ChatBubble(
//             linkPreviewConfig: LinkPreviewConfiguration(
//               backgroundColor: theme.linkPreviewOutgoingChatColor,
//               bodyStyle: theme.outgoingChatLinkBodyStyle,
//               titleStyle: theme.outgoingChatLinkTitleStyle,
//             ),
//             receiptsWidgetConfig:
//             const ReceiptsWidgetConfig(showReceiptsIn: ShowReceiptsIn.all),
//             color: theme.outgoingChatBubbleColor,
//           ),
//           inComingChatBubbleConfig: ChatBubble(
//             linkPreviewConfig: LinkPreviewConfiguration(
//               linkStyle: TextStyle(
//                 color: theme.inComingChatBubbleTextColor,
//                 decoration: TextDecoration.underline,
//               ),
//               backgroundColor: theme.linkPreviewIncomingChatColor,
//               bodyStyle: theme.incomingChatLinkBodyStyle,
//               titleStyle: theme.incomingChatLinkTitleStyle,
//             ),
//             textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
//             onMessageRead: (message) {
//               /// send your message reciepts to the other client
//               debugPrint('Message Read');
//             },
//             senderNameTextStyle:
//             TextStyle(color: theme.inComingChatBubbleTextColor),
//             color: theme.inComingChatBubbleColor,
//           ),
//         ),
//         replyPopupConfig: ReplyPopupConfiguration(
//           backgroundColor: theme.replyPopupColor,
//           buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
//           topBorderColor: theme.replyPopupTopBorderColor,
//         ),
//         reactionPopupConfig: ReactionPopupConfiguration(
//           shadow: BoxShadow(
//             color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
//             blurRadius: 20,
//           ),
//           backgroundColor: theme.reactionPopupColor,
//         ),
//         messageConfig: MessageConfiguration(
//           messageReactionConfig: MessageReactionConfiguration(
//             backgroundColor: theme.messageReactionBackGroundColor,
//             borderColor: theme.messageReactionBackGroundColor,
//             reactedUserCountTextStyle:
//             TextStyle(color: theme.inComingChatBubbleTextColor),
//             reactionCountTextStyle:
//             TextStyle(color: theme.inComingChatBubbleTextColor),
//             reactionsBottomSheetConfig: ReactionsBottomSheetConfiguration(
//               backgroundColor: theme.backgroundColor,
//               reactedUserTextStyle: TextStyle(
//                 color: theme.inComingChatBubbleTextColor,
//               ),
//               reactionWidgetDecoration: BoxDecoration(
//                 color: theme.inComingChatBubbleColor,
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDarkTheme ? Colors.black12 : Colors.grey.shade200,
//                     offset: const Offset(0, 20),
//                     blurRadius: 40,
//                   )
//                 ],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           imageMessageConfig: ImageMessageConfiguration(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             shareIconConfig: ShareIconConfiguration(
//               defaultIconBackgroundColor: theme.shareIconBackgroundColor,
//               defaultIconColor: theme.shareIconColor,
//             ),
//           ),
//         ),
//         profileCircleConfig: const ProfileCircleConfiguration(
//           // profileImageUrl: currentUser!.profilePhoto,
//         ),
//         repliedMessageConfig: RepliedMessageConfiguration(
//           backgroundColor: theme.repliedMessageColor,
//           verticalBarColor: theme.verticalBarColor,
//           repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
//             enableHighlightRepliedMsg: true,
//             highlightColor: Colors.pinkAccent.shade100,
//             highlightScale: 1.1,
//           ),
//           textStyle: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 0.25,
//           ),
//           replyTitleTextStyle: TextStyle(color: theme.repliedTitleTextColor),
//         ),
//         swipeToReplyConfig: SwipeToReplyConfiguration(
//           replyIconColor: theme.swipeToReplyIconColor,
//         ),
//       ),
//     );
//   }
//
//   void _onSendTap(
//       String message,
//       ReplyMessage replyMessage,
//       MessageType messageType,
//       ) {
//     final id = int.parse(currentUser.id) + 1;
//     _chatController.addMessage(
//       Message(
//         id: id.toString(),
//         createdAt: DateTime.now(),
//         message: message,
//         sendBy: currentUser.id,
//         replyMessage: replyMessage,
//         messageType: messageType,
//       ),
//     );
//     Future.delayed(const Duration(milliseconds: 300), () {
//       _chatController.initialMessageList.last.setStatus =
//           MessageStatus.undelivered;
//     });
//     Future.delayed(const Duration(seconds: 1), () {
//       _chatController.initialMessageList.last.setStatus = MessageStatus.read;
//     });
//   }
//   //
//   // void _onThemeIconTap() {
//   //   setState(() {
//   //     if (isDarkTheme) {
//   //       theme = LightTheme();
//   //       isDarkTheme = false;
//   //     } else {
//   //       theme = DarkTheme();
//   //       isDarkTheme = true;
//   //     }
//   //   });
//   // }
// }