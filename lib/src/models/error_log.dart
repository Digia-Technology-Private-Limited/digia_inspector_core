import '../utils/log_level.dart';
import '../utils/timestamp_helper.dart';
import 'log_event.dart';

/// Represents a general application error in the log system.
class ErrorLog extends LogEvent {
  /// The error that occurred.
  final Object error;

  /// Stack trace of the error.
  final StackTrace? stackTrace;

  /// The source/location where the error occurred.
  final String? source;

  /// Additional context about the error.
  final Map<String, dynamic> errorContext;

  /// Whether this error is fatal (causes app crash).
  final bool isFatal;

  /// User action that triggered the error (if available).
  final String? userAction;

  /// Creates a new error log entry.
  ErrorLog({
    super.id,
    DateTime? timestamp,
    required this.error,
    this.stackTrace,
    this.source,
    Map<String, dynamic>? errorContext,
    this.isFatal = false,
    this.userAction,
    super.category = 'error',
    super.tags,
    LogLevel? level,
  }) : errorContext = errorContext ?? {},
       super(
         level: level ?? (isFatal ? LogLevel.critical : LogLevel.error),
         timestamp: timestamp,
       );

  @override
  String get eventType => isFatal ? 'fatal_error' : 'error';

  @override
  String get title =>
      '${isFatal ? 'Fatal Error' : 'Error'}: ${error.runtimeType}';

  @override
  String get description {
    final buffer = StringBuffer();
    buffer.write(error.toString());

    if (source != null) {
      buffer.write(' in $source');
    }

    if (userAction != null) {
      buffer.write(' (triggered by: $userAction)');
    }

    return buffer.toString();
  }

  @override
  Map<String, dynamic> get metadata => {
    'error': error.toString(),
    'errorType': error.runtimeType.toString(),
    'stackTrace': stackTrace?.toString(),
    'source': source,
    'errorContext': errorContext,
    'isFatal': isFatal,
    'userAction': userAction,
  };

  @override
  bool matches(String query) {
    final lowercaseQuery = query.toLowerCase();

    return super.matches(query) ||
        (source?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (userAction?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        error.runtimeType.toString().toLowerCase().contains(lowercaseQuery);
  }

  /// Creates a copy of this error log with updated fields.
  ErrorLog copyWith({
    String? id,
    DateTime? timestamp,
    Object? error,
    StackTrace? stackTrace,
    String? source,
    Map<String, dynamic>? errorContext,
    bool? isFatal,
    String? userAction,
    String? category,
    Set<String>? tags,
    LogLevel? level,
  }) {
    return ErrorLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      source: source ?? this.source,
      errorContext: errorContext ?? this.errorContext,
      isFatal: isFatal ?? this.isFatal,
      userAction: userAction ?? this.userAction,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      level: level ?? this.level,
    );
  }

  /// Creates an ErrorLog from JSON.
  static ErrorLog fromJson(Map<String, dynamic> json) {
    return ErrorLog(
      id: json['id'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String) ??
          TimestampHelper.now(),
      error: json['error'] as String? ?? 'Unknown error',
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      source: json['source'] as String?,
      errorContext: (json['errorContext'] as Map<String, dynamic>?) ?? {},
      isFatal: json['isFatal'] as bool? ?? false,
      userAction: json['userAction'] as String?,
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toSet() ??
          <String>{},
      level: LogLevel.fromString(json['level'] as String) ?? LogLevel.error,
    );
  }
}

/// Represents a widget/UI related error in the log system.
class UIErrorLog extends ErrorLog {
  /// The widget that caused the error.
  final String? widgetName;

  /// Widget tree path to the error location.
  final String? widgetPath;

  /// Properties of the widget when the error occurred.
  final Map<String, dynamic>? widgetProperties;

  /// Creates a new UI error log entry.
  UIErrorLog({
    super.id,
    super.timestamp,
    required super.error,
    super.stackTrace,
    super.source,
    super.errorContext,
    super.isFatal = false,
    super.userAction,
    this.widgetName,
    this.widgetPath,
    this.widgetProperties,
    super.category = 'ui',
    super.tags,
    super.level,
  });

  @override
  String get eventType => 'ui_error';

  @override
  String get title => 'UI Error: ${widgetName ?? error.runtimeType}';

  @override
  String get description {
    final buffer = StringBuffer();
    buffer.write(super.description);

    if (widgetName != null) {
      buffer.write(' in widget $widgetName');
    }

    if (widgetPath != null) {
      buffer.write(' at $widgetPath');
    }

    return buffer.toString();
  }

  @override
  Map<String, dynamic> get metadata => {
    ...super.metadata,
    'widgetName': widgetName,
    'widgetPath': widgetPath,
    'widgetProperties': widgetProperties,
  };

  @override
  bool matches(String query) {
    final lowercaseQuery = query.toLowerCase();

    return super.matches(query) ||
        (widgetName?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (widgetPath?.toLowerCase().contains(lowercaseQuery) ?? false);
  }

  /// Creates a copy of this UI error log with updated fields.
  @override
  UIErrorLog copyWith({
    String? id,
    DateTime? timestamp,
    Object? error,
    StackTrace? stackTrace,
    String? source,
    Map<String, dynamic>? errorContext,
    bool? isFatal,
    String? userAction,
    String? category,
    Set<String>? tags,
    LogLevel? level,
    String? widgetName,
    String? widgetPath,
    Map<String, dynamic>? widgetProperties,
  }) {
    return UIErrorLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      source: source ?? this.source,
      errorContext: errorContext ?? this.errorContext,
      isFatal: isFatal ?? this.isFatal,
      userAction: userAction ?? this.userAction,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      level: level ?? this.level,
      widgetName: widgetName ?? this.widgetName,
      widgetPath: widgetPath ?? this.widgetPath,
      widgetProperties: widgetProperties ?? this.widgetProperties,
    );
  }

  /// Creates a UIErrorLog from JSON.
  static UIErrorLog fromJson(Map<String, dynamic> json) {
    return UIErrorLog(
      id: json['id'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String) ??
          TimestampHelper.now(),
      error: json['error'] as String? ?? 'Unknown error',
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      source: json['source'] as String?,
      errorContext: (json['errorContext'] as Map<String, dynamic>?) ?? {},
      isFatal: json['isFatal'] as bool? ?? false,
      userAction: json['userAction'] as String?,
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toSet() ??
          <String>{},
      level: LogLevel.fromString(json['level'] as String) ?? LogLevel.error,
      widgetName: json['widgetName'] as String?,
      widgetPath: json['widgetPath'] as String?,
      widgetProperties: json['widgetProperties'] as Map<String, dynamic>?,
    );
  }
}
