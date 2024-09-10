import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum ConnectivityStatus {
  WiFi,
  Cellular,
  Offline,
}

class ConnectivityProvider extends ChangeNotifier {
  late Connectivity _connectivity;
  ConnectivityStatus _status = ConnectivityStatus.Offline;

  ConnectivityStatus get status => _status;

  ConnectivityProvider() {
    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Assuming you want to handle the first result in the list
      _updateStatus(results.first);
    });
    initConnectivity();
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    _updateStatus(result as ConnectivityResult);
  }

  void _updateStatus(ConnectivityResult result) {
    ConnectivityStatus newStatus;

    switch (result) {
      case ConnectivityResult.wifi:
        newStatus = ConnectivityStatus.WiFi;
        break;
      case ConnectivityResult.mobile:
        newStatus = ConnectivityStatus.Cellular;
        break;
      case ConnectivityResult.none:
      default:
        newStatus = ConnectivityStatus.Offline;
        break;
    }

    // Only notify listeners if the status has changed
    if (newStatus != _status) {
      _status = newStatus;
      notifyListeners();
    }
  }
}