// lib/model/cart_model.dart
import 'package:flutter/foundation.dart';
import 'cart_item_model.dart';

class CartModel extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  void addItem(CartItemModel item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  double get total => _items.fold(0, (sum, item) => sum + item.total);
}
