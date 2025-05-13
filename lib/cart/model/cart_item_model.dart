import 'package:flutter/foundation.dart';

class CartItemModel extends ChangeNotifier {
  int quantity = 1;
  final double unitPrice;

  CartItemModel(this.unitPrice);

  double get total => quantity * unitPrice;

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }
}
