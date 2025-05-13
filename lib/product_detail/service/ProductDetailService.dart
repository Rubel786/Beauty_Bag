import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_detail_model.dart';


class ProductDetailService{
  static const String apiUrl = 'https://dummyjson.com/products';

  Future<ProductDetailModel> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/$id'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return ProductDetailModel.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load product detail');
    }
  }

}