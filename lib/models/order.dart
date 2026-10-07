// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mini_shop_app/models/cart.dart';

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  Order copyWith({
    String? id,
    double? amount,
    List<Cart>? products,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'products': products.map((x) => x.toMap()).toList(),
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      amount: map['amount'] as double,
      products: List<Cart>.from(
        (map['products'] as List<int>).map<Cart>(
          (x) => Cart.fromMap(x as Map<String, dynamic>),
        ),
      ),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
