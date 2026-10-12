import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/auth_provider.dart';

final authControllerProvider =
    AsyncNotifierProvider.autoDispose<AuthController, void>(AuthController.new);

// class AuthController extends AutoDisposeAsyncNotifier<void> {
class AuthController extends AsyncNotifier<void> {
  @override
  //   FutureOr<void> build() {}
  build() {}

  Future<bool> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signInWithEmail(email, password),
    );
    return !state.hasError;
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signUpWithEmail(email, password),
    );
    return !state.hasError;
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signInWithGoogle(),
    );
    return !state.hasError;
  }

  Future<bool> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authServiceProvider).signOut(),
    );
    return !state.hasError;
  }
}
