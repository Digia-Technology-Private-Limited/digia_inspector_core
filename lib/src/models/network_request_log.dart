import 'package:digia_inspector_core/src/models/digia_log_event.dart';
import 'package:digia_inspector_core/src/utils/timestamp_helper.dart';

/// Represents an HTTP request in the logging system.
///
/// This class captures all the essential information about an outgoing
/// HTTP request including the URL, method, headers, body, and API metadata
/// for debugging purposes.
class NetworkRequestLog extends DigiaLogEvent {
  /// Constructor for NetworkRequestLog
  ///
  /// [method] - The HTTP method (GET, POST, PUT, DELETE, etc.).
  /// [url] - The request URL.
  /// [headers] - Request headers.
  /// [body] - Request body (if any).
  /// [queryParameters] - Query parameters included in the URL.
  /// [requestSize] - Size of the request body in bytes.
  /// [requestId] - Unique identifier for correlating with responses.
  /// [apiName] - Name of the API being called (from APIModel.name).
  /// [apiId] - API ID for correlation (from APIModel.id).
  NetworkRequestLog({
    required this.method,
    required this.url,
    required this.requestId,
    super.id,
    super.timestamp,
    Map<String, dynamic>? headers,
    this.body,
    Map<String, dynamic>? queryParameters,
    this.requestSize,
    this.apiName,
    this.apiId,
    super.category = 'network',
    super.tags,
  })  : headers = headers ?? {},
        queryParameters = queryParameters ?? {};

  /// Creates a NetworkRequestLog from JSON.
  NetworkRequestLog.fromJson(Map<String, dynamic> json)
      : method = json['method'] as String,
        url = Uri.parse(json['url'] as String),
        headers = (json['headers'] as Map<String, dynamic>?) ?? {},
        body = json['body'],
        queryParameters =
            (json['queryParameters'] as Map<String, dynamic>?) ?? {},
        requestSize = json['requestSize'] as int?,
        requestId = json['requestId'] as String,
        apiName = json['apiName'] as String?,
        apiId = json['apiId'] as String?,
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

  /// The HTTP method (GET, POST, PUT, DELETE, etc.).
  final String method;

  /// The request URL.
  final Uri url;

  /// Request headers.
  final Map<String, dynamic> headers;

  /// Request body (if any).
  final dynamic body;

  /// Query parameters included in the URL.
  final Map<String, dynamic> queryParameters;

  /// Size of the request body in bytes.
  final int? requestSize;

  /// Unique identifier for correlating with responses.
  final String requestId;

  /// Name of the API being called (from APIModel.name).
  final String? apiName;

  /// API ID for correlation (from APIModel.id).
  final String? apiId;

  @override
  String get eventType => 'network_request';

  @override
  String get title =>
      apiName != null ? '$method $apiName' : '$method ${url.path}';

  @override
  String get description => apiName != null
      ? 'HTTP $method request to $apiName ($url)'
      : 'HTTP $method request to $url';

  @override
  Map<String, dynamic> get metadata => {
        'method': method,
        'url': url.toString(),
        'headers': headers,
        'body': body,
        'queryParameters': queryParameters,
        'requestSize': requestSize,
        'requestId': requestId,
        if (apiName != null) 'apiName': apiName,
        if (apiId != null) 'apiId': apiId,
      };

  /// Returns the display name for this request (API name or URL path).
  String get displayName => apiName ?? url.path;

  /// Creates a copy of this request log with updated fields.
  NetworkRequestLog copyWith({
    String? id,
    DateTime? timestamp,
    String? method,
    Uri? url,
    Map<String, dynamic>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    int? requestSize,
    String? requestId,
    String? apiName,
    String? apiId,
    String? category,
    Set<String>? tags,
  }) {
    return NetworkRequestLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      queryParameters: queryParameters ?? this.queryParameters,
      requestSize: requestSize ?? this.requestSize,
      requestId: requestId ?? this.requestId,
      apiName: apiName ?? this.apiName,
      apiId: apiId ?? this.apiId,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool matches(String query) {
    final lowercaseQuery = query.toLowerCase();

    // Enhanced search that includes API name
    return super.matches(query) ||
        (apiName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (apiId?.toLowerCase().contains(lowercaseQuery) ?? false);
  }

  @override
  String toString() => 'NetworkRequestLog($method $displayName)';
}
