import 'package:digia_inspector_core/src/models/digia_log_event.dart';

/// Action status enum
///
/// Represents the current status of an action.
/// This enum is used to track the progress and completion of an action.

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

/// Action log event data structure
///
/// Represents an action event in the action execution lifecycle.
/// This class captures all necessary information for debugging and monitoring
/// action execution, including timing, parameters, status, and hierarchy.
class ActionLog extends DigiaLogEvent {
  /// Constructor for ActionLog
  ///
  /// [id] - Unique identifier for this action log
  /// [actionType] - Type/class name of the action
  /// [status] - Current status of the action
  /// [executionTime] - How long the action took to execute
  /// (null if still running)
  /// [parentActionId] - ID of the parent log (for nested actions)
  /// [sourceChain] - Widget hierarchy and trigger information
  /// [triggerName] - Name of the trigger that initiated this action
  /// [actionDefinition] - Full action definition/configuration
  /// [resolvedParameters] - Resolved parameters used for execution
  /// [progressData] - Progress information for long-running actions
  /// [error] - Error object if action failed
  /// [errorMessage] - Human-readable error message
  /// [stackTrace] - Stack trace if action failed
  ActionLog({
    required super.id,
    required super.timestamp,
    required super.category,
    required this.actionType,
    required this.status,
    this.sourceChain,
    this.triggerName,
    required this.actionDefinition,
    required this.resolvedParameters,
    this.executionTime,
    this.parentActionId,
    this.progressData,
    this.error,
    this.errorMessage,
    this.stackTrace,
  });

  /// Type/class name of the action
  final String actionType;

  /// Current status of the action
  final ActionStatus status;

  /// How long the action took to execute (null if still running)
  final Duration? executionTime;

  /// ID of the parent log (for nested actions)
  final String? parentActionId;

  /// Widget hierarchy and trigger information
  final List<String>? sourceChain;

  /// Name of the trigger that initiated this action
  /// (e.g., 'onClick', 'onPageLoad')
  final String? triggerName;

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

  /// Create a copy of this log with updated fields
  ActionLog copyWith({
    String? actionType,
    ActionStatus? status,
    Duration? executionTime,
    String? parentActionId,
    List<String>? sourceChain,
    String? triggerName,
    Map<String, dynamic>? actionDefinition,
    Map<String, dynamic>? resolvedParameters,
    Map<String, dynamic>? progressData,
    Object? error,
    String? errorMessage,
    StackTrace? stackTrace,
    String? id,
    DateTime? timestamp,
    String? category,
    Set<String>? tags,
  }) {
    return ActionLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      actionType: actionType ?? this.actionType,
      status: status ?? this.status,
      executionTime: executionTime ?? this.executionTime,
      parentActionId: parentActionId ?? this.parentActionId,
      sourceChain: sourceChain ?? this.sourceChain,
      triggerName: triggerName ?? this.triggerName,
      actionDefinition: actionDefinition ?? this.actionDefinition,
      resolvedParameters: resolvedParameters ?? this.resolvedParameters,
      progressData: progressData ?? this.progressData,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  /// Get formatted source chain for display
  String get formattedSourceChain => sourceChain?.join(' → ') ?? '';

  /// Check if this is a top-level action (no parent)
  bool get isTopLevel => parentActionId == null;

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
        'id: $id, '
        'actionType: $actionType, '
        'status: $status, '
        'sourceChain: ${sourceChain?.join(' → ') ?? ''}, '
        'triggerName: $triggerName'
        ')';
  }

  @override
  String get description => 'ActionLog';

  @override
  String get eventType => 'action';

  @override
  String get title => 'ActionLog';
}
