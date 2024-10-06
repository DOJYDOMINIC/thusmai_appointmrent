// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'dart:convert'; // For JSON decoding and encoding
// import 'package:http/http.dart' as http;
// import 'package:thusmai_appointmrent/rnd/guruji_questions.dart';
//
// import '../constant/constant.dart';
// import '../widgets/additionnalwidget.dart';
//
// class StressData extends StatefulWidget {
//   @override
//   _StressDataState createState() => _StressDataState();
// }
//
// class _StressDataState extends State<StressData> {
//   // Controllers for date fields
//   TextEditingController _dateOfJoiningController = TextEditingController();
//   TextEditingController _dateOfStartingController = TextEditingController();
//   TextEditingController _dateController = TextEditingController();
//
//   // Sample data for the dynamic list
//   List<dynamic> sampleData = [
//     {
//       "type": "dropdown",
//       "question": "How often do you feel overwhelmed by stress?",
//       "options": [
//         {"label": "Never", "score": 0},
//         {"label": "Rarely", "score": 1},
//         {"label": "Sometimes", "score": 2},
//         {"label": "Often", "score": 3},
//         {"label": "Always", "score": 4},
//       ],
//       "selected": null,
//       "selectedScore": null,
//     },
//     {
//       "type": "dropdown",
//       "question": "Which of the following causes you the most stress?",
//       "options": [
//         {"label": "Work", "score": 3},
//         {"label": "Relationships", "score": 4},
//         {"label": "Finances", "score": 5},
//         {"label": "Health", "score": 2},
//         {"label": "Other", "score": 1},
//       ],
//       "selected": null,
//       "selectedScore": null,
//     },
//     {
//       "type": "dropdown",
//       "question": "How do you usually cope with stress?",
//       "options": [
//         {"label": "Exercise", "score": 3},
//         {"label": "Meditation", "score": 4},
//         {"label": "Talking to friends", "score": 2},
//         {"label": "Eating comfort food", "score": 1},
//         {"label": "Other", "score": 0},
//       ],
//       "selected": null,
//       "selectedScore": null,
//     },
//     {
//       "type": "text",
//       "question": "Describe a recent situation that made you feel stressed.",
//       "answer": null,
//       "score": 10,
//     },
//     {
//       "type": "dropdown",
//       "question": "How often do you feel anxious?",
//       "options": [
//         {"label": "Never", "score": 0},
//         {"label": "Sometimes", "score": 1},
//         {"label": "Often", "score": 2},
//         {"label": "Very often", "score": 3},
//       ],
//       "selected": null,
//       "selectedScore": null,
//     },
//     {
//       "type": "dropdown",
//       "question": "Do you take time for self-care activities?",
//       "options": [
//         {"label": "Yes", "score": 2},
//         {"label": "No", "score": 0},
//       ],
//       "selected": null,
//       "selectedScore": null,
//     },
//     {
//       "type": "text",
//       "question": "What activities help you relax?",
//       "answer": null,
//       "score": 5,
//     },
//     {
//       "type": "dropdown",
//       "question": "How well do you sleep when stressed?",
//       "options": [
//         {"label": "Very well", "score": 3},
//         {"label": "Well", "score": 2},
//         {"label": "Not well", "score": 1},
//         {"label": "Very poorly", "score": 0},
//       ],
//       "selected": null,
//       "selectedScore": null,
//     },
//     {
//       "type": "dropdown",
//       "question": "How frequently do you experience physical symptoms of stress (e.g., headaches, fatigue)?",
//       "options": [
//         {"label": "Never", "score": 0},
//         {"label": "Rarely", "score": 1},
//         {"label": "Sometimes", "score": 2},
//         {"label": "Often", "score": 3},
//       ],
//       "selected": null,
//       "selectedScore": null,
//     },
//     {
//       "type": "text",
//       "question": "What changes would you like to make to reduce your stress levels?",
//       "answer": null,
//       "score": 8,
//     },
//   ];
//
//   // Data for the dynamic list
//   List<dynamic> formData = [];
//
//   // Mock API Call to fetch data
//   Future<void> fetchData() async {
//     // Simulating network delay
//     await Future.delayed(Duration(seconds: 1));
//
//     // Set the form data with sample data
//     setState(() {
//       formData = sampleData;
//     });
//   }
//
//   // Function to send POST request with collected form data
//   Future<void> sendStressData() async {
//     Map<String, dynamic> postData = {
//       'date_of_joining': _dateOfJoiningController.text,
//       'date_of_starting': _dateOfStartingController.text,
//       'date': _dateController.text,
//       'answers': formData.map((item) {
//         if (item['type'] == 'dropdown') {
//           return {
//             'question': item['question'],
//             'answer': item['selected'] ?? 'No answer selected',
//             'score': item['selectedScore'] ?? 0, // Send the selected option's score
//           };
//         } else if (item['type'] == 'text') {
//           return {
//             'question': item['question'],
//             'answer': item['answer'] ?? 'No answer provided',
//             'score': item['score'], // Send the predefined score for text answers
//           };
//         }
//         return null;
//       }).toList(),
//     };
//
//     print(postData); // Optional: for debugging purposes, you can print the data being sent
//     // Navigator.push(context, MaterialPageRoute(builder: (context) => SleepData(),));
//
//     // Simulating POST request response
//     await Future.delayed(Duration(seconds: 1)); // Simulating network delay
//     print('Data submitted successfully');
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData(); // Fetch API data when page loads
//   }
//
//   // Date picker function
//   Future<void> _selectDate(TextEditingController controller) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         controller.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Stress'),
//       ),
//       body: SingleChildScrollView( // Use SingleChildScrollView for scrolling
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Date of Joining Field
//             TextFormField(
//               controller: _dateOfJoiningController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: 'Date of Joining',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.calendar_today),
//                   onPressed: () => _selectDate(_dateOfJoiningController),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Date of Starting Field
//             TextFormField(
//               controller: _dateOfStartingController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: 'Date of Starting',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.calendar_today),
//                   onPressed: () => _selectDate(_dateOfStartingController),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Date Field
//             TextFormField(
//               controller: _dateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: 'Date',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.calendar_today),
//                   onPressed: () => _selectDate(_dateController),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Dynamic List
//             formData.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               shrinkWrap: true, // Allow ListView to take up only the space it needs
//               physics: NeverScrollableScrollPhysics(), // Disable scrolling in the ListView
//               itemCount: formData.length,
//               itemBuilder: (context, index) {
//                 var item = formData[index];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Display question with index
//                     Text(
//                       '${index + 1} : ${item['question']}',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     // Render the appropriate input based on type
//                     if (item['type'] == 'dropdown')
//                       DropdownButtonFormField(
//                         decoration: InputDecoration(border: OutlineInputBorder()),
//                         value: item['selected'],
//                         onChanged: (value) {
//                           setState(() {
//                             item['selected'] = value;
//                             item['selectedScore'] = item['options']
//                                 .firstWhere((option) => option['label'] == value)['score'];
//                           });
//                         },
//                         items: item['options']
//                             .map<DropdownMenuItem<String>>((option) {
//                           return DropdownMenuItem<String>(
//                             value: option['label'],
//                             child: Text(option['label']),
//                           );
//                         }).toList(),
//                       ),
//                     if (item['type'] == 'text')
//                       TextFormField(
//                         onChanged: (value) {
//                           item['answer'] = value;
//                         },
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'Type your answer here',
//                         ),
//                       ),
//                     SizedBox(height: 16),
//                   ],
//                 );
//               },
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: sendStressData,
//               style: ElevatedButton.styleFrom(
//                 shadowColor: Colors.black,
//                 backgroundColor: goldShade,
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Continue", style: TextStyle(color: darkShade)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
