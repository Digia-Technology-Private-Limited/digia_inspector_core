/// Log severity levels for categorizing and filtering log events.
enum LogLevel {
  /// Verbose debugging information, typically only useful during development.
  verbose,

  /// Detailed information for debugging purposes.
  debug,

  /// General informational messages about normal operation.
  info,

  /// Warning messages about potentially problematic situations.
  warning,

  /// Error messages indicating failures that don't prevent continued operation.
  error,

  /// Critical errors that may cause the application to crash or become unusable.
  critical;

  /// The display name for this log level.
  String get displayName => name.toUpperCase();

  /// The numerical priority of this log level (higher = more severe).
  int get priority => index;

  /// Returns true if this log level is more severe than [other].
  bool isMoreSevereThan(LogLevel other) => priority > other.priority;

  /// Returns true if this log level is less severe than [other].
  bool isLessSevereThan(LogLevel other) => priority < other.priority;

  /// Creates a LogLevel from a string name (case-insensitive).
  static LogLevel? fromString(String name) {
    for (final level in LogLevel.values) {
      if (level.name.toLowerCase() == name.toLowerCase()) {
        return level;
      }
    }
    return null;
  }
}
