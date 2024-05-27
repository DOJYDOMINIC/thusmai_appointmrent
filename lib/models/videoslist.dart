// To parse this JSON data, do
//
//     final videoPlayList = videoPlayListFromJson(jsonString);

import 'dart:convert';

VideoPlayList videoPlayListFromJson(String str) => VideoPlayList.fromJson(json.decode(str));

String videoPlayListToJson(VideoPlayList data) => json.encode(data.toJson());

class VideoPlayList {
  List<Video>? videos;

  VideoPlayList({
    this.videos,
  });

  factory VideoPlayList.fromJson(Map<String, dynamic> json) => VideoPlayList(
    videos: json["videos"] == null ? [] : List<Video>.from(json["videos"]!.map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "videos": videos == null ? [] : List<dynamic>.from(videos!.map((x) => x.toJson())),
  };
}

class Video {
  String? videoHeading;
  String? videoLink;

  Video({
    this.videoHeading,
    this.videoLink,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    videoHeading: json["Video_heading"],
    videoLink: json["videoLink"],
  );

  Map<String, dynamic> toJson() => {
    "Video_heading": videoHeading,
    "videoLink": videoLink,
  };
}
