import 'package:digia_inspector_core/src/models/digia_log_event.dart';
import 'package:digia_inspector_core/src/utils/timestamp_helper.dart';

/// Represents a network error in the logging system.
///
/// This class captures network-related errors including connection timeouts,
/// DNS failures, and other network-level issues that prevent successful
/// HTTP request completion.
class NetworkErrorLog extends DigiaLogEvent {
  /// Constructor for NetworkErrorLog
  ///
  /// [error] - The error that occurred.
  /// [requestId] - The associated request log ID (if available).
  /// [stackTrace] - Stack trace of the error.
  /// [errorContext] - Additional error context.
  /// [apiName] - Name of the API that failed (from associated request).
  /// [apiId] - API ID for correlation (from associated request).
  /// [failedUrl] - URL that failed (if available).
  /// [failedMethod] - HTTP method that failed (if available).
  /// [category] - Category of the log event.
  /// [tags] - Tags for the log event.
  NetworkErrorLog({
    required this.error,
    super.id,
    super.timestamp,
    this.requestId,
    this.stackTrace,
    Map<String, dynamic>? errorContext,
    this.apiName,
    this.apiId,
    this.failedUrl,
    this.failedMethod,
    super.category = 'network',
    super.tags,
  }) : errorContext = errorContext ?? {};

  /// Creates a NetworkErrorLog from JSON.
  NetworkErrorLog.fromJson(Map<String, dynamic> json)
      : requestId = json['requestId'] as String?,
        error = json['error'] as String? ?? 'Unknown error',
        stackTrace = json['stackTrace'] != null
            ? StackTrace.fromString(json['stackTrace'] as String)
            : null,
        errorContext = (json['errorContext'] as Map<String, dynamic>?) ?? {},
        apiName = json['apiName'] as String?,
        apiId = json['apiId'] as String?,
        failedUrl = json['failedUrl'] as String?,
        failedMethod = json['failedMethod'] as String?,
        super(
          id: json['id'] as String,
          timestamp: DateTime.tryParse(json['timestamp'] as String) ??
              TimestampHelper.now(),
          category: json['category'] as String?,
          tags: (json['tags'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toSet() ??
              <String>{},
        );

  /// The associated request log ID (if available).
  final String? requestId;

  /// The error that occurred.
  final Object error;

  /// Stack trace of the error.
  final StackTrace? stackTrace;

  /// Additional error context.
  final Map<String, dynamic> errorContext;

  /// Name of the API that failed (from associated request).
  final String? apiName;

  /// API ID for correlation (from associated request).
  final String? apiId;

  /// URL that failed (if available).
  final String? failedUrl;

  /// HTTP method that failed (if available).
  final String? failedMethod;

  @override
  String get eventType => 'network_error';

  @override
  String get title => apiName != null
      ? 'Network Error: $apiName'
      : 'Network Error: ${error.runtimeType}';

  @override
  String get description => apiName != null
      ? 'Network error occurred while calling $apiName: $error'
      : 'Network error: $error';

  @override
  Map<String, dynamic> get metadata => {
        'requestId': requestId,
        'error': error.toString(),
        'errorType': error.runtimeType.toString(),
        'stackTrace': stackTrace?.toString(),
        'errorContext': errorContext,
        if (apiName != null) 'apiName': apiName,
        if (apiId != null) 'apiId': apiId,
        if (failedUrl != null) 'failedUrl': failedUrl,
        if (failedMethod != null) 'failedMethod': failedMethod,
      };

  /// Returns the display name for this error (API name or generic).
  String get displayName => apiName ?? 'Network Error';

  /// Creates a copy of this network error log with updated fields.
  NetworkErrorLog copyWith({
    String? id,
    DateTime? timestamp,
    String? requestId,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? errorContext,
    String? apiName,
    String? apiId,
    String? failedUrl,
    String? failedMethod,
    String? category,
    Set<String>? tags,
  }) {
    return NetworkErrorLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      requestId: requestId ?? this.requestId,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      errorContext: errorContext ?? this.errorContext,
      apiName: apiName ?? this.apiName,
      apiId: apiId ?? this.apiId,
      failedUrl: failedUrl ?? this.failedUrl,
      failedMethod: failedMethod ?? this.failedMethod,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool matches(String query) {
    final lowercaseQuery = query.toLowerCase();

    // Enhanced search that includes API name and failed URL/method
    return super.matches(query) ||
        (apiName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (apiId?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (failedUrl?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (failedMethod?.toLowerCase().contains(lowercaseQuery) ?? false);
  }

  @override
  String toString() => 'NetworkErrorLog($displayName: ${error.runtimeType})';
}
