import 'package:flutter/material.dart';

import 'cart_item_model.dart';

class CartModel extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  List<CartItemModel> get items => _items;

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.total);

  void addItem(CartItemModel newItem) {
    // Check if item exists already
    final existing = _items.indexWhere(
            (item) => item.productName == newItem.productName);
    if (existing != -1) {
      _items[existing].increment();
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(CartItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  Future<void> incrementItem(CartItemModel item) async {
    _isUpdating = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    item.increment();
    _isUpdating = false;
    notifyListeners();
  }

  Future<void> decrementItem(CartItemModel item) async {
    _isUpdating = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    if (item.quantity > 1) {
      item.decrement();
    } else {
      _items.remove(item);
    }
    _isUpdating = false;
    notifyListeners();
  }
}
