import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _orderItems = [];
  List<Map<String, dynamic>> get orderItems => _orderItems;

  void addToOrder(String name, String imagePath, double price, String discount) {
    int existingIndex = _orderItems.indexWhere((item) => item['name'] == name);
    if (existingIndex != -1) {
      _orderItems[existingIndex]['quantity'] += 1;
    } else {
      _orderItems.add({
        'name': name,
        'imagePath': imagePath,
        'price': price,
        'discount': discount,
        'quantity': 1,
      });

    }
    print(_orderItems);
    notifyListeners();
  }

  void updateQuantity(int index, int delta) {
    _orderItems[index]['quantity'] += delta;
    if (_orderItems[index]['quantity'] <= 0) {
      _orderItems.removeAt(index);
    }
    notifyListeners();
  }

  void clearOrder() {
    _orderItems.clear();
    notifyListeners();
  }
}
