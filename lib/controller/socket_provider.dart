import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends ChangeNotifier {
  late IO.Socket socket;

  SocketProvider() {
    connectToSocket();
  }

  void connectToSocket() {
    try {
      socket = IO.io('http://192.168.1.78:5000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
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

      socket.on('chat_message', (data) {
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
      socket.emit('chat_message', jsonData);
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