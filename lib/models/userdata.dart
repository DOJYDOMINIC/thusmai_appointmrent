// To parse this JSON data, do
//
//     final userdata = userdataFromJson(jsonString);

import 'dart:convert';

Userdata userdataFromJson(String str) => Userdata.fromJson(json.decode(str));

String userdataToJson(Userdata data) => json.encode(data.toJson());

class Userdata {
  User user;

  Userdata({
    required this.user,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
  };
}

class User {
  int userId;
  String firstName;
  String lastName;
  String dob;
  String gender;
  String email;
  String address;
  int pincode;
  String state;
  String district;
  String country;
  String phone;
  String reference;
  String languages;
  String remark;
  String verify;
  int uId;
  DateTime doj;
  DateTime expiredDate;
  String password;
  String classAttended;
  String maintananceFee;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.email,
    required this.address,
    required this.pincode,
    required this.state,
    required this.district,
    required this.country,
    required this.phone,
    required this.reference,
    required this.languages,
    required this.remark,
    required this.verify,
    required this.uId,
    required this.doj,
    required this.expiredDate,
    required this.password,
    required this.classAttended,
    required this.maintananceFee,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["UserId"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    dob: json["DOB"],
    gender: json["gender"],
    email: json["email"],
    address: json["address"],
    pincode: json["pincode"],
    state: json["state"],
    district: json["district"],
    country: json["country"],
    phone: json["phone"],
    reference: json["reference"],
    languages: json["languages"],
    remark: json["remark"],
    verify: json["verify"],
    uId: json["UId"],
    doj: DateTime.parse(json["DOJ"]),
    expiredDate: DateTime.parse(json["expiredDate"]),
    password: json["password"],
    classAttended: json["classAttended"],
    maintananceFee: json["maintanance_fee"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "first_name": firstName,
    "last_name": lastName,
    "DOB": dob,
    "gender": gender,
    "email": email,
    "address": address,
    "pincode": pincode,
    "state": state,
    "district": district,
    "country": country,
    "phone": phone,
    "reference": reference,
    "languages": languages,
    "remark": remark,
    "verify": verify,
    "UId": uId,
    "DOJ": "${doj.year.toString().padLeft(4, '0')}-${doj.month.toString().padLeft(2, '0')}-${doj.day.toString().padLeft(2, '0')}",
    "expiredDate": expiredDate.toIso8601String(),
    "password": password,
    "classAttended": classAttended,
    "maintanance_fee": maintananceFee,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
