// To parse this JSON data, do
//
//     final updateUserDetail = updateUserDetailFromJson(jsonString);

import 'dart:convert';

UpdateUserDetail updateUserDetailFromJson(String str) => UpdateUserDetail.fromJson(json.decode(str));

String updateUserDetailToJson(UpdateUserDetail data) => json.encode(data.toJson());

class UpdateUserDetail {
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

  UpdateUserDetail({
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
  });

  factory UpdateUserDetail.fromJson(Map<String, dynamic> json) => UpdateUserDetail(
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
  );

  Map<String, dynamic> toJson() => {
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
  };
}
