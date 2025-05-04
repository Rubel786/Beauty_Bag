import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../home/model/product_card_model.dart';

class WishlistProvider with ChangeNotifier {
  List<ProductCardModel> _wishlist = [];

  List<ProductCardModel> get wishlist => _wishlist;

  WishlistProvider() {
    loadWishlist();
  }

  void toggleWishlist(ProductCardModel product) {
    if (_wishlist.any((item) => item.productName == product.productName)) {
      _wishlist.removeWhere((item) => item.productName == product.productName);
      product.isWhishlist = false;
    } else {
      _wishlist.add(product);
      product.isWhishlist = true;
    }
    saveWishlist();
    notifyListeners();
  }

  bool isInWishlist(ProductCardModel product) {
    return _wishlist.any((item) => item.productName == product.productName);
  }

  void saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlistJson = _wishlist.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('wishlist', wishlistJson);
  }

  void loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? wishlistJson = prefs.getStringList('wishlist');

    if (wishlistJson != null) {
      _wishlist = wishlistJson.map((item) => ProductCardModel.fromJson(jsonDecode(item))).toList();
      notifyListeners();
    }
  }
}
