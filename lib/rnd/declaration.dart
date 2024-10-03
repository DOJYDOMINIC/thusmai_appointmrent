import 'package:flutter/material.dart';

class DeclarationPage extends StatefulWidget {
  @override
  _DeclarationPageState createState() => _DeclarationPageState();
}

class _DeclarationPageState extends State<DeclarationPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Declaration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Declaration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'I hereby declare that the information provided is accurate and true to the best of my knowledge. '
                  'I understand that any misrepresentation or omission may lead to disqualification or legal action.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'By proceeding, I agree to the terms and conditions outlined in the application process.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I confirm that I have read and agree to the declaration.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _isChecked
                  ? () {
                // Action to be performed on button press
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage()), // Replace with your next page
                );
              }
                  : null, // Disable button if checkbox is not checked
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('This is the next page!'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DeclarationPage(),
  ));
}
