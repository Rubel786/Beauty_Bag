// File: models/product_detail.dart

class ProductDetailModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final List<String> images;
  final String brand;
  final String category;
  final int stock;
  final String warrantyInformation;
  final double discountPercentage;


  ProductDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.images,
    required this.brand,
    required this.category,
    required this.stock,
    required this.warrantyInformation,
    required this.discountPercentage,

  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {

    return ProductDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      images: List<String>.from(json['images']),
      brand: json['brand'] ?? "NA",
      category: json['category'],
      stock: json['stock'],
      warrantyInformation: json['warrantyInformation'],
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
    );
  }
}
