import 'package:dio/dio.dart';
import 'package:mini_shop_app/core/errors/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
