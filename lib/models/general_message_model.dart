// To parse this JSON data, do
//
//     final globalMessage = globalMessageFromJson(jsonString);

import 'dart:convert';

GlobalMessage globalMessageFromJson(String str) => GlobalMessage.fromJson(json.decode(str));

String globalMessageToJson(GlobalMessage data) => json.encode(data.toJson());

class GlobalMessage {
  String? message;
  List<Message>? messages;
  int? totalPages;

  GlobalMessage({
    this.message,
    this.messages,
    this.totalPages,
  });

  factory GlobalMessage.fromJson(Map<String, dynamic> json) => GlobalMessage(
    message: json["message"],
    messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
    "totalPages": totalPages,
  };
}

class Message {
  int? uId;
  String? message;
  String? messageTime;
  int? id;
  bool isAdminMessage;
  String? userName;
  String? messageDate;

  Message({
    this.uId,
    this.message,
    this.messageTime,
    this.id,
    required this.isAdminMessage,
    this.userName,
    this.messageDate
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    uId: json["UId"],
    message: json["message"],
    messageTime: json["messageTime"],
    id: json["id"],
    isAdminMessage: json["isAdminMessage"],
    userName: json["userName"],
    messageDate: json["messageDate"],
  );

  Map<String, dynamic> toJson() => {
    "UId": uId,
    "message": message,
    "messageTime": messageTime,
    "id": id,
    "isAdminMessage": isAdminMessage,
    "userName": userName,
    "messageDate": messageDate,
  };
}
