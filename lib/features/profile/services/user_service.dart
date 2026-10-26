import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/network/dio_provider.dart';
import 'package:mini_shop_app/features/profile/models/user_profile.dart';

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(dio: ref.read(dioProvider)),
);

class UserService {
  final Dio _dio;
  UserService({required this._dio});

  Future<UserProfile?> fetchUserProfile(String uid) async {
    final response = await _dio.get('/users/$uid.json');

    if (response.data == 'null') return null;
    if (response.statusCode! >= 400) return null;

    final data = UserProfile.fromMap(id: uid, map: response.data);
    return data;
  }

  Future<String> uploadAvatarToStorage(String uid, File imageFile) async {
    // Create a folder called 'avatars' and name the file after the users's ID
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child('$uid.jpg');
    // upload file
    await storageRef.putFile(imageFile);
    // Get the secure download URL
    return await storageRef.getDownloadURL();
  }

  Future<void> updateProfileAvatar(String uid, String avatarUrl) async {
    await _dio.patch('/users/$uid.json', data: {'avatarUrl': avatarUrl});
  }
}
