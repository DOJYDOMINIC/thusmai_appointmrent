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
  String? blogName;
  String? blogDescription;
  String? date;
  String? image;

  Blog({
    this.id,
    this.blogName,
    this.blogDescription,
    this.date,
    this.image,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
    id: json["id"],
    blogName: json["blog_name"],
    blogDescription: json["blog_description"],
    date: json["date"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "blog_name": blogName,
    "blog_description": blogDescription,
    "date": date,
    "image": image,
  };
}
