// To parse this JSON data, do
//
//     final loginApi = loginApiFromJson(jsonString);

import 'dart:convert';

LoginApi loginApiFromJson(String str) => LoginApi.fromJson(json.decode(str));

String loginApiToJson(LoginApi data) => json.encode(data.toJson());

class LoginApi {
  String? message;
  UserLoginData? user;

  LoginApi({
    this.message,
    this.user,
  });

  factory LoginApi.fromJson(Map<String, dynamic> json) => LoginApi(
    message: json["message"],
    user: json["user"] == null ? null : UserLoginData.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "user": user?.toJson(),
  };
}

class UserLoginData {
  int? userId;
  String? email;
  String? firstName;
  String? lastName;
  int? uId;
  DateTime? doj;
  bool? isans;
  DateTime? expiredDate;

  UserLoginData({
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.uId,
    this.doj,
    this.isans,
    this.expiredDate,
  });

  factory UserLoginData.fromJson(Map<String, dynamic> json) => UserLoginData(
    userId: json["UserId"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    uId: json["UId"],
    doj: json["DOJ"] == null ? null : DateTime.parse(json["DOJ"]),
    isans: json["isans"],
    expiredDate: json["expiredDate"] == null ? null : DateTime.parse(json["expiredDate"]),
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "UId": uId,
    "DOJ": "${doj!.year.toString().padLeft(4, '0')}-${doj!.month.toString().padLeft(2, '0')}-${doj!.day.toString().padLeft(2, '0')}",
    "isans": isans,
    "expiredDate": expiredDate?.toIso8601String(),
  };
}
