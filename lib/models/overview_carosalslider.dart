// To parse this JSON data, do
//
//     final sliderEvents = sliderEventsFromJson(jsonString);

import 'dart:convert';

import '../constant/constant.dart';

SliderEvents sliderEventsFromJson(String str) => SliderEvents.fromJson(json.decode(str));

String sliderEventsToJson(SliderEvents data) => json.encode(data.toJson());

class SliderEvents {
  List<EventData>? events;

  SliderEvents({
    this.events,
  });

  factory SliderEvents.fromJson(Map<String, dynamic> json) => SliderEvents(
    events: json["events"] == null ? [] : List<EventData>.from(json["events"]!.map((x) => EventData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "events": events == null ? [] : List<dynamic>.from(events!.map((x) => x.toJson())),
  };
}

class EventData {
  int? id;
  String? eventName;
  String? eventDescription;
  String? priority;
  String? place;
  String? date;
  String? eventTime;
  String? image;

  EventData({
    this.id,
    this.eventName,
    this.eventDescription,
    this.priority,
    this.place,
    this.date,
    this.eventTime,
    this.image,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    id: json["id"],
    eventName: json["event_name"],
    eventDescription: json["event_description"],
    priority: json["priority"],
    place: json["place"],
    date: json["date"],
    // date: json["date"] == null ? null : DateTime.parse(json["date"]),
    eventTime: json["event_time"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_name": eventName,
    "event_description": eventDescription,
    "priority": priority,
    "place": place,
    "date": date,
    // "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "event_time": eventTime,
    "image": image,
  };
}
