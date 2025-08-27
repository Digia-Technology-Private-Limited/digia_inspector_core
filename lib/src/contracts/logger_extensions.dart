import '../models/log_event.dart';
import '../utils/log_level.dart';
import 'digia_logger.dart';

/// Extension methods for DigiaLogger that provide convenient logging methods.
///
/// These methods create appropriate LogEvent instances and call the core log() method.
extension DigiaLoggerExtensions on DigiaLogger {
  /// Convenience method to log a simple message with a specified level.
  ///
  /// This creates a basic LogEvent internally and calls [log].
  void logMessage(
    String message, {
    LogLevel level = LogLevel.info,
    String? category,
    Set<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    log(
      _SimpleLogEvent(
        level: level,
        message: message,
        category: category,
        tags: tags,
        metadata: metadata ?? {},
      ),
    );
  }

  /// Logs a debug message.
  void debug(
    String message, {
    String? category,
    Set<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    logMessage(
      message,
      level: LogLevel.debug,
      category: category,
      tags: tags,
      metadata: metadata,
    );
  }

  /// Logs an info message.
  void info(
    String message, {
    String? category,
    Set<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    logMessage(
      message,
      level: LogLevel.info,
      category: category,
      tags: tags,
      metadata: metadata,
    );
  }

  /// Logs a warning message.
  void warning(
    String message, {
    String? category,
    Set<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    logMessage(
      message,
      level: LogLevel.warning,
      category: category,
      tags: tags,
      metadata: metadata,
    );
  }

  /// Logs an error message.
  void error(
    String message, {
    String? category,
    Set<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    logMessage(
      message,
      level: LogLevel.error,
      category: category,
      tags: tags,
      metadata: metadata,
    );
  }

  /// Logs a critical message.
  void critical(
    String message, {
    String? category,
    Set<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    logMessage(
      message,
      level: LogLevel.critical,
      category: category,
      tags: tags,
      metadata: metadata,
    );
  }
}

/// A simple implementation of LogEvent for basic message logging.
class _SimpleLogEvent extends LogEvent {
  final String message;
  final Map<String, dynamic> _metadata;

  _SimpleLogEvent({
    required LogLevel level,
    required this.message,
    String? category,
    Set<String>? tags,
    required Map<String, dynamic> metadata,
  }) : _metadata = metadata,
       super(level: level, category: category, tags: tags);

  @override
  String get eventType => 'message';

  @override
  String get title =>
      message.length > 50 ? '${message.substring(0, 47)}...' : message;

  @override
  String get description => message;

  @override
  Map<String, dynamic> get metadata => _metadata;
}
