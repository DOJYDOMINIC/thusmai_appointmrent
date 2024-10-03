import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:convert'; // For JSON decoding and encoding
import 'package:http/http.dart' as http;

import '../constant/constant.dart';

class SleepData extends StatefulWidget {
  @override
  _SleepDataState createState() => _SleepDataState();
}

class _SleepDataState extends State<SleepData> {
  // Controllers for date fields
  TextEditingController _dateOfJoiningController = TextEditingController();
  TextEditingController _dateOfStartingController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  // Updated sample data for the new data structure
  List<dynamic> sampleData = [
    {
      "question": "How often do you feel overwhelmed by stress?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "Which of the following causes you the most stress?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "How do you usually cope with stress?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "Describe a recent situation that made you feel stressed.",
      "ans": ["Yes", "No"]
    },
    {
      "question": "How often do you feel anxious?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "Do you take time for self-care activities?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "What activities help you relax?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "How well do you sleep when stressed?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "How frequently do you experience physical symptoms of stress?",
      "ans": ["Yes", "No"]
    },
    {
      "question": "What changes would you like to make to reduce your stress levels?",
      "ans": ["Very bad", "Bad", "Good", "Very Good"]
    }
  ];


  // Data for the dynamic list
  List<dynamic> formData = [];
  bool _isAgreed = false;
  // Mock API Call to fetch data
  Future<void> fetchData() async {
    // Simulating network delay
    await Future.delayed(Duration(seconds: 1));

    // Set the form data with sample data
    setState(() {
      formData = sampleData;
    });
  }

  // Function to send POST request with collected form data
  Future<void> sendSleepData() async {
    Map<String, dynamic> postData = {
      'answers': formData.map((item) {
        return {
          'question': item['question'],
          'answer': item['selected'] ?? 'No',
        };
      }).toList(),
    };

print(postData);
    // Simulating POST request response
    await Future.delayed(Duration(seconds: 1)); // Simulating network delay
    print('Data submitted successfully');
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch API data when page loads
  }

  // Date picker function
  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        backgroundColor: darkShade,
        title: Text(
          "Data Collection",
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView for scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            formData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              shrinkWrap: true, // Allow ListView to take up only the space it needs
              physics: NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
              itemCount: formData.length,
              itemBuilder: (context, index) {
                var item = formData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display question with index
                    Text(
                      '${index + 1} : ${item['question']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Render dropdown for answers if available
                    if (item['ans'].isNotEmpty)
                      DropdownButtonFormField(
                        decoration: InputDecoration(border: OutlineInputBorder()),
                        value: item['selected'],
                        onChanged: (value) {
                          setState(() {
                            item['selected'] = value;
                          });
                        },
                        items: item['ans']
                            .map<DropdownMenuItem<String>>((answer) {
                          return DropdownMenuItem<String>(
                            value: answer,
                            child: Text(answer),
                          );
                        }).toList(),
                      ),
                    if (item['ans'].isEmpty) // Text input for questions without predefined answers
                      TextFormField(
                        onChanged: (value) {
                          item['answer'] = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type your answer here',
                        ),
                      ),
                    SizedBox(height: 16),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value ?? false; // Update the checkbox state
                    });
                  },
                ),
                // Text label for consent
                Text(
                  'I agree to the terms and conditions',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed:!_isAgreed ?null: () {
                sendSleepData(); // Call the function to send data when button is pressed
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                backgroundColor: goldShade,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Submit", style: TextStyle(color: darkShade)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
