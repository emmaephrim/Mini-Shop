import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/errors/error_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = 'https://${dotenv.env['FIREBASE_DB_URL']!}';
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      // If a request takes more than 10 seconds, throw a timeout error
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Add auth interceptors
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken();
          // CRITICAL: Firebase Realtime Database expects the token in the URL
          // query parameters, not in the Headers!
          options.queryParameters['auth'] = token;
        }
        // let request continues
        return handler.next(options);
      },
    ),
  );

  final retryDio = Dio(BaseOptions(baseUrl: baseUrl));
  dio.interceptors.add(ErrorInterceptor(dio: retryDio));

  return dio;
});
