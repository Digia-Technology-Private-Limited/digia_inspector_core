import '../utils/log_level.dart';
import '../utils/timestamp_helper.dart';
import 'log_event.dart';

/// Represents an HTTP request in the log system.
class RequestLog extends LogEvent {
  /// The HTTP method (GET, POST, PUT, DELETE, etc.).
  final String method;

  /// The request URL.
  final Uri url;

  /// Request headers.
  final Map<String, dynamic> headers;

  /// Request body (if any).
  final dynamic body;

  /// Size of the request body in bytes.
  final int? requestSize;

  /// Creates a new request log entry.
  RequestLog({
    super.id,
    DateTime? timestamp,
    required this.method,
    required this.url,
    Map<String, dynamic>? headers,
    this.body,
    this.requestSize,
    super.category = 'network',
    super.tags,
  }) : headers = headers ?? {},
       super(level: LogLevel.info, timestamp: timestamp);

  @override
  String get eventType => 'request';

  @override
  String get title => '$method ${url.path}';

  @override
  String get description => 'HTTP $method request to ${url.toString()}';

  @override
  Map<String, dynamic> get metadata => {
    'method': method,
    'url': url.toString(),
    'headers': headers,
    'body': body,
    'requestSize': requestSize,
  };

  /// Creates a copy of this request log with updated fields.
  RequestLog copyWith({
    String? id,
    DateTime? timestamp,
    String? method,
    Uri? url,
    Map<String, dynamic>? headers,
    dynamic body,
    int? requestSize,
    String? category,
    Set<String>? tags,
  }) {
    return RequestLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      requestSize: requestSize ?? this.requestSize,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  /// Creates a RequestLog from JSON.
  static RequestLog fromJson(Map<String, dynamic> json) {
    return RequestLog(
      id: json['id'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String) ??
          TimestampHelper.now(),
      method: json['method'] as String,
      url: Uri.parse(json['url'] as String),
      headers: (json['headers'] as Map<String, dynamic>?) ?? {},
      body: json['body'],
      requestSize: json['requestSize'] as int?,
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toSet() ??
          <String>{},
    );
  }
}

/// Represents an HTTP response in the log system.
class ResponseLog extends LogEvent {
  /// The associated request log ID.
  final String requestId;

  /// HTTP status code.
  final int statusCode;

  /// Response headers.
  final Map<String, dynamic> headers;

  /// Response body.
  final dynamic body;

  /// Size of the response body in bytes.
  final int? responseSize;

  /// Time taken for the request/response cycle.
  final Duration? duration;

  /// Creates a new response log entry.
  ResponseLog({
    super.id,
    DateTime? timestamp,
    required this.requestId,
    required this.statusCode,
    Map<String, dynamic>? headers,
    this.body,
    this.responseSize,
    this.duration,
    super.category = 'network',
    super.tags,
  }) : headers = headers ?? {},
       super(level: _getLevelFromStatusCode(statusCode), timestamp: timestamp);

  @override
  String get eventType => 'response';

  @override
  String get title => 'HTTP $statusCode';

  @override
  String get description =>
      'HTTP response with status code $statusCode'
      '${duration != null ? ' (${TimestampHelper.formatDuration(timestamp.subtract(duration!), timestamp)})' : ''}';

  @override
  Map<String, dynamic> get metadata => {
    'requestId': requestId,
    'statusCode': statusCode,
    'headers': headers,
    'body': body,
    'responseSize': responseSize,
    'duration': duration?.inMilliseconds,
  };

  /// Returns true if this response indicates success (2xx status code).
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Returns true if this response indicates a client error (4xx status code).
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Returns true if this response indicates a server error (5xx status code).
  bool get isServerError => statusCode >= 500;

  /// Creates a copy of this response log with updated fields.
  ResponseLog copyWith({
    String? id,
    DateTime? timestamp,
    String? requestId,
    int? statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    int? responseSize,
    Duration? duration,
    String? category,
    Set<String>? tags,
  }) {
    return ResponseLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      requestId: requestId ?? this.requestId,
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      responseSize: responseSize ?? this.responseSize,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  /// Creates a ResponseLog from JSON.
  static ResponseLog fromJson(Map<String, dynamic> json) {
    return ResponseLog(
      id: json['id'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String) ??
          TimestampHelper.now(),
      requestId: json['requestId'] as String,
      statusCode: json['statusCode'] as int,
      headers: (json['headers'] as Map<String, dynamic>?) ?? {},
      body: json['body'],
      responseSize: json['responseSize'] as int?,
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toSet() ??
          <String>{},
    );
  }

  /// Determines the appropriate log level based on HTTP status code.
  static LogLevel _getLevelFromStatusCode(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return LogLevel.info;
    } else if (statusCode >= 300 && statusCode < 400) {
      return LogLevel.warning;
    } else if (statusCode >= 400) {
      return LogLevel.error;
    } else {
      return LogLevel.debug;
    }
  }
}

/// Represents a network error in the log system.
class NetworkErrorLog extends LogEvent {
  /// The associated request log ID (if available).
  final String? requestId;

  /// The error that occurred.
  final Object error;

  /// Stack trace of the error.
  final StackTrace? stackTrace;

  /// Additional error context.
  final Map<String, dynamic> errorContext;

  /// Creates a new network error log entry.
  NetworkErrorLog({
    super.id,
    DateTime? timestamp,
    this.requestId,
    required this.error,
    this.stackTrace,
    Map<String, dynamic>? errorContext,
    super.category = 'network',
    super.tags,
  }) : errorContext = errorContext ?? {},
       super(level: LogLevel.error, timestamp: timestamp);

  @override
  String get eventType => 'network_error';

  @override
  String get title => 'Network Error: ${error.runtimeType}';

  @override
  String get description => error.toString();

  @override
  Map<String, dynamic> get metadata => {
    'requestId': requestId,
    'error': error.toString(),
    'errorType': error.runtimeType.toString(),
    'stackTrace': stackTrace?.toString(),
    'errorContext': errorContext,
  };

  /// Creates a copy of this network error log with updated fields.
  NetworkErrorLog copyWith({
    String? id,
    DateTime? timestamp,
    String? requestId,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? errorContext,
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
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  /// Creates a NetworkErrorLog from JSON.
  static NetworkErrorLog fromJson(Map<String, dynamic> json) {
    return NetworkErrorLog(
      id: json['id'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String) ??
          TimestampHelper.now(),
      requestId: json['requestId'] as String?,
      error: json['error'] as String? ?? 'Unknown error',
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      errorContext: (json['errorContext'] as Map<String, dynamic>?) ?? {},
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toSet() ??
          <String>{},
    );
  }
}
