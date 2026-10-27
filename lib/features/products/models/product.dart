import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String sellerId;
  final bool isPublic;
  final String category;
  final int stock;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sellerId,
    this.isPublic = true,
    required this.category,
    required this.stock,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? sellerId,
    bool? isPublic,
    String? category,
    int? stock,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      sellerId: sellerId ?? this.sellerId,
      isPublic: isPublic ?? this.isPublic,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'isPublic': isPublic,
      'category': category,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] as double,
      imageUrl: map['imageUrl'] as String,
      sellerId: map['sellerId'] as String,
      isPublic: map['isPublic'] as bool,
      category: map['category'] as String,
      stock: map['stock'] as int,
      rating: map['rating'] as double,
      reviewCount: map['reviewCount'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, sellerId: $sellerId, isPublic: $isPublic, category: $category, stock: $stock, rating: $rating, reviewCount: $reviewCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.sellerId == sellerId &&
        other.isPublic == isPublic &&
        other.category == category &&
        other.stock == stock &&
        other.rating == rating &&
        other.reviewCount == reviewCount &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        imageUrl.hashCode ^
        sellerId.hashCode ^
        isPublic.hashCode ^
        category.hashCode ^
        stock.hashCode ^
        rating.hashCode ^
        reviewCount.hashCode ^
        createdAt.hashCode;
  }
}
