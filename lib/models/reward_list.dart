// To parse this JSON data, do
//
//     final rewardList = rewardListFromJson(jsonString);

import 'dart:convert';

List<RewardList> rewardListFromJson(String str) => List<RewardList>.from(json.decode(str).map((x) => RewardList.fromJson(x)));

String rewardListToJson(List<RewardList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RewardList {
  int? uId;
  int? distributedCoupons;
  dynamic description;
  DateTime? distributionTime;
  int? reward;

  RewardList({
    this.uId,
    this.distributedCoupons,
    this.description,
    this.distributionTime,
    this.reward,
  });

  factory RewardList.fromJson(Map<String, dynamic> json) => RewardList(
    uId: json["UId"],
    distributedCoupons: json["distributed_coupons"],
    description: json["description"],
    distributionTime: json["distribution_time"] == null ? null : DateTime.parse(json["distribution_time"]),
    reward: json["reward"],
  );

  Map<String, dynamic> toJson() => {
    "UId": uId,
    "distributed_coupons": distributedCoupons,
    "description": description,
    "distribution_time": distributionTime?.toIso8601String(),
    "reward": reward,
  };
}
