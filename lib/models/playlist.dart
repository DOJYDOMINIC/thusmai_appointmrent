// To parse this JSON data, do
//
//     final playList = playListFromJson(jsonString);

import 'dart:convert';

PlayList playListFromJson(String str) => PlayList.fromJson(json.decode(str));

String playListToJson(PlayList data) => json.encode(data.toJson());

class PlayList {
  List<Playlist>? playlists;

  PlayList({
    this.playlists,
  });

  factory PlayList.fromJson(Map<String, dynamic> json) => PlayList(
    playlists: json["playlists"] == null ? [] : List<Playlist>.from(json["playlists"]!.map((x) => Playlist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "playlists": playlists == null ? [] : List<dynamic>.from(playlists!.map((x) => x.toJson())),
  };
}

class Playlist {
  String? playListHeading;
  String? playListImage;
  int? videoHeadingCount;

  Playlist({
    this.playListHeading,
    this.playListImage,
    this.videoHeadingCount,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    playListHeading: json["playList_heading"],
    playListImage: json["playList_image"],
    videoHeadingCount: json["videoHeadingCount"],
  );

  Map<String, dynamic> toJson() => {
    "playList_heading": playListHeading,
    "playList_image": playListImage,
    "videoHeadingCount": videoHeadingCount,
  };
}
