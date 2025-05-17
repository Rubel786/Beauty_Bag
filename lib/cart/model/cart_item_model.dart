import 'package:flutter/foundation.dart';

class CartItemModel with ChangeNotifier {
  int quantity;
  final String productName;
  final String productImageUrl;
  final double unitPrice;

  CartItemModel({
    required this.productName,
    required this.productImageUrl,
    required this.unitPrice,
    this.quantity = 1,
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

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productImageUrl': productImageUrl,
      'unitPrice': unitPrice,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productName: json['productName'],
      productImageUrl: json['productImageUrl'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}