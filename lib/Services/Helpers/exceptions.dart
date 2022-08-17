import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout with API server";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message = _handleError(
            dioError.response!.statusCode, dioError.response!.data);
        break;
      case DioErrorType.cancel:
        message = "Request to API server was canelled";
        break;
      case DioErrorType.other:
        message = "Something went wrong";
        break;
    }
  }

  late String message;

  String _handleError(int? statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return "حدث خطا من السرفر";
      case 500:
        return 'Internal server error';
      case 100:
        return "Couldn't find the product";
      case 401:
        return "خطا في العملية";
      default:
        return 'Oops, something went wrong';
    }
  }

  @override
  String toString() => message;
}
