import 'package:flutter/foundation.dart';

class CartItemModel with ChangeNotifier {
  final int id;
  int quantity;
  final String productName;
  final String productImageUrl;
  final double unitPrice;
  final double rating;



  CartItemModel({
    required this.id,
    required this.rating,
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
      'id': id,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'rating': rating,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      rating: (json['rating'] as num).toDouble(),
      productName: json['productName'],
      productImageUrl: json['productImageUrl'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}