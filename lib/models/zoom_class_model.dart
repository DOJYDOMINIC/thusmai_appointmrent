// To parse this JSON data, do
//
//     final zoomClassModel = zoomClassModelFromJson(jsonString);

import 'dart:convert';

List<ZoomClassModel> zoomClassModelFromJson(String str) => List<ZoomClassModel>.from(json.decode(str).map((x) => ZoomClassModel.fromJson(x)));

String zoomClassModelToJson(List<ZoomClassModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ZoomClassModel {
  int? id;
  DateTime? zoomdate;
  String? zoomStartTime;
  String? zoomStopTime;
  String? zoomLink;

  ZoomClassModel({
    this.id,
    this.zoomdate,
    this.zoomStartTime,
    this.zoomStopTime,
    this.zoomLink,
  });

  factory ZoomClassModel.fromJson(Map<String, dynamic> json) => ZoomClassModel(
    id: json["id"],
    zoomdate: json["zoomdate"] == null ? null : DateTime.parse(json["zoomdate"]),
    zoomStartTime: json["zoomStartTime"],
    zoomStopTime: json["zoomStopTime"],
    zoomLink: json["zoomLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "zoomdate": "${zoomdate!.year.toString().padLeft(4, '0')}-${zoomdate!.month.toString().padLeft(2, '0')}-${zoomdate!.day.toString().padLeft(2, '0')}",
    "zoomStartTime": zoomStartTime,
    "zoomStopTime": zoomStopTime,
    "zoomLink": zoomLink,
  };
}
