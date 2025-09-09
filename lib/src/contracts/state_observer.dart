/// Observer interface for monitoring state changes across the Digia framework.
///
/// This observer follows the BlocObserver pattern and provides hooks for
/// tracking state lifecycle events across different state types including
/// App State, Page State, Component State, and State Container State.
abstract class StateObserver {
  /// Called whenever a new state scope is created.
  ///
  /// [stateId] - Unique identifier for the state scope
  /// [stateType] - Type of state (app, page, component, stateContainer)
  /// [namespace] - Optional namespace for the state scope
  /// [args] - Arguments/parameters passed when the scope was created
  /// [initialState] - Initial state values
  /// [metadata] - Additional context information
  void onCreate(
    String stateId,
    StateType stateType, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? initialState,
    Map<String, Object?>? metadata,
  }) {}

  /// Called whenever state values change within a scope.
  ///
  /// [stateId] - Unique identifier for the state scope
  /// [stateType] - Type of state that changed
  /// [namespace] - Optional namespace for the state scope
  /// [args] - Arguments/parameters associated with this scope (optional; resend if changed)
  /// [changes] - Map of key-value pairs that changed
  /// [previousState] - Previous state values
  /// [currentState] - Current state values after changes
  /// [metadata] - Additional context information
  void onChange(
    String stateId,
    StateType stateType, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? changes,
    Map<String, Object?>? previousState,
    Map<String, Object?>? currentState,
    Map<String, Object?>? metadata,
  }) {}

  /// Called when a state scope is disposed or closed.
  ///
  /// [stateId] - Unique identifier for the state scope
  /// [stateType] - Type of state being disposed
  /// [namespace] - Optional namespace for the state scope
  /// [args] - Arguments/parameters associated with this scope
  /// [finalState] - Final state values before disposal
  /// [metadata] - Additional context information
  void onDispose(
    String stateId,
    StateType stateType, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? finalState,
    Map<String, Object?>? metadata,
  }) {}

  /// Called when an error occurs during state operations.
  ///
  /// [stateId] - Unique identifier for the state scope
  /// [stateType] - Type of state where error occurred
  /// [error] - The error object
  /// [stackTrace] - Stack trace of the error
  /// [namespace] - Optional namespace for the state scope
  /// [args] - Arguments/parameters associated with this scope
  /// [metadata] - Additional context information
  void onError(
    String stateId,
    StateType stateType,
    Object error,
    StackTrace stackTrace, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? metadata,
  }) {}
}

/// Enumeration of different state types in the Digia framework.
enum StateType {
  /// Global application state that persists across pages
  app('app'),

  /// State specific to a page including parameters and local state
  page('page'),

  /// State specific to a component including parameters and local state
  component('component'),

  /// State managed by state container widgets
  stateContainer('stateContainer');

  const StateType(this.value);

  /// String representation of the state type
  final String value;

  @override
  String toString() => value;
}
