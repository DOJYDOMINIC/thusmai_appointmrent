import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:thusmai_appointmrent/models/private_message.dart';
import '../constant/constant.dart';
import '../models/general_message_model.dart';


class MessageController extends ChangeNotifier {

  int _pageIndex = 1;

  set pageIndex(int value) {
    _pageIndex = value;
  }
  int get pageIndex => _pageIndex;
  void addCount(int totalPage) {
    if (_pageIndex <= totalPage) {
      _pageIndex++;
      generalMessage(_pageIndex.toString());
      notifyListeners();
    }
  }

  void subtract() {
    if (_pageIndex > 1) {
      _pageIndex--;
      generalMessage(_pageIndex.toString());
      notifyListeners();
    }
  }



  List<Message> get globalMessages => _messages;
  List<Message> _messages = [];
  int get totalPage => _totalPage;
  int _totalPage = 1;

  Future<void> generalMessage(String pageNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.get(
        Uri.parse("$userBaseUrl/globalMessage/$pageNumber"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataList = jsonDecode(response.body);
        List<dynamic> data = dataList["messages"];
         _totalPage = dataList["totalPages"];
        _messages = List<Message>.from(data.map((x) => Message.fromJson(x)));
      } else {
        // Handle other status codes if needed
        print("Failed to load global messages: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching global messages: $e");
    }
    notifyListeners();
  }



  int _privateIndex = 1;
  int get privateIndex => _privateIndex;

  void privateAdd(int totalPage) {
    if (_privateIndex <= totalPage) {
      _privateIndex++;
      privateMessage(_privateIndex.toString());
      notifyListeners();
    }
  }

  void privateSubtract() {
    if (_privateIndex > 1) {
      _privateIndex--;
      privateMessage(_privateIndex.toString());
      notifyListeners();
    }
  }
  List<PMessage> get privateMessages => _privateMessages;
  List<PMessage> _privateMessages = [];

  int get privatePageNo => _privatePageNo;
  int _privatePageNo = 0;

  Future<void> privateMessage(String pageNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.get(
        Uri.parse("$userBaseUrl/privateMessage/$pageNumber"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataList = jsonDecode(response.body);
        List<dynamic> data = dataList["messages"];
        _privatePageNo = dataList["totalPages"];
        _privateMessages = List<PMessage>.from(data.map((x) => PMessage.fromJson(x)));
      } else {
        // Handle other status codes if needed
        print("Failed to load privateMessage: ${response.statusCode}");
      }
    } catch (e) {
      print("Error privateMessage messages: $e");
    }
    notifyListeners();
  }




  List<PMessage> get guruMessages => _guruMessages;
  List<PMessage> _guruMessages = [];

  int get guruMessagesPageNo => _guruMessagesPageNo;
  int _guruMessagesPageNo = 0;

  int _guruIndex = 1;
  int get guruIndex => _guruIndex;

  void guruAdd(int totalPage) {
    if (_guruIndex <= totalPage) {
      _guruIndex++;
      guruMessage(_guruIndex.toString());
      notifyListeners();
    }
  }

  void guruSubtract() {
    if (_guruIndex > 1) {
      _guruIndex--;
      guruMessage(_guruIndex.toString());
      notifyListeners();
    }
  }

  Future<void> guruMessage(String pageNumber) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.get(
        Uri.parse("$userBaseUrl/gurujimessage/$pageNumber"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataList = jsonDecode(response.body);
        List<dynamic> data = dataList["messages"];
        _guruMessagesPageNo = dataList["totalPages"];
        _guruMessages = List<PMessage>.from(data.map((x) => PMessage.fromJson(x)));
      } else {
        // Handle other status codes if needed
        print("Failed to load guruMessage: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching guruMessage: $e");
    }
    notifyListeners();
  }


  Future<void>deleteGlobalMessage(String id)async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.delete(
        Uri.parse("$userBaseUrl/deleteMsg/$id"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      var res = jsonDecode(response.body);
      if(response.statusCode == 200){
        print(red.toString());
      }

    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

}
