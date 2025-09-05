import '../utils/log_level.dart';
import '../utils/timestamp_helper.dart';
import 'log_event.dart';

/// Represents an HTTP response in the logging system.
///
/// This class captures response information including status codes, headers,
/// response body, and timing data for debugging network interactions.
class NetworkResponseLog extends DigiaLogEvent {
  /// The associated request log ID for correlation.
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

  /// Name of the API that was called (from associated request).
  final String? apiName;

  /// API ID for correlation (from associated request).
  final String? apiId;

  /// Creates a new network response log entry.
  NetworkResponseLog({
    super.id,
    DateTime? timestamp,
    required this.requestId,
    required this.statusCode,
    Map<String, dynamic>? headers,
    this.body,
    this.responseSize,
    this.duration,
    this.apiName,
    this.apiId,
    super.category = 'network',
    super.tags,
  }) : headers = headers ?? {},
       super(level: _getLevelFromStatusCode(statusCode), timestamp: timestamp);

  @override
  String get eventType => 'network_response';

  @override
  String get title =>
      apiName != null ? 'HTTP $statusCode ($apiName)' : 'HTTP $statusCode';

  @override
  String get description => apiName != null
      ? 'HTTP response $statusCode for $apiName'
            '${duration != null ? ' (${duration!.inMilliseconds}ms)' : ''}'
      : 'HTTP response with status code $statusCode'
            '${duration != null ? ' (${duration!.inMilliseconds}ms)' : ''}';

  @override
  Map<String, dynamic> get metadata => {
    'requestId': requestId,
    'statusCode': statusCode,
    'headers': headers,
    'body': body,
    'responseSize': responseSize,
    'duration': duration?.inMilliseconds,
    if (apiName != null) 'apiName': apiName!,
    if (apiId != null) 'apiId': apiId!,
  };

  /// Returns true if this response indicates success (2xx status code).
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Returns true if this response indicates a client error (4xx status code).
  bool get isClientError => statusCode >= 400 && statusCode < 500;

  /// Returns true if this response indicates a server error (5xx status code).
  bool get isServerError => statusCode >= 500;

  /// Returns the display name for this response (API name or generic).
  String get displayName => apiName ?? 'Response';

  /// Creates a copy of this response log with updated fields.
  NetworkResponseLog copyWith({
    String? id,
    DateTime? timestamp,
    String? requestId,
    int? statusCode,
    Map<String, dynamic>? headers,
    dynamic body,
    int? responseSize,
    Duration? duration,
    String? apiName,
    String? apiId,
    String? category,
    Set<String>? tags,
  }) {
    return NetworkResponseLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      requestId: requestId ?? this.requestId,
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      responseSize: responseSize ?? this.responseSize,
      duration: duration ?? this.duration,
      apiName: apiName ?? this.apiName,
      apiId: apiId ?? this.apiId,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  /// Creates a NetworkResponseLog from JSON.
  static NetworkResponseLog fromJson(Map<String, dynamic> json) {
    return NetworkResponseLog(
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
      apiName: json['apiName'] as String?,
      apiId: json['apiId'] as String?,
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toSet() ??
          <String>{},
    );
  }

  @override
  bool matches(String query) {
    final lowercaseQuery = query.toLowerCase();

    // Enhanced search that includes API name and status code
    return super.matches(query) ||
        (apiName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (apiId?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        statusCode.toString().contains(lowercaseQuery);
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

  @override
  String toString() => 'NetworkResponseLog($statusCode ${displayName})';
}
