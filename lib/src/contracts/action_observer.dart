import 'package:digia_inspector_core/src/models/action_log.dart';

/// Observer interface for action execution events
///
/// Implementations of this interface can register to receive notifications
/// about action lifecycle events including start, progress, completion, and
/// disabling. This enables debugging, monitoring, and logging of action execution.
abstract class ActionObserver {
  /// Called when an action starts executing
  ///
  /// [event] contains the action details and timing information
  void onActionStart(ActionLog event);

  /// Called to report progress during long-running actions
  ///
  /// [event] contains progress information in the progressData field
  void onActionProgress(ActionLog event);

  /// Called when an action completes (successfully or with error)
  ///
  /// [event] contains completion status, timing, and any error information
  void onActionComplete(ActionLog event);

  /// Called when an action is disabled and skipped
  ///
  /// [event] contains the action details and reason for disabling
  void onActionDisabled(ActionLog event);
}
