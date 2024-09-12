// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Blog>? blogs;
  int? totalPages;

  Welcome({
    this.blogs,
    this.totalPages,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    blogs: json["blogs"] == null ? [] : List<Blog>.from(json["blogs"]!.map((x) => Blog.fromJson(x))),
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "blogs": blogs == null ? [] : List<dynamic>.from(blogs!.map((x) => x.toJson())),
    "totalPages": totalPages,
  };
}

class Blog {
  int? id;
  String? title;
  String? description;
  String? date;
  String? eventTime = "";
  String? image;

  Blog({
    this.id,
    this.title,
    this.description,
    this.date,
    this.image,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
    id: json["id"],
    title: json["blog_name"],
    description: json["blog_description"],
    date: json["date"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "blog_name": title,
    "blog_description": description,
    "date": date,
    "image": image,
  };
}
