import 'package:digia_inspector_core/src/models/digia_log_event.dart';

/// Action observability event data structure
///
/// Represents an action event in the action execution lifecycle.
/// This class captures all necessary information for debugging and monitoring
/// action execution, including timing, parameters, status, and hierarchy.

enum ActionStatus {
  /// Action is queued for execution
  pending,

  /// Action is currently running
  running,

  /// Action completed successfully
  completed,

  /// Action failed with an error
  error,

  /// Action was disabled and skipped
  disabled,
}

class ActionLog extends DigiaLogEvent {
  /// Unique identifier for this action log
  final String eventId;

  /// ID of the action being executed
  final String actionId;

  /// Type/class name of the action
  final String actionType;

  /// Current status of the action
  final ActionStatus status;

  /// When this log was created
  final DateTime timestamp;

  /// How long the action took to execute (null if still running)
  final Duration? executionTime;

  /// ID of the parent log (for nested actions)
  final String? parentEventId;

  /// Widget hierarchy and trigger information
  final List<String> sourceChain;

  /// Name of the trigger that initiated this action (e.g., 'onClick', 'onPageLoad')
  final String triggerName;

  /// Full action definition/configuration
  final Map<String, dynamic> actionDefinition;

  /// Resolved parameters used for execution
  final Map<String, dynamic> resolvedParameters;

  /// Progress information for long-running actions
  final Map<String, dynamic>? progressData;

  /// Error object if action failed
  final Object? error;

  /// Human-readable error message
  final String? errorMessage;

  /// Stack trace if action failed
  final StackTrace? stackTrace;

  /// Additional metadata for debugging
  final Map<String, dynamic> metadata;

  ActionLog({
    required this.eventId,
    required this.actionId,
    required this.actionType,
    required this.status,
    required this.timestamp,
    this.executionTime,
    this.parentEventId,
    required this.sourceChain,
    required this.triggerName,
    required this.actionDefinition,
    required this.resolvedParameters,
    this.progressData,
    this.error,
    this.errorMessage,
    this.stackTrace,
    this.metadata = const {},
  });

  /// Create a copy of this log with updated fields
  ActionLog copyWith({
    String? eventId,
    String? actionId,
    String? actionType,
    ActionStatus? status,
    DateTime? timestamp,
    Duration? executionTime,
    String? parentEventId,
    List<String>? sourceChain,
    String? triggerName,
    Map<String, dynamic>? actionDefinition,
    Map<String, dynamic>? resolvedParameters,
    Map<String, dynamic>? progressData,
    Object? error,
    String? errorMessage,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    return ActionLog(
      eventId: eventId ?? this.eventId,
      actionId: actionId ?? this.actionId,
      actionType: actionType ?? this.actionType,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      executionTime: executionTime ?? this.executionTime,
      parentEventId: parentEventId ?? this.parentEventId,
      sourceChain: sourceChain ?? this.sourceChain,
      triggerName: triggerName ?? this.triggerName,
      actionDefinition: actionDefinition ?? this.actionDefinition,
      resolvedParameters: resolvedParameters ?? this.resolvedParameters,
      progressData: progressData ?? this.progressData,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      stackTrace: stackTrace ?? this.stackTrace,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get formatted source chain for display
  String get formattedSourceChain => sourceChain.join(' → ');

  /// Check if this is a top-level action (no parent)
  bool get isTopLevel => parentEventId == null;

  /// Check if this action is currently running
  bool get isRunning => status == ActionStatus.running;

  /// Check if this action completed successfully
  bool get isCompleted => status == ActionStatus.completed;

  /// Check if this action failed
  bool get isFailed => status == ActionStatus.error;

  /// Check if this action was disabled
  bool get isDisabled => status == ActionStatus.disabled;

  /// Check if this action is pending
  bool get isPending => status == ActionStatus.pending;

  @override
  String toString() {
    return 'ActionLog('
        'eventId: $eventId, '
        'actionType: $actionType, '
        'status: $status, '
        'sourceChain: $formattedSourceChain'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActionLog && other.eventId == eventId;
  }

  @override
  int get hashCode => eventId.hashCode;

  @override
  String get description => 'ActionLog';

  @override
  String get eventType => 'action';

  @override
  String get title => 'ActionLog';
}
