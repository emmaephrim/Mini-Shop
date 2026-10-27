// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserFavorite {
  final Set<String> productIds;
  UserFavorite({required this.productIds});

  //   UserFavorite copyWith({Set<String>? productIds}) {
  //     return UserFavorite(productIds: productIds ?? this.productIds);
  //   }

  //   Map<String, dynamic> toMap() {
  //     return <String, dynamic>{'productIds': productIds.toList()};
  //   }

  //   factory UserFavorite.fromMap(Map<String, dynamic> map) {
  //     final raw = map['productIds'];

  //     if (raw is List) {
  //       return UserFavorite(productIds: raw.map((e) => e.toString()).toSet());
  //     }

  //     if (raw is Set) {
  //       return UserFavorite(productIds: raw.map((e) => e.toString()).toSet());
  //     }

  //     if (raw is Map) {
  //       return UserFavorite(
  //         productIds: raw.keys.map((e) => e.toString()).toSet(),
  //       );
  //     }

  //     return UserFavorite(productIds: <String>{});
  //   }

  //   String toJson() => json.encode(toMap());

  //   factory UserFavorite.fromJson(String source) =>
  //       UserFavorite.fromMap(json.decode(source) as Map<String, dynamic>);

  //   @override
  //   String toString() => 'UserFavorite(productIds: $productIds)';

  //   @override
  //   bool operator ==(covariant UserFavorite other) {
  //     if (identical(this, other)) return true;

  //     return setEquals(other.productIds, productIds);
  //   }

  //   @override
  //   int get hashCode => productIds.hashCode;

  UserFavorite copyWith({Set<String>? productIds}) {
    return UserFavorite(productIds: productIds ?? this.productIds);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'productIds': productIds.toList()};
  }

  factory UserFavorite.fromMap(Map<String, dynamic> map) {
    return UserFavorite(
      productIds: Set<String>.from((map['productIds'] as Set<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserFavorite.fromJson(String source) =>
      UserFavorite.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserFavorite(productIds: $productIds)';

  @override
  bool operator ==(covariant UserFavorite other) {
    if (identical(this, other)) return true;

    return setEquals(other.productIds, productIds);
  }

  @override
  int get hashCode => productIds.hashCode;
}
