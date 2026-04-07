import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class CustomInterceptor extends Interceptor {
  final String baseUrl;
  bool _isRefreshing = false;
  int retryCount = 0; // 👈 retry counter
  final int maxRetry = 5; // 👈 max retry limit
  Completer<String?>? _refreshCompleter;

  CustomInterceptor(this.baseUrl);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // log("➡️ API Request: ${options.path}");

    final token = LocalStorageService.getToken();
    // log("🔑 Access Token: ${token ?? 'NO TOKEN'}");

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    options.baseUrl = baseUrl;
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      log("🚨 401 → Unauthorized");

      // STOP RETRY AFTER 5 ATTEMPTS
      if (retryCount >= maxRetry) {
        log(
          "⛔ Max retry limit reached ($maxRetry). Stopping further attempts.",
        );
        retryCount = 0; // reset counter
        return handler.next(err); // forward error
      }

      retryCount++;
      log("🔁 Retry Attempt: $retryCount");

      try {
        if (_isRefreshing) {
          log("⏳ Waiting for refresh...");
          await _refreshCompleter?.future;
        } else {
          _isRefreshing = true;
          _refreshCompleter = Completer();

          final newToken = await _refreshToken();

          if (newToken != null) {
            LocalStorageService.setToken(newToken);
            _refreshCompleter?.complete(newToken);
          } else {
            _refreshCompleter?.complete(null);
          }

          _isRefreshing = false;
        }

        // Retry only if token exists
        final retryToken = LocalStorageService.getToken();
        if (retryToken == null) {
          log("🚫 No Token after refresh → no retry");
          retryCount = 0;
          return handler.next(err);
        }

        err.requestOptions.headers["Authorization"] = "Bearer $retryToken";
        final retryResponse = await BaseClient.dio.fetch(err.requestOptions);

        return handler.resolve(retryResponse);
      } catch (e) {
        log("❌ Refresh or retry error: $e");
      }
    }

    handler.next(err);
  }

  /// Refresh Token
  Future<String?> _refreshToken() async {
    final refreshToken = LocalStorageService.getRefreshToken();

    if (refreshToken == null) {
      log("⚠️ No Refresh Token Found");
      return null;
    }

    try {
      log("🔁 Refresh Attempt...");
      final response = await BaseClient.post(
        api: EndPoint.refresh,
        data: {"RefreshToken": refreshToken},
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        final newToken = response.data["AccessToken"];
        log("🔄 Token Refreshed: $newToken");
        return newToken;
      }
    } catch (e) {
      log("⚡ Refresh Exception: $e");
    }

    return null;
  }
}
