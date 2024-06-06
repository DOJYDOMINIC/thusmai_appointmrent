import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';  // Import the dart:async library for Timer

class ShimmerContainer extends StatefulWidget {
  final double width;
  final double height;

  ShimmerContainer({required this.width, required this.height});

  @override
  _ShimmerContainerState createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer> {
  bool _showText = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer that sets _showText to true after 10 seconds
    _timer = Timer(Duration(seconds: 10), () {
      setState(() {
        _showText = true;
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer if it's still active
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showText
        ? Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.grey.shade100,
      ),
          child: Center(
                child: Text(
          widget.width > 100 ? "Data not Available" : "N/A",
          style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
        )
        : Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.grey.shade100,
        ),
      ),
    );
  }
}
