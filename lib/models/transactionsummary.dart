// To parse this JSON data, do
//
//     final transactionSummary = transactionSummaryFromJson(jsonString);

import 'dart:convert';

TransactionSummary transactionSummaryFromJson(String str) => TransactionSummary.fromJson(json.decode(str));

String transactionSummaryToJson(TransactionSummary data) => json.encode(data.toJson());

class TransactionSummary {
  String? message;
  int? totaltrust;
  int? totalguru;
  int? totalTransactionCount;
  int? total;

  TransactionSummary({
    this.message,
    this.totaltrust,
    this.totalguru,
    this.totalTransactionCount,
    this.total,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) => TransactionSummary(
    message: json["message"],
    totaltrust: json["totaltrust"],
    totalguru: json["totalguru"],
    total: json["total"],
    totalTransactionCount: json["totalTransactionCount"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "total": total,
    "totaltrust": totaltrust,
    "totalguru": totalguru,
    "totalTransactionCount": totalTransactionCount,
  };
}
