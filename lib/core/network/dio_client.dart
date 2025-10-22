import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class ApiService {
  ApiService() {
    _dio.options.connectTimeout = const Duration(milliseconds: 60000);
    _dio.options.sendTimeout = const Duration(milliseconds: 60000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 60000);

    if (!kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(responseBody: true));
    }

    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.headers.addAll({
      'Accept': 'application/json',
      'App-Version': AppConstants.appVersion,
    });
    _dio.options.receiveDataWhenStatusError = true;
  }

  final Dio _dio = Dio();

  Future<T?> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    headers = await addToken(headers);
    try {
      final res = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers, extra: extra),
      );
      return res.data;
    } catch (e) {
      errorInterceptor(e);
    }
    return null;
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onReceiveProgress,
    bool isRetry = false,
    int retryCount = 0,
  }) async {
    headers = await addToken(headers);

    try {
      final response = await _dio.get<T>(
        path,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: Options(headers: headers, extra: extra),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 408 && !isRetry) {
        return await get<T>(
          path,
          queryParameters: queryParameters,
          extra: extra,
          headers: headers,
          onReceiveProgress: onReceiveProgress,
          isRetry: true,
          retryCount: retryCount + 1,
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      if (e is DioException &&
          e.response?.statusCode == 408 &&
          !isRetry &&
          retryCount < 3) {
        return await get<T>(
          path,
          queryParameters: queryParameters,
          extra: extra,
          headers: headers,
          onReceiveProgress: onReceiveProgress,
          isRetry: true,
          retryCount: retryCount + 1,
        );
      } else {
        errorInterceptor(e);
      }
    }

    return null;
  }

  Future<T?> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    headers = await addToken(headers);

    late Response<T> res;
    try {
      await _dio
          .post<T>(
            path,
            data: data,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryParameters,
            options: Options(headers: headers, extra: extra),
          )
          .then((value) {
            if (value.statusCode! >= 200 && value.statusCode! < 300) {
              res = value;
            }
            if (value.statusCode! >= 400 && value.statusCode! <= 500) {
              post(
                path,
                data: data,
                onReceiveProgress: onReceiveProgress,
                headers: headers,
                extra: extra,
                queryParameters: queryParameters,
              );
            }
          });
    } catch (e) {
      errorInterceptor(e);
    }
    return res.data;
  }

  Future<T?> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    headers = await addToken(headers);

    late Response<T> res;
    try {
      await _dio
          .put<T>(
            path,
            data: data,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryParameters,
            options: Options(headers: headers, extra: extra),
          )
          .then((value) {
            if (value.statusCode! >= 200 && value.statusCode! < 300) {
              res = value;
            }
            if (value.statusCode! >= 400 && value.statusCode! <= 500) {
              post(
                path,
                data: data,
                onReceiveProgress: onReceiveProgress,
                headers: headers,
                extra: extra,
                queryParameters: queryParameters,
              );
            }
          });
    } catch (e) {
      errorInterceptor(e);
    }

    return res.data;
  }

  // patch
  Future<T?> patch<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    headers = await addToken(headers);

    late Response<T> res;
    try {
      await _dio
          .patch<T>(
            path,
            data: data,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryParameters,
            options: Options(headers: headers, extra: extra),
          )
          .then((value) {
            if (value.statusCode! >= 200 && value.statusCode! < 300) {
              res = value;
            }
            if (value.statusCode! >= 400 && value.statusCode! <= 500) {
              post(
                path,
                data: data,
                onReceiveProgress: onReceiveProgress,
                headers: headers,
                extra: extra,
                queryParameters: queryParameters,
              );
            }
          })
          .onError((error, stackTrace) {
            errorInterceptor(error);
          });
    } on Exception catch (e) {
      errorInterceptor(e);
    }
    return res.data;
  }

  Future<Map<String, dynamic>> addToken(Map<String, dynamic>? headers) async {
    headers ??= {};
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session?.accessToken != null) {
        headers['Authorization'] = 'Bearer ${session!.accessToken}';
      }
    } catch (e) {
      // Handle auth error silently, continue without token
      if (kDebugMode) {
        print('Auth token error: $e');
      }
    }
    return headers;
  }

  void errorInterceptor(Object? dioError) {
    if (dioError is DioException) {
      print('DioException: ${dioError.type}');
      print('DioException message: ${dioError.message}');
      print('DioException response: ${dioError.response?.statusCode}');
      print('DioException data: ${dioError.response?.data}');
      
      if (dioError.response != null) {
        final data = dioError.response!.data as Map<String, dynamic>?;
        throw Exception(data?['message'] ?? 'Server error: ${dioError.response?.statusCode}');
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } else {
      print('Non-DioException error: $dioError');
      throw Exception('Unexpected error: $dioError');
    }
  }
}
