// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unnecessary_new, unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';
import 'CustomInterceptor.dart';
import 'app_exceptions.dart';

class BaseClient {
  static late String baseUrl;
  static Dio dio = Dio();

  // Initialize with base URL and load the auth token from storage
  static Future<void> initialize(String url) async {
    baseUrl = url;
    dio = Dio();
    dio.interceptors.add(CustomInterceptor(url));
  }

  // GET request
  static Future<Response<dynamic>?> get({
    String? api,
    Map<String, dynamic>? queryParams,
    FormData? formData,
    Map<String, dynamic>? payloadObj,
    Options? options,
  }) async {
    try {
      var response = await dio.get(
        api ?? "",
        data: payloadObj ?? formData ?? {}, // Use either payloadObj or formData
        queryParameters: queryParams ?? {},
        options: options,
      );
      final requestLog = {
        "method": "GET",
        "url": "${dio.options.baseUrl}${api ?? ""}",
        "headers": dio.options.headers,
        "queryParams": queryParams ?? {},
        "data": payloadObj ?? formData ?? {},
      };
      logApiRequestResponse(
        method: "GET",
        url: api ?? '',
        query: queryParams,
        body: payloadObj ?? formData ?? {},
        statusCode: response.statusCode,
        response: response.data,
      );
      debugPrint("📦 Dio Request Log: ${json.encode(requestLog)}");
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        throw ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.headers.toString());
        debugPrint(e.toString());
      }
    } catch (e) {
      throw ApiNotRespondingException(e.toString());
    }
    return null;
  }

  static Future<Response<dynamic>?> getById({String? api, String? id}) async {
    try {
      var response = await dio.get(
        api ?? "",
        options: Options(headers: {"x-business-id": id ?? ""}),
      );
      logApiRequestResponse(
        method: "GET",
        url: baseUrl + (api ?? ""),
        statusCode: response.statusCode,
        response: response.data,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        throw ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        throw ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.headers.toString());
        debugPrint(e.toString());
      }
    } catch (e) {
      throw ApiNotRespondingException(e.toString());
    }
    return null;
  }

  // POST request
  static Future<dynamic> post({
    String? api,
    Object? data,
    Map<String, dynamic>? payloadObj,
    FormData? formData,
    Map<String, dynamic>? queryParams,
  }) async {
    // Make the request
    try {
      var response = await dio.post(
        api ?? "",
        data: payloadObj ?? formData ?? data ?? {},
        // Use either payloadObj or formData
        queryParameters: queryParams ?? {}, // Add query parameters if provided
      );
      logApiRequestResponse(
        method: "POST",
        url: baseUrl + (api ?? ""),
        query: queryParams,
        body: payloadObj ?? formData ?? data ?? {},
        statusCode: response.statusCode,
        response: response.data,
      );

      return response;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  static Future<dynamic> postMultipart({
    required String api,
    required FormData formData,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.post(
        api,
        data: formData,
        queryParameters: queryParams,
        // options: Options(contentType: 'multipart/form-data'),
      );

      // 🔴 DO NOT log body
      logApiRequestResponse(
        method: "POST",
        url: baseUrl + api,
        query: queryParams,
        body: "Multipart/FormData",
        statusCode: response.statusCode,
        response: response.data,
      );

      return response;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  // PUT request
  static Future<dynamic> put({
    String? api,
    dynamic payloadObj,
    FormData? formData,
    Map<String, dynamic>? queryParams,
  }) async {
    // var uri = baseUrl + (api ?? "");

    try {
      var response = await dio.put(
        api ?? "",
        data: payloadObj ?? formData ?? {}, // Use either payloadObj or formData
        queryParameters: queryParams ?? {}, // Add query parameters if provided
      );
      logApiRequestResponse(
        method: "PUT",
        url: baseUrl + (api ?? ""),
        query: queryParams,
        body: payloadObj ?? formData ?? {},
        statusCode: response.statusCode,
        response: response.data,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }
    return null;
  }

  // DELETE request
  static Future<dynamic> delete({
    String? api,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      var response = await dio.delete(api ?? "", queryParameters: queryParams);

      logApiRequestResponse(
        method: "DELETE",
        url: baseUrl + (api ?? ""),
        query: queryParams,
        statusCode: response.statusCode,
        response: response.data,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioException.connectionTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.receiveTimeout) {
        ApiNotRespondingException("Connection Timeout");
      } else if (e.type == DioException.connectionError) {
        ApiNotRespondingException("No Internet Connection");
      } else if (e.response != null) {
        debugPrint(e.response!.data);
        debugPrint(e.response!.headers.toString());
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }
    return null;
  }

  static Future<bool> isAuthenticated() async {
    final isLongin = LocalStorageService.isLoggedIn();
    final userId = LocalStorageService.getUserId();
    debugPrint("Login User $userId====>$isLongin");
    if (isLongin) {
      return true;
    }
    return false;
  }

  /// 🔍 API Request/Response Logger
  static void logApiRequestResponse({
    required String method,
    required String url,
    Map<String, dynamic>? query,
    dynamic body,
    int? statusCode,
    dynamic response,
    bool isError = false,
  }) {
    final token = LocalStorageService.getToken();

    // 1. Determine Content-Type and Body representation
    String contentType = "application/json";
    String printableBody;

    if (body is FormData) {
      contentType = "multipart/form-data";
      // FormData ko encode nahi kar sakte, isliye fields ka map dikhayenge
      printableBody =
          "FormData contains ${body.fields.length} fields and ${body.files.length} files";
    } else {
      try {
        printableBody = jsonEncode(body ?? {});
      } catch (e) {
        printableBody = "Error encoding body: $e";
      }
    }

    // 2. Format as a proper cURL command for debugging
    final String log = '''
----------------------- API LOG -----------------------
curl -X $method "$url" \\
  -H "Content-Type: $contentType" \\
  -H "Authorization: Bearer $token" \\
  -d '$printableBody'

Status Code: $statusCode
Response: ${jsonEncode(response ?? {})}
-------------------------------------------------------
''';

    if (isError) {
      LoggerUtils.error(log, tag: "BaseClient");
    } else {
      LoggerUtils.debug(log, tag: "BaseClient");
    }
  }

  static handleDioException(DioException e) {
    debugPrint("🔻 DIO EXCEPTION OCCURRED");
    debugPrint("Type     : ${e.type}");
    debugPrint("Message  : ${e.message}");
    debugPrint("Data     : ${e.response?.data}");
    debugPrint("Status   : ${e.response?.statusCode}");

    // Extract safe API message
    String extractMessage(dynamic data) {
      if (data is Map && data.containsKey("message")) return data["message"];
      if (data is String && data.isNotEmpty) return data;
      return "Something went wrong!";
    }

    String finalMessage = "Unexpected Error! Please try again.";

    // ---------- CONNECTION & NETWORK ERRORS ----------
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      finalMessage = "Connection Timeout! Please try again.";
    } else if (e.type == DioExceptionType.connectionError ||
        (e.message?.contains("SocketException") ?? false)) {
      finalMessage = "No Internet Connection";
    } else if (e.type == DioExceptionType.badCertificate) {
      finalMessage = "Invalid SSL Certificate!";
    } else if (e.type == DioExceptionType.cancel) {
      finalMessage = "Request Cancelled!";
    }
    // ---------- SERVER RESPONSE ERRORS ----------
    else if (e.type == DioExceptionType.badResponse && e.response != null) {
      final int code = e.response?.statusCode ?? 0;
      final msg = extractMessage(e.response?.data);

      if (code == 400) {
        finalMessage = msg;
      } else if (code == 401) {
        finalMessage =
            msg.isNotEmpty ? msg : "Unauthorized! Please login again.";
      } else if (code == 403) {
        finalMessage = msg.isNotEmpty ? msg : "Access Denied!";
      } else if (code == 404) {
        finalMessage = msg.isNotEmpty ? msg : "Resource Not Found!";
      } else if (code == 409) {
        finalMessage = msg.isNotEmpty ? msg : "Conflict! Please try again.";
      } else if (code == 422) {
        finalMessage = msg;
      } else if (code == 429) {
        finalMessage = msg.isNotEmpty ? msg : "Too Many Requests! Please wait.";
      } else if (code >= 500) {
        finalMessage =
            msg.isNotEmpty ? msg : "Server Error! Please try again later.";
      } else {
        finalMessage =
            msg.isNotEmpty ? msg : "Unexpected Server Response ($code)";
      }
    }

    // ---------- PRINT FINAL MESSAGE BEFORE RETURN ----------
    debugPrint("🔸 Final Error Message => $finalMessage\n");

    SnackBarUiView.showError(message: finalMessage);
  }
}
