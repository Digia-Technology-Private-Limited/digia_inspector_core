import 'package:digia_inspector_core/src/contracts/state_observer.dart';
import 'package:digia_inspector_core/src/models/digia_log_event.dart';
import 'package:digia_inspector_core/src/utils/timestamp_helper.dart';

/// Represents a state-related log entry in the Digia framework.
///
/// This class captures information about state lifecycle events including
/// creation, changes, and disposal across different state types.
class StateLog extends DigiaLogEvent {
  /// Constructor for StateLog
  ///
  /// [stateId] - ID of the state
  /// [stateType] - Type of state
  /// [stateEventType] - Type of event
  /// [namespace] - Namespace of the state
  /// [args] - Arguments of the state
  /// [stateData] - Data of the state
  /// [previousStateData] - Previous data of the state
  /// [changes] - Changes of the state
  /// [error] - Error of the state
  /// [stackTrace] - Stack trace of the state
  /// [metadata] - Metadata of the state
  /// [timestamp] - Timestamp of the state
  /// [id] - ID of the state log
  /// [timestamp] - Timestamp of the state log
  /// [category] - Category of the state log
  /// [tags] - Tags of the state log
  StateLog({
    required this.stateId,
    required this.stateType,
    required this.stateEventType,
    super.id,
    this.namespace,
    this.args,
    this.stateData,
    this.previousStateData,
    this.changes,
    this.error,
    this.stackTrace,
    Map<String, Object?>? metadata,
    super.timestamp,
  })  : _additionalMetadata = metadata,
        super(
          category: 'state',
          tags: {stateType.value, stateEventType.value},
        );

  /// Factory constructor for state creation events
  factory StateLog.onCreate({
    required String stateId,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? initialState,
    Map<String, Object?>? metadata,
  }) {
    return StateLog(
      id: TimestampHelper.generateId(),
      stateId: stateId,
      stateType: stateType,
      stateEventType: StateEventType.create,
      namespace: namespace,
      args: args,
      stateData: initialState,
      metadata: metadata,
    );
  }

  /// Factory constructor for state change events
  factory StateLog.onChange({
    required String stateId,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? changes,
    Map<String, Object?>? previousState,
    Map<String, Object?>? currentState,
    Map<String, Object?>? metadata,
  }) {
    return StateLog(
      id: TimestampHelper.generateId(),
      stateId: stateId,
      stateType: stateType,
      stateEventType: StateEventType.change,
      namespace: namespace,
      args: args,
      stateData: currentState,
      previousStateData: previousState,
      changes: changes,
      metadata: metadata,
    );
  }

  /// Factory constructor for state disposal events
  factory StateLog.onDispose({
    required String stateId,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? finalState,
    Map<String, Object?>? metadata,
  }) {
    return StateLog(
      id: TimestampHelper.generateId(),
      stateId: stateId,
      stateType: stateType,
      stateEventType: StateEventType.dispose,
      namespace: namespace,
      args: args,
      stateData: finalState,
      metadata: metadata,
    );
  }

