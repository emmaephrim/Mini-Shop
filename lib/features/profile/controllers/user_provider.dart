import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/profile/models/user_profile.dart';
import 'package:mini_shop_app/features/profile/services/user_service.dart';

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  // Watch the auth stream. If it changes (login/logout), this provider rebuilds!
  try {
    final authUser = await ref.watch(authStateProvider.future);

    if (authUser == null) return null;
    final token = await authUser.getIdToken();
    if (token == null) return null;
    return await ref.read(userServiceProvider).fetchUserProfile(authUser.uid);
  } catch (error, stackTrace) {
    logger.e(
      'Getting user Profile error',
      error: error,
      stackTrace: stackTrace,
    );
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    rethrow;
  }
});
