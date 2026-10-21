import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/auth/models/user_profile.dart';
import 'package:mini_shop_app/features/auth/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  // Watch the auth stream. If it changes (login/logout), this provider rebuilds!
  final authUser = await ref.watch(authStateProvider.future);

  if (authUser == null) return null;
  final token = await authUser.getIdToken();
  if (token == null) return null;
  return await ref
      .read(authServiceProvider)
      .fetchUserProfile(authUser.uid, token);
});
