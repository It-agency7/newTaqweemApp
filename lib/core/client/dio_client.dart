import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'dio_exception.dart';
import 'endpoints.dart';
import 'interceptors/authorization_interceptor.dart';
import 'interceptors/logger_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
              baseUrl: Endpoints.baseUrl,
              connectTimeout: Endpoints.connectionTimeout,
              receiveTimeout: Endpoints.receiveTimeout,
              responseType: ResponseType.json,
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              }),
        )..interceptors.addAll(
            [
              AuthorizationInterceptor(),
              LoggerInterceptor(),
            ],
          );

  Future<Response<T>> get<T>({required String path}) async {
    try {
      final response = await _dio.get<T>(path);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioException.fromDioError(error);
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  Future<Response<T>> post<T>({required String path, dynamic data}) async {
    try {
      final response = await _dio.post<T>(path, data: data);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioException.fromDioError(error);
      log('$errorMessage');
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  Future<T> put<T>({required String path, dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data as T;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }

  Future<Response<T>> delete<T>({required String path}) async {
    try {
      final response = await _dio.delete<T>(path);
      return response;
    } on DioError catch (error) {
      final errorMessage = DioException.fromDioError(error);
      throw errorMessage;
    } catch (e) {
      if (kDebugMode) print(e);
      throw e.toString();
    }
  }
}
