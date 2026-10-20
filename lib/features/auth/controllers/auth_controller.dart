import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
  isAutoDispose: true,
);

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {}

  Future<bool> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signInWithEmail(email, password),
    );
    return !state.hasError;
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String role,
  }) async {
    state = const AsyncValue.loading();
    try {
      await AsyncValue.guard(
        () => ref
            .read(authServiceProvider)
            .signUpWithEmail(email: email, password: password, role: role),
      );
      state = AsyncValue.data(null);
      return !state.hasError;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      logger.e('Sign up failed', error: error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  Future<bool> signInWithGoogle({required String role}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signInWithGoogle(role: role),
    );
    return !state.hasError;
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      logger.e('Sign out failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
