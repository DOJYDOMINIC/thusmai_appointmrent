import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends ChangeNotifier {
  late IO.Socket socket;

  SocketProvider() {
    connectToSocket();
  }

  void connectToSocket() {
    try {
      socket = IO.io('https://thasmai.tstsvc.in/chat', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();
      socket.onConnect((_) {
        print('Connected to server');
        notifyListeners();
      });

      socket.onDisconnect((_) {
        print('Disconnected from server');
        notifyListeners();
      });

      socket.on('private_message', (data) {
        print('Received chat message: $data');
        // Handle incoming chat message here
        notifyListeners();
      });
    } catch (e) {
      print('Error occurred while connecting to server: $e');
    }
  }

  void sendMessage(Map<String, dynamic> jsonData) {
    try {
      socket.emit('private_message', jsonData);
      print("${jsonData.toString()}");
    } catch (e) {
      print('Error occurred while sending message: $e');
    }
  }

  void disposeSocket() {
    try {
      socket.dispose();
    } catch (e) {
      print('Error occurred while disposing socket: $e');
    }
  }
}
