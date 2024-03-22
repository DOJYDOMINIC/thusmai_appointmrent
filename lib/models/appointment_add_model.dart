// To parse this JSON data, do
//
//     final appointmentAddData = appointmentAddDataFromJson(jsonString);

import 'dart:convert';

AppointmentAddData appointmentAddDataFromJson(String str) => AppointmentAddData.fromJson(json.decode(str));

String appointmentAddDataToJson(AppointmentAddData data) => json.encode(data.toJson());

class AppointmentAddData {
  String? appointmentDate;
  int? numOfPeople;
  bool? pickup;
  String? from;
  String? days;
  String? emergencyNumber;
  String? appointmentTime;
  String? appointmentReason;
  dynamic userName;
  String? registerDate;
  dynamic feedback;
  bool? externalUser;
  dynamic rating;
  List<GroupMemberAdd>? groupMembers;

  AppointmentAddData({
    this.appointmentDate,
    this.numOfPeople,
    this.pickup,
    this.from,
    this.days,
    this.emergencyNumber,
    this.appointmentTime,
    this.appointmentReason,
    this.userName,
    this.registerDate,
    this.feedback,
    this.externalUser,
    this.rating,
    this.groupMembers,
  });

  factory AppointmentAddData.fromJson(Map<String, dynamic> json) => AppointmentAddData(
    appointmentDate: json["appointmentDate"],
    numOfPeople: json["num_of_people"],
    pickup: json["pickup"],
    from: json["from"],
    days: json["days"],
    emergencyNumber: json["emergencyNumber"],
    appointmentTime: json["appointment_time"],
    appointmentReason: json["appointment_reason"],
    userName: json["user_name"],
    registerDate: json["register_date"],
    feedback: json["feedback"],
    externalUser: json["externalUser"],
    rating: json["rating"],
    groupMembers: json["groupmembers"] == null ? [] : List<GroupMemberAdd>.from(json["groupMembers"]!.map((x) => GroupMemberAdd.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "appointmentDate": appointmentDate,
    "num_of_people": numOfPeople,
    "pickup": pickup,
    "from": from,
    "days": days,
    "emergencyNumber": emergencyNumber,
    "appointment_time": appointmentTime,
    "appointment_reason": appointmentReason,
    "user_name": userName,
    "register_date": registerDate,
    "feedback": feedback,
    "externalUser": externalUser,
    "rating": rating,
    "groupmembers": groupMembers == null ? [] : List<dynamic>.from(groupMembers!.map((x) => x.toJson())),
  };
}

class GroupMemberAdd {
  String? name;
  String? relation;
  String? age;

  GroupMemberAdd({
    this.name,
    this.relation,
    this.age,
  });

  factory GroupMemberAdd.fromJson(Map<String, dynamic> json) => GroupMemberAdd(
    name: json["name"],
    relation: json["relation"],
    age: json["age"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "relation": relation,
    "age": age,
  };
}
