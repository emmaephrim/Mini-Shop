import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_shop_app/core/errors/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  // final Dio _dio;
  // ErrorInterceptor({required this._dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // if (err.response?.statusCode == 401) {
    //   final user = FirebaseAuth.instance.currentUser;

    //   if (user != null) {
    //     try {
    //       // Passing 'true' force firebase to ignore the localcache and fetch a
    //       // brand new token directly from Google's servers
    //       final newToken = await user.getIdToken(true);
    //       if (newToken != null) {
    //         final options = err.requestOptions;
    //         options.queryParameters['auth'] = newToken;

    //         // Retry the exact same request using our Dio instance
    //         final retryResponse = await _dio.fetch(options);
    //         return handler.resolve(retryResponse);
    //       }
    //     } catch (refreshError) {
    //       //
    //     }
    //   }
    // }

    String friendlyMessage = 'An unexpected error occurred';
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        friendlyMessage = 'Connection timed out. Please check your internet';
        break;
      case DioExceptionType.connectionError:
        friendlyMessage = 'No internet connection. Are you offline';
        break;
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            friendlyMessage = 'Bad request. Please check your internet';
            break;
          case 401:
            friendlyMessage = 'Session expired. Please log in again';
            break;
          case 403:
            friendlyMessage =
                'Permission denied. You cannot perform this operation';
            break;
          case 404:
            friendlyMessage = 'Data not found. It may have been deleted';
            break;
          case 500:
            friendlyMessage = 'Server error. Our Engineers are on it!';
            break;
          default:
            friendlyMessage =
                'Oops! Something went wrong. (${err.response?.statusCode}) ';
        }
        break;
      default:
        friendlyMessage = 'A network error occurred. Please try again';
    }

    final customError = DioException(
      requestOptions: err.requestOptions,
      error: AppException(friendlyMessage),
      type: err.type,
      response: err.response,
    );

    return handler.next(customError);
  }
}
