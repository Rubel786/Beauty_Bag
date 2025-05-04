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
      _products = await _productCardService.fetchProducts();
      _isLoading = false;
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      print("Login Error: $error");
      notifyListeners();// Print error to logs
    }
  }

  Future<void> fetchProductById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _product = await _productCardService.fetchProductById(id);
      _isLoading = false;
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      print("Login Error: $error");
      notifyListeners();
    }
  }

}