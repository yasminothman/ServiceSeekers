import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> cartItems = [];

  void addToCart(Map<String, dynamic> cartItem) {
    cartItems.add(cartItem);
    notifyListeners();
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    notifyListeners();
  }

  // Add other methods as needed for managing the cart
}
