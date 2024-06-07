// To parse this JSON data, do
//
//     final videoPlayList = videoPlayListFromJson(jsonString);

import 'dart:convert';

List<VideoPlayList> videoPlayListFromJson(String str) => List<VideoPlayList>.from(json.decode(str).map((x) => VideoPlayList.fromJson(x)));

String videoPlayListToJson(List<VideoPlayList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoPlayList {
  String? videoHeading;
  String? videoLink;

  VideoPlayList({
    this.videoHeading,
    this.videoLink,
  });

  factory VideoPlayList.fromJson(Map<String, dynamic> json) => VideoPlayList(
    videoHeading: json["Video_heading"],
    videoLink: json["videoLink"],
  );

  Map<String, dynamic> toJson() => {
    "Video_heading": videoHeading,
    "videoLink": videoLink,
  };
}
