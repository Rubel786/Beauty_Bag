import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_item_model.dart';

class CartModel extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  bool _isUpdating = false;

  bool get isUpdating => _isUpdating;
  List<CartItemModel> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.total);

  CartModel() {
    loadCart();
  }

  void addItem(CartItemModel newItem) {
    final index = _items.indexWhere((item) => item.productName == newItem.productName);
    if (index != -1) {
      _items[index].increment();
    } else {
      _items.add(newItem);
    }
    saveCart();
    notifyListeners();
  }

  void removeItem(CartItemModel item) {
    _items.remove(item);
    saveCart();
    notifyListeners();
  }

  Future<void> incrementItem(CartItemModel item) async {
    _isUpdating = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    item.increment();
    await saveCart();
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
    await saveCart();
    _isUpdating = false;
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('cart_items', cartJson);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList('cart_items');

    if (cartJson != null) {
      _items.clear();
      _items.addAll(
        cartJson.map((item) => CartItemModel.fromJson(jsonDecode(item))),
      );
      notifyListeners();
    }
  }
}