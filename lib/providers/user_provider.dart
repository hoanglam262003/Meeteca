import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _modalShown = false;
  bool get modalShown => _modalShown;
  int? _id = 0 ;
  int? get id => _id;
  String? _token = '';
  String? get token => _token;
  DateTime? _ex;
  DateTime? get ex => _ex;
  int? _role = null;
  int? get role => _role;
  final box = GetStorage();
  UserProvider() {
    setTokenDefault();
    if(isTokenExpired()){
      removeToken();
    };
  }

  void setLoading(bool n) {
    _isLoading = n;
    notifyListeners();
  }

  bool isTokenExpired() {
    String? expiryString = box.read('token_expiry');
    if (expiryString == null) return true;
    DateTime expiryDate = DateTime.parse(expiryString);
    return DateTime.now().isAfter(expiryDate);
  }

  void removeToken() {
    box.remove('token');
    _token = '';
    box.remove('token_expiry');
    _ex = null;
    box.remove('role');
    _role = null;
    box.remove('user_id');
    _id = 0;
    notifyListeners();
  }

  void setTokenDefault() {
    _token = box.read('token');
    final expiryString = box.read('token_expiry');
    _ex = expiryString != null ? DateTime.parse(expiryString) : null;
    _role = box.read('role');
    _id = box.read('user_id');
    notifyListeners();
  }

  void setToken(String? token, DateTime? ex, int? role, int? userID) {
    box.write('user_id', userID);
    _id = userID;
    box.write('token', token);
    _token = token;
    box.write('token_expiry', ex?.toIso8601String());
    _ex = ex;
    box.write('role', role);
    _role = role;
    print(_token);
    notifyListeners();
  }
}