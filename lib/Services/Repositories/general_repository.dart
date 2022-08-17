import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GeneralRepository {
  final Dio _dio = Dio();

  init({
    required BuildContext context,
    required String ipPassword,
    required String ipAddress,
  }) {
    String encoded = base64.encode(
      utf8.encode(
        ipPassword,
      ),
    );
    if (!kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(responseBody: true));
    }
    _dio.options.baseUrl = "http://" + ipAddress;
    _dio.options.connectTimeout = 20000;
    _dio.options.sendTimeout = 20000;
    _dio.options.headers.addAll(
      {"Authorization": 'Basic ' + encoded},
    );
  }

  post({
    required Object data,
    required String path,
  }) async {
    final response = await _dio.post(path, data: data);
    if (response.data == "[]" || response.data == -1 || response.data == -30) {
      throw "خطا في العملية";
    }
  }

  Future get({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    final Response response = await _dio.get(path, queryParameters: data);
    if (response.data == -1 || response.data == -30) {
      throw "خطا في العملية";
    }
    return response.data;
  }
}
