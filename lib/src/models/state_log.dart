import 'package:digia_inspector_core/src/contracts/state_observer.dart';
import 'package:digia_inspector_core/src/models/digia_log_event.dart';
import 'package:digia_inspector_core/src/utils/id_helper.dart';

/// Represents a state-related log entry in the Digia framework.
///
/// This class captures information about state lifecycle events including
/// creation, changes, and disposal across different state types.
class StateLog extends DigiaLogEvent {
  /// Constructor for StateLog
  ///
  /// [stateType] - Type of state
  /// [stateEventType] - Type of event
  /// [namespace] - Namespace of the state
  /// [argData] - Arguments of the state
  /// [stateData] - Data of the state
  /// [error] - Error of the state
  /// [stackTrace] - Stack trace of the state
  /// [timestamp] - Timestamp of the state
  /// [id] - ID of the state log
  /// [timestamp] - Timestamp of the state log
  /// [category] - Category of the state log
  /// [tags] - Tags of the state log
  StateLog({
    required this.stateType,
    required this.stateEventType,
    super.id,
    this.namespace,
    this.argData,
    this.stateData,
    this.error,
    this.stackTrace,
    super.timestamp,
  }) : super(
          category: 'state',
          tags: {stateType.value, stateEventType.value},
        );

  /// Factory constructor for state creation events
  factory StateLog.onCreate({
    required String id,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? argData,
    Map<String, Object?>? stateData,
  }) {
    return StateLog(
      id: id,
      stateType: stateType,
      stateEventType: StateEventType.create,
      namespace: namespace,
      argData: argData,
      stateData: stateData,
    );
  }

  /// Factory constructor for state change events
  factory StateLog.onChange({
    required String id,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? argData,
    Map<String, Object?>? stateData,
  }) {
    return StateLog(
      id: id,
      stateType: stateType,
      stateEventType: StateEventType.change,
      namespace: namespace,
      argData: argData,
      stateData: stateData,
    );
  }

  /// Factory constructor for state disposal events
  factory StateLog.onDispose({
    required String id,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? argData,
    Map<String, Object?>? stateData,
  }) {
    return StateLog(
      id: id,
      stateType: stateType,
      stateEventType: StateEventType.dispose,
      namespace: namespace,
      argData: argData,
      stateData: stateData,
    );
  }

  /// Factory constructor for state error events
  factory StateLog.onError({
    required String id,
    required StateType stateType,
    required Object error,
    required StackTrace stackTrace,
    String? namespace,
    Map<String, Object?>? argData,
  }) {
    return StateLog(
      id: id,
      stateType: stateType,
      stateEventType: StateEventType.error,
      namespace: namespace,
      argData: argData,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Creates a state log from JSON representation
  factory StateLog.fromJson(Map<String, dynamic> json) {
    return StateLog(
      id: json['id'] as String? ?? IdHelper.randomId(),
      stateType: StateType.values.firstWhere(
        (type) => type.value == json['stateType'],
      ),
      stateEventType: StateEventType.values.firstWhere(
        (type) => type.value == json['stateEventType'],
      ),
      namespace: json['namespace'] as String?,
      argData: json['argData'] as Map<String, Object?>?,
      stateData: json['stateData'] as Map<String, Object?>?,
      error: json['error'],
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Type of state (app, page, component, stateContainer)
  final StateType stateType;

  /// Type of event (create, change, dispose, error)
  final StateEventType stateEventType;

  /// Optional namespace for the state scope
  final String? namespace;

  /// Arguments/parameters passed to the state scope (page args, component args, etc.)
  final Map<String, Object?>? argData;

  /// State values at the time of this event
  final Map<String, Object?>? stateData;

  /// Error information (for error events)
  final Object? error;

  /// Stack trace (for error events)
  final StackTrace? stackTrace;

  @override
  String get eventType => 'state';

  @override
  String get title => stateEventType.value.toUpperCase();

  @override
  String get description => stateEventType.value.toUpperCase();

  @override
  Map<String, dynamic> get metadata => {
        'stateType': stateType.value,
        'stateEventType': stateEventType.value,
        'namespace': namespace,
        'argData': argData,
        'stateData': stateData,
        'error': error?.toString(),
        'stackTrace': stackTrace?.toString(),
      };

  /// Creates a copy of this state log with updated fields
  StateLog copyWith({
    String? id,
    StateType? stateType,
    StateEventType? stateEventType,
    String? namespace,
    Map<String, Object?>? argData,
    Map<String, Object?>? stateData,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? metadata,
    DateTime? timestamp,
    String? description,
  }) {
    return StateLog(
      id: id ?? super.id,
      stateType: stateType ?? this.stateType,
      stateEventType: stateEventType ?? this.stateEventType,
      namespace: namespace ?? this.namespace,
      argData: argData ?? this.argData,
      stateData: stateData ?? this.stateData,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      timestamp: timestamp ?? super.timestamp,
    );
  }

  /// Converts this state log to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson()
      ..addAll({
        'stateType': stateType.value,
        'stateEventType': stateEventType.value,
        'namespace': namespace,
        'argData': argData,
        'stateData': stateData,
        'error': error?.toString(),
        'stackTrace': stackTrace?.toString(),
      });
    return json;
  }
}

/// Enumeration of state event types.
enum StateEventType {
  /// State scope was created
  create('create'),

  /// State values changed
  change('change'),

  /// State scope was disposed
  dispose('dispose'),

  /// Error occurred during state operations
  error('error');

  const StateEventType(this.value);

  /// String representation of the event type
  final String value;

  @override
  String toString() => value;
}
