// To parse this JSON data, do
//
//     final globalMessage = globalMessageFromJson(jsonString);

import 'dart:convert';

PrivateMessage globalMessageFromJson(String str) => PrivateMessage.fromJson(json.decode(str));

String globalMessageToJson(PrivateMessage data) => json.encode(data.toJson());

class PrivateMessage {
  String? message;
  List<PMessage>? messages;
  int? totalPages;

  PrivateMessage({
    this.message,
    this.messages,
    this.totalPages,
  });

  factory PrivateMessage.fromJson(Map<String, dynamic> json) => PrivateMessage(
    message: json["message"],
    messages: json["messages"] == null ? [] : List<PMessage>.from(json["messages"]!.map((x) => PMessage.fromJson(x))),
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
    "totalPages": totalPages,
  };
}

class PMessage {
  int? uId;
  String? message;
  String? messageTime;
  int? id;
  // bool? isAdminMessage;
  String? userName;
  String? messageDate;

  PMessage({
    this.uId,
    this.message,
    this.messageTime,
    this.id,
    // this.isAdminMessage,
    this.userName,
    this.messageDate
  });

  factory PMessage.fromJson(Map<String, dynamic> json) => PMessage(
    uId: json["UId"],
    message: json["message"],
    messageTime: json["messageTime"],
    id: json["id"],
    // isAdminMessage: json["isAdminMessage"],
    userName: json["userName"],
    messageDate: json["messageDate"],
  );

  Map<String, dynamic> toJson() => {
    "UId": uId,
    "message": message,
    "messageTime": messageTime,
    "id": id,
    // "isAdminMessage": isAdminMessage,
    "userName": userName,
    "messageDate": messageDate,
  };
}