  /// Factory constructor for state error events
  factory StateLog.onError({
    required String stateId,
    required StateType stateType,
    required Object error,
    required StackTrace stackTrace,
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? metadata,
  }) {
    return StateLog(
      id: TimestampHelper.generateId(),
      stateId: stateId,
      stateType: stateType,
      stateEventType: StateEventType.error,
      namespace: namespace,
      args: args,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  /// Creates a state log from JSON representation
  factory StateLog.fromJson(Map<String, dynamic> json) {
    return StateLog(
      id: json['id'] as String,
      stateId: json['stateId'] as String,
      stateType: StateType.values.firstWhere(
        (type) => type.value == json['stateType'],
      ),
      stateEventType: StateEventType.values.firstWhere(
        (type) => type.value == json['stateEventType'],
      ),
      namespace: json['namespace'] as String?,
      args: json['args'] as Map<String, Object?>?,
      stateData: json['stateData'] as Map<String, Object?>?,
      previousStateData: json['previousStateData'] as Map<String, Object?>?,
      changes: json['changes'] as Map<String, Object?>?,
      error: json['error'],
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      metadata: json['metadata'] as Map<String, Object?>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Unique identifier for the state scope
  final String stateId;

  /// Type of state (app, page, component, stateContainer)
  final StateType stateType;

  /// Type of event (create, change, dispose, error)
  final StateEventType stateEventType;

  /// Optional namespace for the state scope
  final String? namespace;

  /// Arguments/parameters passed to the state scope (page args, component args, etc.)
  final Map<String, Object?>? args;

  /// State values at the time of this event
  final Map<String, Object?>? stateData;

  /// Previous state values (for change events)
  final Map<String, Object?>? previousStateData;

  /// Specific changes made (for change events)
  final Map<String, Object?>? changes;

  /// Error information (for error events)
  final Object? error;

  /// Stack trace (for error events)
  final StackTrace? stackTrace;

  /// Additional metadata and context
  final Map<String, Object?>? _additionalMetadata;

  @override
  String get eventType => 'state';

  @override
  String get title => _generateTitle(stateEventType, stateType, namespace);

  @override
  String get description =>
      _generateDescription(stateEventType, stateType, namespace);

  @override
  Map<String, dynamic> get metadata => {
        'stateId': stateId,
        'stateType': stateType.value,
        'stateEventType': stateEventType.value,
        'namespace': namespace,
        'args': args,
        'stateData': stateData,
        'previousStateData': previousStateData,
        'changes': changes,
        'error': error?.toString(),
        'stackTrace': stackTrace?.toString(),
        ..._additionalMetadata ?? {},
      };

  /// Creates a copy of this state log with updated fields
  StateLog copyWith({
    String? id,
    String? stateId,
    StateType? stateType,
    StateEventType? stateEventType,
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? stateData,
    Map<String, Object?>? previousStateData,
    Map<String, Object?>? changes,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? metadata,
    DateTime? timestamp,
    String? description,
  }) {
    return StateLog(
      id: id ?? super.id,
      stateId: stateId ?? this.stateId,
      stateType: stateType ?? this.stateType,
      stateEventType: stateEventType ?? this.stateEventType,
      namespace: namespace ?? this.namespace,
      args: args ?? this.args,
      stateData: stateData ?? this.stateData,
      previousStateData: previousStateData ?? this.previousStateData,
      changes: changes ?? this.changes,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      metadata: metadata ?? _additionalMetadata,
      timestamp: timestamp ?? super.timestamp,
    );
  }

  /// Converts this state log to a JSON representation
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson()
      ..addAll({
        'stateId': stateId,
        'stateType': stateType.value,
        'stateEventType': stateEventType.value,
        'namespace': namespace,
        'args': args,
        'stateData': stateData,
        'previousStateData': previousStateData,
        'changes': changes,
        'error': error?.toString(),
        'stackTrace': stackTrace?.toString(),
      });
    return json;
  }

  static String _generateTitle(
      StateEventType eventType, StateType stateType, String? namespace) {
    final namespaceText = namespace != null ? ' ($namespace)' : '';
    switch (eventType) {
      case StateEventType.create:
        return '${stateType.value.toUpperCase()} Created$namespaceText';
      case StateEventType.change:
        return '${stateType.value.toUpperCase()} Changed$namespaceText';
      case StateEventType.dispose:
        return '${stateType.value.toUpperCase()} Disposed$namespaceText';
      case StateEventType.error:
        return '${stateType.value.toUpperCase()} Error$namespaceText';
    }
  }

  static String _generateDescription(
      StateEventType eventType, StateType stateType, String? namespace) {
    final namespaceText = namespace != null ? ' ($namespace)' : '';
    switch (eventType) {
      case StateEventType.create:
        return '${stateType.value.toUpperCase()} state created$namespaceText';
      case StateEventType.change:
        return '${stateType.value.toUpperCase()} state changed$namespaceText';
      case StateEventType.dispose:
        return '${stateType.value.toUpperCase()} state disposed$namespaceText';
      case StateEventType.error:
        return '${stateType.value.toUpperCase()} state error$namespaceText';
    }
  }

  @override
  String toString() {
    return 'StateLog(id: $id, stateId: $stateId, stateType: $stateType, '
        'stateEventType: $stateEventType, namespace: $namespace, '
        'timestamp: $timestamp)';
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
