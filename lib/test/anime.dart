// import 'package:flutter/material.dart';
//
// class ListViewBuilderExample extends StatefulWidget {
//   @override
//   _ListViewBuilderExampleState createState() => _ListViewBuilderExampleState();
// }
//
// class _ListViewBuilderExampleState extends State<ListViewBuilderExample> {
//   int? expandedIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Animated Container ListView'),
//         ),
//         body: ListView.builder(
//           itemCount: 10, // Adjust the item count as needed
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   // If the tapped index is already expanded, collapse it
//                   if (expandedIndex == index) {
//                     expandedIndex = null;
//                   } else {
//                     // Otherwise, expand the tapped index and collapse the previously expanded index
//                     expandedIndex = index;
//                   }
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 500),
//                 height: expandedIndex == index ? 110 : 50, // Change height based on expansion state
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.blue,
//                 ),
//                 margin: EdgeInsets.all(8),
//                 child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           'Item $index',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                         if (expandedIndex == index) ...[
//                           Text("dart"),
//                           Text("dart"),
//                           Text("dart"),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

