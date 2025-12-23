import 'package:flutter/material.dart';
import 'package:shopping_app/features/cart/presentation/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class NavProvider with ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void changeIndex(int value, BuildContext context) {
    _index = value;

    if (_index == 1) {
      context.read<CartProvider>().getFromCart();
    }
    notifyListeners();
  }
}
