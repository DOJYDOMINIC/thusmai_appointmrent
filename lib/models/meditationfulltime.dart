// To parse this JSON data, do
//
//     final meditationfullTime = meditationfullTimeFromJson(jsonString);

import 'dart:convert';

MeditationfullTime meditationfullTimeFromJson(String str) => MeditationfullTime.fromJson(json.decode(str));

String meditationfullTimeToJson(MeditationfullTime data) => json.encode(data.toJson());

class MeditationfullTime {
  String? message;
  MeditationTimeDetails? meditationTimeDetails;

  MeditationfullTime({
    this.message,
    this.meditationTimeDetails,
  });

  factory MeditationfullTime.fromJson(Map<String, dynamic> json) => MeditationfullTime(
    message: json["message"],
    meditationTimeDetails: json["meditationTimeDetails"] == null ? null : MeditationTimeDetails.fromJson(json["meditationTimeDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "meditationTimeDetails": meditationTimeDetails?.toJson(),
  };
}

class MeditationTimeDetails {
  int? id;
  String? country;
  String? morningTimeFrom;
  String? morningTimeTo;
  String? eveningTimeFrom;
  String? eveningTimeTo;

  MeditationTimeDetails({
    this.id,
    this.country,
    this.morningTimeFrom,
    this.morningTimeTo,
    this.eveningTimeFrom,
    this.eveningTimeTo,
  });

  factory MeditationTimeDetails.fromJson(Map<String, dynamic> json) => MeditationTimeDetails(
    id: json["id"],
    country: json["country"],
    morningTimeFrom: json["morning_time_from"],
    morningTimeTo: json["morning_time_to"],
    eveningTimeFrom: json["evening_time_from"],
    eveningTimeTo: json["evening_time_to"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country": country,
    "morning_time_from": morningTimeFrom,
    "morning_time_to": morningTimeTo,
    "evening_time_from": eveningTimeFrom,
    "evening_time_to": eveningTimeTo,
  };
}
