import 'package:dio/dio.dart';

/// Abstract interface for network interceptors in the Digia ecosystem.
///
/// This contract defines the interface for network interceptors without
/// depending on the full Digia Inspector package, allowing for cleaner
/// separation of concerns.
abstract class NetworkObserver {
  /// Called when a network request is about to be sent.
  void onRequest(RequestOptions options, RequestInterceptorHandler handler);

  /// Called when a network response is received successfully.
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  );

  /// Called when a network request fails with an error.
  void onError(DioException error, ErrorInterceptorHandler handler);

  /// Returns the underlying interceptor instance.
  ///
  /// This allows the interceptor to be added to Dio instances
  /// while maintaining the contract abstraction.
  Interceptor get interceptor;
}
