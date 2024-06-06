// To parse this JSON data, do
//
//     final meditationTime = meditationTimeFromJson(jsonString);

import 'dart:convert';

MeditationTime meditationTimeFromJson(String str) => MeditationTime.fromJson(json.decode(str));

String meditationTimeToJson(MeditationTime data) => json.encode(data.toJson());

class MeditationTime {
  String? video;
  String? fromTime;
  String? toTime;

  MeditationTime({
    this.video,
    this.fromTime,
    this.toTime,
  });

  factory MeditationTime.fromJson(Map<String, dynamic> json) => MeditationTime(
    video: json["video"],
    fromTime: json["fromTime"]??"10:00:00",
    toTime: json["toTime"]??"10:00:10",
  );

  Map<String, dynamic> toJson() => {
    "video": video,
    "fromTime": fromTime,
    "toTime": toTime,
  };
}
