// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class ConnectivityProvider extends ChangeNotifier {
//   ConnectivityResult _connectionStatus = ConnectivityResult.none; // To store the current connection status
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _connectivitySubscription;
//
//   ConnectivityResult get connectionStatus => _connectionStatus; // Getter for connection status
//
//   ConnectivityProvider() {
//     _initializeConnectivity(); // Call the initialization method in the constructor
//   }
//
//   // Initialize connectivity and start listening for changes
//   Future<void> _initializeConnectivity() async {
//     await _checkInitialConnectivity();
//     _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
//   }
//
//   // Check the initial connectivity status
//   Future<void> _checkInitialConnectivity() async {
//     try {
//       final result = await _connectivity.checkConnectivity();
//       _updateConnectionStatus(result as ConnectivityResult); // Update the status when app starts
//     } on PlatformException catch (e) {
//       print('Could not check connectivity: $e');
//       return;
//     }
//   }
//
//   // Update the connectivity status and notify listeners
//   void _updateConnectionStatus(ConnectivityResult result) {
//     if (_connectionStatus != result) { // Update only if the status has changed
//       _connectionStatus = result;
//       notifyListeners(); // Notify listeners about the change
//     }
//   }
//
//   // Dispose of the stream subscription when done
//   @override
//   void dispose() {
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }
// }
