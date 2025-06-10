import 'package:flutter/material.dart';
import 'package:beauty_bag/home/model/product_card_model.dart';
import 'package:beauty_bag/home/service/product_card_service.dart';


class ProductCardViewModel extends ChangeNotifier {
  final ProductCardService _productCardService = ProductCardService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ProductCardModel> _products = [];
  List<ProductCardModel> get products => _products ;

  List<ProductCardModel> _allProducts = [];
  List<ProductCardModel> get limitedProducts => _allProducts.take(10).toList();

  ProductCardModel? _product;
  ProductCardModel? get product => _product;

  ProductCardViewModel() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _productCardService.fetchProducts(); // ✅ Populate this
      _products = _allProducts; // Optional: in case both are needed separately
      _isLoading = false;
      notifyListeners(); // ✅ Notify after update
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    }
  }


}