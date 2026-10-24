import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/network/dio_provider.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/auth/models/user_profile.dart';
import 'package:mini_shop_app/features/auth/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(dio: ref.read(dioProvider)),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  // Watch the auth stream. If it changes (login/logout), this provider rebuilds!
  try {
    final authUser = await ref.watch(authStateProvider.future);

    if (authUser == null) return null;
    final token = await authUser.getIdToken();
    if (token == null) return null;
    return await ref
        .read(authServiceProvider)
        .fetchUserProfile(authUser.uid, token);
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
