import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/profile/controllers/user_provider.dart';
import 'package:mini_shop_app/features/profile/models/user_profile.dart';
import 'package:mini_shop_app/features/profile/services/user_service.dart';

final userProfileControllerProvider =
    AsyncNotifierProvider<UserProfileControllerNotifier, UserProfile?>(
      UserProfileControllerNotifier.new,
    );

class UserProfileControllerNotifier extends AsyncNotifier<UserProfile?> {
  @override
  FutureOr<UserProfile?> build() async {
    // return ref.watch(userProfileProvider)?
    // final currentUser = FirebaseAuth.instance.currentUser;
    // if(currentUser == null) return null;
    // final uid = currentUser.uid;
    // return await ref.read(userServiceProvider).fetchUserProfile(uid);
    return await ref.read(userProfileProvider.future);
  }

  Future<void> uploadAndSaveAvatar(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // 1. Upload to Storage
      final downloadUrl = await ref
          .read(userServiceProvider)
          .uploadAvatarToStorage(user.uid, imageFile);

      // 2. Save to Database
      await ref
          .read(userServiceProvider)
          .updateProfileAvatar(user.uid, downloadUrl);

      // 3. Force the Profile screen to refresh and show the new image!
      // (Assuming you named your FutureProvider 'userProfileProvider')
      ref.invalidate(userProfileProvider);
    } catch (error) {
      logger.e('Failed to upload avatar', error: error);
      rethrow;
    }
  }
}
