// To parse this JSON data, do
//
//     final financialData = financialDataFromJson(jsonString);

import 'dart:convert';

FinancialData financialDataFromJson(String str) => FinancialData.fromJson(json.decode(str));

String financialDataToJson(FinancialData data) => json.encode(data.toJson());

class FinancialData {
  String? message;
  List<Finconfig>? finconfig;

  FinancialData({
    this.message,
    this.finconfig,
  });

  factory FinancialData.fromJson(Map<String, dynamic> json) => FinancialData(
    message: json["message"],
    finconfig: json["finconfig"] == null ? [] : List<Finconfig>.from(json["finconfig"]!.map((x) => Finconfig.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "finconfig": finconfig == null ? [] : List<dynamic>.from(finconfig!.map((x) => x.toJson())),
  };
}

class Finconfig {
  int? id;
  String? field;
  String? value;

  Finconfig({
    this.id,
    this.field,
    this.value,
  });

  factory Finconfig.fromJson(Map<String, dynamic> json) => Finconfig(
    id: json["id"],
    field: json["field"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "field": field,
    "value": value,
  };
}
