import 'package:digia_inspector_core/src/contracts/action_observer.dart';
import 'package:digia_inspector_core/src/contracts/digia_dio_interceptor.dart';
import 'package:digia_inspector_core/src/models/digia_log_event.dart';

/// Abstract interface for receiving and handling log events.
///
/// This interface allows different implementations of logging behavior
/// without coupling the logging source to a specific logger implementation.
abstract class DigiaInspector {
  /// Logs a general event.
  ///
  /// This is the primary method for sending log events to the inspector.
  /// Implementations should handle the event according to their specific
  /// behavior (e.g., storing in memory, writing to file, sending to server).
  void log(DigiaLogEvent event);

  /// Returns the Dio interceptor for automatic network monitoring.
  ///
  /// If the inspector provides network monitoring capabilities, it should return
  /// a DigiaDioInterceptor instance. Otherwise, returns null.
  DigiaDioInterceptor? get dioInterceptor => null;

  /// Returns the action observer for action execution monitoring.
  ///
  /// If the inspector provides action observability capabilities, it should return
  /// an ActionObserver instance. Otherwise, returns null.
  ActionObserver? get actionObserver => null;
}

/// A no-op inspector implementation that discards all log events.
///
/// This is useful as a default inspector or for testing scenarios where
/// you don't want actual logging to occur.
class NoOpInspector implements DigiaInspector {
  const NoOpInspector();

  @override
  void log(DigiaLogEvent event) {
    // Do nothing
  }

  @override
  DigiaDioInterceptor? get dioInterceptor => null;

  @override
  ActionObserver? get actionObserver => null;
}
