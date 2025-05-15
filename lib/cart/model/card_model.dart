import 'package:flutter/foundation.dart';
import 'cart_item_model.dart';

class CartModel extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  void addItem(CartItemModel newItem) {
    // Check if item already exists based on name (you could also use a product ID instead)
    final index = _items.indexWhere((item) => item.productName == newItem.productName);

    if (index != -1) {
      // Item already in cart → increase quantity
      _items[index].increment();
    } else {
      // New item → add to cart
      _items.add(newItem);
    }

    notifyListeners();
  }

  void removeItem(CartItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0, (total, current) => total + current.total);
}
