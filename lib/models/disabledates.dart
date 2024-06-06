import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package for parsing

// Functions to convert JSON string to DisableDates object and vice versa
DisableDates disableDatesFromJson(String str) => DisableDates.fromJson(json.decode(str));

String disableDatesToJson(DisableDates data) => json.encode(data.toJson());

class DisableDates {
  String? message;
  List<DateTime>? disabledDates;

  DisableDates({
    this.message,
    this.disabledDates,
  });

  // Factory constructor to create DisableDates object from JSON
  factory DisableDates.fromJson(Map<String, dynamic> json) => DisableDates(
    message: json["message"],
    disabledDates: json["values"] == null
        ? []
        : List<DateTime>.from(json["values"].map((dateStr) => DateFormat("yyyy,MM,dd").parse(dateStr))),
  );

  // Method to convert DisableDates object to JSON
  Map<String, dynamic> toJson() => {
    "message": message,
    "values": disabledDates == null
        ? []
        : List<dynamic>.from(disabledDates!.map((date) => DateFormat("yyyy,MM,dd").format(date))),
  };
}