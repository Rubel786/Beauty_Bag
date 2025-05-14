// lib/model/cart_item_model.dart
import 'package:flutter/foundation.dart';

class CartItemModel extends ChangeNotifier {
  int quantity = 1;
  final String productName;
  final String productImageUrl;
  final double unitPrice;

  CartItemModel({
    required this.productName,
    required this.productImageUrl,
    required this.unitPrice,
  });

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
