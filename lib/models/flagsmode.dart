// To parse this JSON data, do
//
//     final flagmodel = flagmodelFromJson(jsonString);

import 'dart:convert';

Flagmodel flagmodelFromJson(String str) => Flagmodel.fromJson(json.decode(str));

String flagmodelToJson(Flagmodel data) => json.encode(data.toJson());

class Flagmodel {
  Message? message;

  Flagmodel({
    this.message,
  });

  factory Flagmodel.fromJson(Map<String, dynamic> json) => Flagmodel(
    message: json["message"] == null ? null : Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message?.toJson(),
  };
}

class Message {
  bool? isans;
  bool? maintenancePaymentStatus;
  bool? meditationFeePaymentStatus;

  Message({
    this.isans,
    this.maintenancePaymentStatus,
    this.meditationFeePaymentStatus,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    isans: json["isans"],
    maintenancePaymentStatus: json["maintenance_payment_status"],
    meditationFeePaymentStatus: json["meditation_fee_payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "isans": isans,
    "maintenance_payment_status": maintenancePaymentStatus,
    "meditation_fee_payment_status": meditationFeePaymentStatus,
  };
}
