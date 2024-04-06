import 'package:flutter/material.dart';
import 'meditationsetup.dart';
import 'meditationtimer.dart';

class MyPageView extends StatefulWidget {
  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  PageController _pageController = PageController(initialPage: 0);

  final pages = [
    Meditationcycle(),
    TimerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable swiping
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                pages[index],
                //   style: TextStyle(fontSize: 24.0),
                // ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (index < pages.length - 1) {
                      _pageController.jumpToPage(index + 1);
                    }
                  },
                  child: Text(index == pages.length - 1 ? 'Last Page' : 'Next'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
