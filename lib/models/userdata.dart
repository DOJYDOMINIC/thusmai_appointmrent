// To parse this JSON data, do
//
//     final userdata = userdataFromJson(jsonString);

import 'dart:convert';

Userdata userdataFromJson(String str) => Userdata.fromJson(json.decode(str));

String userdataToJson(Userdata data) => json.encode(data.toJson());

class Userdata {
  User? user;

  Userdata({
    this.user,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? dob;
  String? gender;
  String? email;
  String? address;
  int? pincode;
  String? state;
  String? district;
  String? country;
  String? phone;
  String? reference;
  String? languages;
  int? uId;
  DateTime? doj;
  DateTime? expiredDate;
  String? classAttended;
  bool? isans;
  List<String>? profilePicUrl;
  bool? maintananceFee;
  int? cycle;
  int? day;
  int? sessionNum;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.email,
    this.address,
    this.pincode,
    this.state,
    this.district,
    this.country,
    this.phone,
    this.reference,
    this.languages,
    this.uId,
    this.doj,
    this.expiredDate,
    this.classAttended,
    this.isans,
    this.profilePicUrl,
    this.maintananceFee,
    this.cycle,
    this.day,
    this.sessionNum,
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
    uId: json["UId"],
    doj: json["DOJ"] == null ? null : DateTime.parse(json["DOJ"]),
    expiredDate: json["expiredDate"] == null ? null : DateTime.parse(json["expiredDate"]),
    classAttended: json["classAttended"],
    isans: json["isans"],
    profilePicUrl: json["profilePicUrl"] == null ? [] : List<String>.from(json["profilePicUrl"]!.map((x) => x)),
    maintananceFee: json["maintanance_fee"],
    cycle: json["cycle"],
    day: json["day"],
    sessionNum: json["session_num"],
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
    "UId": uId,
    "DOJ": "${doj!.year.toString().padLeft(4, '0')}-${doj!.month.toString().padLeft(2, '0')}-${doj!.day.toString().padLeft(2, '0')}",
    "expiredDate": expiredDate?.toIso8601String(),
    "classAttended": classAttended,
    "isans": isans,
    "profilePicUrl": profilePicUrl == null ? [] : List<dynamic>.from(profilePicUrl!.map((x) => x)),
    "maintanance_fee": maintananceFee,
    "cycle": cycle,
    "day": day,
    "session_num": sessionNum,
  };
}
