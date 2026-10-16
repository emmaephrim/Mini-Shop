import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Cart({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });

  Cart copyWith({String? id, String? title, int? quantity, double? price}) {
    return Cart(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map['id'] as String,
      title: map['title'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) =>
      Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cart(id: $id, title: $title, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(covariant Cart other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.quantity == quantity &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ quantity.hashCode ^ price.hashCode;
  }
}
