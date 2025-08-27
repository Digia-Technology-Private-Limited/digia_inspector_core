import '../models/log_event.dart';
import '../utils/log_level.dart';

/// Abstract interface for receiving and handling log events.
///
/// This interface allows different implementations of logging behavior
/// without coupling the logging source to a specific logger implementation.
abstract class DigiaLogger {
  /// Logs a general event.
  ///
  /// This is the primary method for sending log events to the logger.
  /// Implementations should handle the event according to their specific
  /// behavior (e.g., storing in memory, writing to file, sending to server).
  void log(LogEvent event);

  /// Returns true if this logger accepts events at the specified level.
  ///
  /// This can be used to avoid expensive operations when creating log events
  /// that would be filtered out anyway.
  bool isLevelEnabled(LogLevel level) => true;

  /// Returns the current minimum log level this logger accepts.
  ///
  /// Events with a level below this threshold may be ignored.
  LogLevel get minimumLevel => LogLevel.verbose;

  /// Flushes any pending log events.
  ///
  /// This is useful for implementations that buffer events before processing.
  Future<void> flush() async {}

  /// Closes the logger and releases any resources.
  ///
  /// After calling this method, the logger should not be used anymore.
  Future<void> close() async {}
}

/// A no-op logger implementation that discards all log events.
///
/// This is useful as a default logger or for testing scenarios where
/// you don't want actual logging to occur.
class NoOpLogger implements DigiaLogger {
  const NoOpLogger();

  @override
  void log(LogEvent event) {
    // Do nothing
  }

  @override
  bool isLevelEnabled(LogLevel level) => false;

  @override
  LogLevel get minimumLevel => LogLevel.critical;

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {}
}
