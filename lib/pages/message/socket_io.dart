// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   late IO.Socket socket;
//
//   @override
//   void initState() {
//     super.initState();
//     try {
//       // Connect to the server
//       socket = IO.io('http://192.168.1.78:5000', <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': false,
//       });
//
//       socket.connect();
//       socket.onConnect((_) {
//         print('Connected to server');
//       });
//
//       socket.onDisconnect((_) {
//         print('Disconnected from server');
//       });
//
//       socket.on('chat_message', (data) {
//         print('Received chat message: $data');
//         // Handle incoming chat message here
//       });
//     } catch (e) {
//       print('Error occurred while connecting to server: $e');
//     }
//   }
//
//   TextEditingController _message = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Socket.io Chat'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _message,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 try {
//                   // Send a chat message to the server
//                   Map<String, dynamic> jsonData = {
//                     'name': 'John Doe',
//                     'age': 30,
//                     'email': 'john.doe@example.com'
//                   };
//                   socket.emit('chat_message', jsonData);
//                 } catch (e) {
//                   print('Error occurred while sending message: $e');
//                 }
//               },
//               child: Text('Send Message'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     try {
//       socket.dispose();
//     } catch (e) {
//       print('Error occurred while disposing socket: $e');
//     }
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/socket_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<SocketProvider>(context, listen: false).socket.connect();
  }
  final TextEditingController _message = TextEditingController();
  final TextEditingController _id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SocketIO"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _id,
                decoration: InputDecoration(label: Text("id")),
              ),
              TextFormField(
                decoration: InputDecoration(label: Text("message")),
                controller: _message,
              ),
              ElevatedButton(
                onPressed: () {
                  final jsonData = {
                    // 'message': '123456',
                    // 'priority': "false",
                    // 'time': 'Connecting Socket io'
                    "recipientUID":_id.text,
                    "message":_message.text
                  };
                  Provider.of<SocketProvider>(context, listen: false).sendMessage(jsonData);
                },
                child: Text('Send Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
