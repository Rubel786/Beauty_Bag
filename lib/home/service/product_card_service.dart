import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beauty_bag/home/model/product_card_model.dart';

class ProductCardService {
  static const String apiUrl = 'https://dummyjson.com/products';

  Future<List<ProductCardModel>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print("API Response: ${jsonEncode(jsonResponse)}"); // 🐛 Debugging output

      if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('products')) {
        List<dynamic> productList = jsonResponse['products'];
        return productList.map((data) => ProductCardModel.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected JSON format: Expected a Map with "products" key');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch a single product by ID
  Future<ProductCardModel> fetchProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ProductCardModel.fromJson(data);
      } else {
        throw Exception('Failed to fetch product: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to fetch product: $error');
    }
  }

}