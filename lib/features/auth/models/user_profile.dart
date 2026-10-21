// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserProfile {
  String id;
  String role;
  String email;
  String? phone;
  String? fullName;

  UserProfile({
    required this.id,
    required this.role,
    required this.email,
    this.phone,
    this.fullName,
  });

  UserProfile copyWith({
    String? id,
    String? role,
    String? email,
    String? phone,
    String? fullName,
  }) {
    return UserProfile(
      id: id ?? this.id,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role,
      'email': email,
      'phone': phone,
      'fullName': fullName,
    };
  }

  factory UserProfile.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    return UserProfile(
      id: id,
      role: map['role'] as String,
      email: map['email'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
    );
  }

  bool get isSeller => role == 'seller';
  bool get isAdmin => role == 'admin';

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson({required String id, required String source}) =>
      UserProfile.fromMap(
        id: id,
        map: json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'UserProfile(id: $id, role: $role, email: $email, phone: $phone, fullName: $fullName)';
  }

  @override
  bool operator ==(covariant UserProfile other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.role == role &&
        other.email == email &&
        other.phone == phone &&
        other.fullName == fullName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        role.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        fullName.hashCode;
  }
}
