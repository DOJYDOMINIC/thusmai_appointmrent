import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:convert'; // For JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/controller/healt_controller.dart';
import 'package:thusmai_appointmrent/health/health_page.dart';
import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';

import '../constant/constant.dart';
import '../pages/bottom_navbar.dart';

class gurujiDataCollection extends StatefulWidget {
  @override
  _gurujiDataCollectionState createState() => _gurujiDataCollectionState();
}

class _gurujiDataCollectionState extends State<gurujiDataCollection> {
  // Controllers for date fields
  TextEditingController _dateOfJoiningController = TextEditingController();
  TextEditingController _dateOfStartingController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  List<dynamic> formData = [];
  bool _isAgreed = false;


  @override
  void initState() {
    super.initState();
    // Provider.of<HealthController>(context, listen: false).healthPostQuestion();
  Provider.of<HealthController>(context, listen: false).healthQuestion();
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

  Future<void> sendSleepData() async {
    Map<String, dynamic> postData = {
      'answers': formData.map((item) {
        return {
          'question': item['question'],
          'answer': item['selected'] ?? 'No',
        };
      }).toList(),
    };
    postHealthData(postData);
  }

  Future<void> postHealthData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    try {
      var response = await http.post(
        Uri.parse("$baseUrl/rnd/submit-health-data"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies, // Add cookie if present
        },
        body: jsonEncode(data), // Convert model to JSON
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WebView(),));
        launchURL(Uri.parse("https://starlife.co.in/health/"));

        print('Health data submitted successfully');
      } else {
        print('Failed to submit health data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error submitting health data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
 formData  = Provider.of<HealthController>(context).questions;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomBottomNavBar(),));

        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        backgroundColor: darkShade,
        title: Text(
          "",
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(
                    'I agree to share my physical and mental health details with Tasmai spiritual researchers',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify, // Justifies the text
                  ),
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
