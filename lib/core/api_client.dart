import 'dart:io';

// core/api/api_client.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'errors.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required String baseUrl, required String apiKey})
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          queryParameters: {'api_key': apiKey},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120,
        enabled: kDebugMode,
        logPrint: (obj) {
          var log = obj.toString();

          // Mask inline api_key (URLs, JSON, query, headers)
          log = log.replaceAll(
            RegExp(r'api_key=[^&,\s]+'),
            'api_key=***REDACTED***',
          );
          log = log.replaceAll(
            RegExp(r'"api_key":\s*"[^"]+"'),
            '"api_key": "***REDACTED***"',
          );
          log = log.replaceAll(
            RegExp(r'api_key:\s*[A-Za-z0-9]+'),
            'api_key: ***REDACTED***',
          );

          debugPrint(log);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity.contains(ConnectivityResult.none)) {
      throw NetworkException("No Internet connection");
    }

    try {
      final response = await dio.get(endpoint, queryParameters: params);
      return _processResponse(response);
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on SocketException {
      throw NetworkException("No Internet connection");
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Map<String, dynamic> _processResponse(Response response) {
    final code = response.statusCode ?? 0;

    if (code >= 200 && code < 300) {
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException("Unexpected response format");
      }
    }

    if (code == 401) throw UnauthorizedException("Unauthorized request");
    if (code == 404) throw NotFoundException("Resource not found");
    if (code >= 500) throw ServerException("Server error");

    throw ApiException("Unexpected status code: $code");
  }

  ApiException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException("Connection timed out");
    }
    if (e.type == DioExceptionType.connectionError) {
      return NetworkException("Failed to connect to server");
    }
    if (e.type == DioExceptionType.badResponse) {
      final code = e.response?.statusCode ?? 0;
      if (code == 401) return UnauthorizedException("Unauthorized");
      if (code == 404) return NotFoundException("Not found");
      if (code >= 500) return ServerException("Server error");
      return ApiException("Bad response: $code");
    }
    return ApiException("Unexpected Dio error: ${e.message}");
  }
}

/*class ApiClient {
  final Dio dio;

  ApiClient({required String baseUrl, required String apiKey})
    : dio = Dio(
        BaseOptions(baseUrl: baseUrl, queryParameters: {'api_key': apiKey}),
      ) {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    final response = await dio.get(endpoint, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }
}*/

/*
class ApiClient {
  final http.Client httpClient;
  ApiClient({http.Client? client}) : httpClient = client ?? http.Client();

  Uri _buildUri(String path, [Map<String, String>? params]) {
    final queryParameters = {'api_key': ApiConfig.apiKey, ...?params};
    return Uri.parse(
      '${ApiConfig.baseUrl}$path',
    ).replace(queryParameters: queryParameters);
  }

  Future<dynamic> get(String path, {Map<String, String>? params}) async {
    final uri = _buildUri(path, params);
    try {
      final res = await httpClient.get(uri);
      return _processResponse(res);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  dynamic _processResponse(http.Response res) {
    final code = res.statusCode;
    if (code >= 200 && code < 300) {
      if (res.body.isEmpty) return null;
      return json.decode(res.body);
    }
    if (code == 401) throw UnauthorizedException();
    if (code == 404) throw NotFoundException();
    if (code >= 500) throw ServerException();
    throw ApiException('Unexpected status code: $code');
  }
}*/
