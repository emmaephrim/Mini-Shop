// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:mini_shop_app/widgets/cart_item.dart';

class Order {
  final String id;
  final String amount;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  Order copyWith({
    String? id,
    String? amount,
    List<CartItem>? products,
    DateTime? dateTime,
  }) {
    return Order(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, amount: $amount, products: $products, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.amount == amount &&
        listEquals(other.products, products) &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        products.hashCode ^
        dateTime.hashCode;
  }
}
