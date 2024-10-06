import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';

class HealthController extends ChangeNotifier {
  List<dynamic> get questions => _questions;
  List<dynamic> _questions = [];

  Future<void> healthQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    // print(cookies);
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/rnd/get-health-questions"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies, // Ensure cookie is added if present
        },
      );
      if (response.statusCode == 200) {
        final dataList = jsonDecode(response.body);
        _questions = dataList["data"];
        // print(_questions);
      } else {
        print('Failed to load health questions: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching health questions: $e');
    }
    notifyListeners();
  }

  Future<void> healthPostQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    // print(cookies);

    List<HealthQuestion> healthQuestions = [
      HealthQuestion(
        question: 'Do you have lifestyle diseases?',
        answers: ['Yes', 'No'],
      ),
      HealthQuestion(
        question: 'Do you have any other diseases?',
        answers: ['Yes', 'No'],
      ),
      HealthQuestion(
        question: 'Are you a complete vegetarian?',
        answers: ['Yes', 'No'],
      ),
      HealthQuestion(
        question: 'Do you want to live in cosmic dharma?',
        answers: ['Yes', 'No'],
      ),
      HealthQuestion(
        question: 'Do you have depression or any mental disorders?',
        answers: ['Yes', 'No'],
      ),
      HealthQuestion(
        question: 'Would you like to improve your mental and physical health condition?',
        answers: ['Yes', 'No'],
      ),
      HealthQuestion(
        question: 'Please rate your current physical health condition?',
        answers: ['Very Bad', 'Bad', 'Good', 'Very Good'],
      ),
    ];


    try {
      var response = await http.post(
        Uri.parse("$baseUrl/rnd/submit-health-questions"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies, // Add cookie header for post as well
        },
        body: jsonEncode(healthQuestions.map((q) => q.toJson()).toList()), // Properly serialize the list of questions
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        print('Failed to submit health questions: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error submitting health questions: $e');
    }
    notifyListeners();
  }


  bool _rndPreQuestion = false; // Variable to store Rndprequestion value
  bool get rndPreQuestion => _rndPreQuestion;

  // Function to fetch the Rndprequestion value from API
  Future<void> fetchRndPreQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    try {
      var response = await http.get(
        Uri.parse("$baseUrl/rnd/fetch-rndprequestion"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies, // Add cookie header for post as well
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data["data"] != null && data["data"]["Rndprequestion"] != null) {
          // Set the fetched value to the variable
          _rndPreQuestion = data["data"]["Rndprequestion"];
          print(rndPreQuestion);
          notifyListeners(); // Notify listeners to update UI if required
        }
      } else {
        print('Failed to fetch Rndprequestion: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching Rndprequestion: $e');
    }
  }

}

class HealthQuestion {
  final String question;
  final List<String> answers;

  HealthQuestion({
    required this.question,
    required this.answers,
  });

  // Convert the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'questions': question,
      'answers': answers,
    };
  }
}

class HealthAnswer {
  final String question;
  final String answer;

  HealthAnswer({
    required this.question,
    required this.answer,
  });

  // Convert the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

