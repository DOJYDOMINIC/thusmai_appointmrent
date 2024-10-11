// To parse this JSON data, do
//
//     final meditationLodData = meditationLodDataFromJson(jsonString);

import 'dart:convert';

MeditationLodData meditationLodDataFromJson(String str) =>
    MeditationLodData.fromJson(json.decode(str));

String meditationLodDataToJson(MeditationLodData data) =>
    json.encode(data.toJson());

class MeditationLodData {
  int? totalPages;
  int? currentPage;
  int? totalCount;
  List<Datum>? data;

  MeditationLodData({
    this.totalPages,
    this.currentPage,
    this.totalCount,
    this.data,
  });

  factory MeditationLodData.fromJson(Map<String, dynamic> json) =>
      MeditationLodData(
        totalPages: json["totalPages"],
        currentPage: json["currentPage"],
        totalCount: json["totalCount"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalPages": totalPages,
        "currentPage": currentPage,
        "totalCount": totalCount,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? uId;
  DateTime? medStarttime;
  String? timeEstimate;
  int? ismeditated;

  Datum({
    this.uId,
    this.medStarttime,
    this.timeEstimate,
    this.ismeditated,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        uId: json["UId"],
        medStarttime:
            json["date"] == null ? null : DateTime.parse(json["date"]),
        // timeEstimate: json["timeEstimate"],
        ismeditated: json["ismeditated"],
      );

  Map<String, dynamic> toJson() => {
        "UId": uId,
        "date": medStarttime?.toIso8601String(),
        // "timeEstimate": timeEstimate,
        "ismeditated": ismeditated,
      };
}
