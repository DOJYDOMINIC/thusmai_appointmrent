import 'package:flutter/material.dart';

import '../constant/constant.dart';

class AnimatedContainerWidget extends StatefulWidget {
  @override
  _AnimatedContainerWidgetState createState() =>
      _AnimatedContainerWidgetState();
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Change duration according to your requirement
    );

    final CurvedAnimation curve =
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _animation = Tween<double>(
      begin: 0.5, // Starting from 0.5 (50% size)
      end: 1.0,
    ).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_isZoomed) {
          _controller.reverse();
          _isZoomed = true;
        } else if (status == AnimationStatus.dismissed && _isZoomed) {
          _isZoomed = false;
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Container'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  width: 200 * _animation.value,
                  height: 200 * _animation.value,
                  // color: Colors.blue,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage(logo))),
                  // You can add any other properties for the container
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


