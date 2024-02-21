// To parse this JSON data, do

//     final appointmentListdata = appointmentListdataFromJson(jsonString);

import 'dart:convert';

AppointmentListdata appointmentListdataFromJson(String str) => AppointmentListdata.fromJson(json.decode(str));

String appointmentListdataToJson(AppointmentListdata data) => json.encode(data.toJson());

class AppointmentListdata {
  String? message;
  List<ListElement>? list;

  AppointmentListdata({
    this.message,
    this.list,
  });

  factory AppointmentListdata.fromJson(Map<String, dynamic> json) => AppointmentListdata(
    message: json["message"],
    list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ListElement {
  int? id;
  int? uId;
  String? phone;
  String? appointmentDate;
  int? numOfPeople;
  bool? pickup;
  String? from;
  String? days;
  String? emergencyNumber;
  String? appointmentTime;
  String? appointmentReason;
  String? userName;
  String? registerDate;
  String? appointmentStatus;
  String? payment;
  String? paymentMethod;
  dynamic discount;
  String? checkOut;

  ListElement({
    this.id,
    this.uId,
    this.phone,
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
    this.appointmentStatus,
    this.payment,
    this.paymentMethod,
    this.discount,
    this.checkOut,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    uId: json["UId"],
    phone: json["phone"],
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
    appointmentStatus: json["appointment_status"],
    payment: json["payment"],
    paymentMethod: json["payment_method"],
    discount: json["discount"],
    checkOut: json["check_out"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "UId": uId,
    "phone": phone,
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
    "appointment_status": appointmentStatus,
    "payment": payment,
    "payment_method": paymentMethod,
    "discount": discount,
    "check_out": checkOut,
  };
}
