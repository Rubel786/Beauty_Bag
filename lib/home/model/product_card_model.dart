class ProductCardModel {
  final int id;
  final String productName;
  final String rating;
  final String price;
  final List<String> images; // All product images
  bool isWhishlist; // Make this mutable
  final bool isPopular;

  ProductCardModel({
    required this.id,
    required this.productName,
    required this.rating,
    required this.price,
    required this.images,
    this.isWhishlist = false,
    this.isPopular = false,
  });

  factory ProductCardModel.fromJson(Map<String, dynamic> json) {
    return ProductCardModel(
      id: json['id'] ?? 0,
      productName: json['productName'] ?? json['title'] ?? "Unknown Product", // support both
      images: json['images'] != null && json['images'] is List
              ? List<String>.from(json['images'])
              : [],
      rating: json['rating']?.toString() ?? "0.0",
      price: json['price']?.toString() ?? "0.0",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'images': images,
      'rating': rating,
      'price': price,
      'isWhishlist': isWhishlist,
      'isPopular': isPopular,
    };
  }

  // Ensure proper object comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductCardModel && other.productName == productName;
  }

  @override
  int get hashCode => productName.hashCode;
}
