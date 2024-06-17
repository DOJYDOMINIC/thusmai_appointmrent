// To parse this JSON data, do
//
//     final listQuestions = listQuestionsFromJson(jsonString);

import 'dart:convert';

List<ListQuestions> listQuestionsFromJson(String str) => List<ListQuestions>.from(json.decode(str).map((x) => ListQuestions.fromJson(x)));

String listQuestionsToJson(List<ListQuestions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListQuestions {
  int? id;
  String? question;
  String? ans1;
  String? ans2;
  String? ans3;
  String? ans4;
  String? ans5;
  String? conditions;

  ListQuestions({
    this.id,
    this.question,
    this.ans1,
    this.ans2,
    this.ans3,
    this.ans4,
    this.ans5,
    this.conditions,
  });

  factory ListQuestions.fromJson(Map<String, dynamic> json) => ListQuestions(
    id: json["id"],
    question: json["question"],
    ans1: json["ans1"],
    ans2: json["ans2"],
    ans3: json["ans3"],
    ans4: json["ans4"],
    ans5: json["ans5"],
    conditions: json["conditions"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "ans1": ans1,
    "ans2": ans2,
    "ans3": ans3,
    "ans4": ans4,
    "ans5": ans5,
    "conditions": conditions,
  };
}
