import 'package:flutter/material.dart';

class AuthenticationState extends ChangeNotifier {

  bool _isAuthenticating = false;
  String _authorized = '';

  bool get isAuthenticating => _isAuthenticating;
  String get authorized => _authorized;

  void setIsAuthenticating(bool value) {
    _isAuthenticating = value;
    notifyListeners();
  }

  void setAuthorized(bool value) {
    _authorized = value ? 'Authorized' : 'Not Authorized';
    notifyListeners();
  }
}