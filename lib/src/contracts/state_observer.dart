/// Observer interface for monitoring state changes across the Digia framework.
///
/// This observer follows the BlocObserver pattern and provides hooks for
/// tracking state lifecycle events across different state types including
/// App State, Page State, Component State, and State Container State.
abstract class StateObserver {
  /// Called whenever a new state scope is created.
  ///
  /// [id] - Unique identifier for the state scope
  /// [stateType] - Type of state (app, page, component, stateContainer)
  /// [namespace] - Optional namespace for the state scope
  /// [argData] - Arguments/parameters passed when the scope was created
  /// [stateData] - Initial state values
  void onCreate({
    required String id,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? argData,
    Map<String, Object?>? stateData,
  }) {}

  /// Called whenever state values change within a scope.
  ///
  /// [id] - Unique identifier for the state scope
  /// [stateType] - Type of state that changed
  /// [namespace] - Optional namespace for the state scope
  /// [argData] - Arguments/parameters associated with this scope (optional; resend if changed)
  /// [stateData] - Map of key-value pairs that changed
  void onChange({
    required String id,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? argData,
    Map<String, Object?>? stateData,
  }) {}

  /// Called when a state scope is disposed or closed.
  ///
  /// [id] - Unique identifier for the state scope
  /// [stateType] - Type of state being disposed
  /// [namespace] - Optional namespace for the state scope
  /// [argData] - Arguments/parameters associated with this scope
  /// [stateData] - Final state values before disposal
  void onDispose({
    required String id,
    required StateType stateType,
    String? namespace,
    Map<String, Object?>? argData,
    Map<String, Object?>? stateData,
  }) {}

  /// Called when an error occurs during state operations.
  ///
  /// [id] - Unique identifier for the state scope
  /// [stateType] - Type of state where error occurred
  /// [error] - The error object
  /// [stackTrace] - Stack trace of the error
  /// [namespace] - Optional namespace for the state scope
  void onError({
    required String id,
    required StateType stateType,
    required Object error,
    required StackTrace stackTrace,
    String? namespace,
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
