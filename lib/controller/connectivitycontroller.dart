import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

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
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateStatus(result);
    });
    initConnectivity();
    notifyListeners();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        _status = ConnectivityStatus.WiFi;
        break;
      case ConnectivityResult.mobile:
        _status = ConnectivityStatus.Cellular;
        break;
      case ConnectivityResult.none:
        _status = ConnectivityStatus.Offline;
        break;
      default:
        _status = ConnectivityStatus.Offline;
        break;
    }
    notifyListeners();
  }
}
