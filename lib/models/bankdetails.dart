// To parse this JSON data, do
//
//     final bankDetail = bankDetailFromJson(jsonString);

import 'dart:convert';

BankDetail bankDetailFromJson(String str) => BankDetail.fromJson(json.decode(str));

String bankDetailToJson(BankDetail data) => json.encode(data.toJson());

class BankDetail {
  String? aadarNo;
  String? bankName;
  String? ifscCode;
  String? branchName;
  String? accountName;
  String? accountNo;

  BankDetail({
    this.aadarNo,
    this.bankName,
    this.ifscCode,
    this.branchName,
    this.accountName,
    this.accountNo,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    aadarNo: json["AadarNo"],
    bankName: json["bankName"],
    ifscCode: json["IFSCCode"],
    branchName: json["branchName"],
    accountName: json["accountName"],
    accountNo: json["accountNo"],
  );

  Map<String, dynamic> toJson() => {
    "AadarNo": aadarNo,
    "bankName": bankName,
    "IFSCCode": ifscCode,
    "branchName": branchName,
    "accountName": accountName,
    "accountNo": accountNo,
  };
}
