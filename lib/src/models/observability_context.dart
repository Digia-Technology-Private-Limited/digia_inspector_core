/// Context information for action observability
///
/// Captures the widget hierarchy and trigger information needed to
/// understand where an action was initiated from. This provides the
/// source chain for debugging and monitoring action execution.
class ObservabilityContext {
  /// Widget hierarchy from root to current widget
  final List<String> widgetHierarchy;

  /// ID of the current page
  final String? currentPageId;

  /// ID of the current component
  final String? currentComponentId;

  /// ID of the widget that triggered the action
  final String? triggerWidgetId;

  /// Type of trigger (onClick, onPageLoad, etc.)
  final String triggerType;

  const ObservabilityContext({
    required this.widgetHierarchy,
    this.currentPageId,
    this.currentComponentId,
    this.triggerWidgetId,
    required this.triggerType,
  });

  /// Get the complete source chain for display
  ///
  /// Returns only hierarchy (page/component + widgets) without appending trigger
  List<String> get sourceChain {
    final chain = <String>[];

    // Add page context if available
    if (currentPageId != null) {
      chain.add('Page: $currentPageId');
    }

    // Add component context if available
    if (currentComponentId != null) {
      chain.add('Component: $currentComponentId');
    }

    // Add widget hierarchy
    chain.addAll(widgetHierarchy);

    return chain;
  }

  /// Get formatted source chain as a string
  String get formattedSourceChain {
    return sourceChain.join(' → ');
  }

  /// Create a copy with updated fields
  ObservabilityContext copyWith({
    List<String>? widgetHierarchy,
    String? currentPageId,
    String? currentComponentId,
    String? triggerWidgetId,
    String? triggerType,
  }) {
    return ObservabilityContext(
      widgetHierarchy: widgetHierarchy ?? this.widgetHierarchy,
      currentPageId: currentPageId ?? this.currentPageId,
      currentComponentId: currentComponentId ?? this.currentComponentId,
      triggerWidgetId: triggerWidgetId ?? this.triggerWidgetId,
      triggerType: triggerType ?? this.triggerType,
    );
  }

  /// Create a child context with additional hierarchy elements
  /// This is used when entering a new widget to extend the hierarchy
  ObservabilityContext extendHierarchy(List<String> additionalHierarchy) {
    return copyWith(
      widgetHierarchy: [...widgetHierarchy, ...additionalHierarchy],
    );
  }

  /// Create a child context for a new component
  /// This preserves the page context and existing hierarchy while setting the component ID
  ObservabilityContext forComponent({
    required String componentId,
    List<String>? additionalHierarchy,
  }) {
    final newHierarchy = additionalHierarchy != null
        ? [...widgetHierarchy, ...additionalHierarchy]
        : [...widgetHierarchy, 'Component($componentId)'];

    return copyWith(
      widgetHierarchy: newHierarchy,
      currentComponentId: componentId,
      triggerType: 'onComponentLoad',
    );
  }

  /// Create a context for triggering an action
  /// This sets the trigger information while preserving the hierarchy
  ObservabilityContext forTrigger({
    String? triggerWidgetId,
    required String triggerType,
    List<String>? additionalHierarchy,
  }) {
    final newHierarchy = additionalHierarchy != null
        ? [...widgetHierarchy, ...additionalHierarchy]
        : widgetHierarchy;

    return copyWith(
      widgetHierarchy: newHierarchy,
      triggerWidgetId: triggerWidgetId,
      triggerType: triggerType,
    );
  }

  @override
  String toString() {
    return 'ObservabilityContext(sourceChain: $formattedSourceChain)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ObservabilityContext &&
        other.widgetHierarchy.toString() == widgetHierarchy.toString() &&
        other.currentPageId == currentPageId &&
        other.currentComponentId == currentComponentId &&
        other.triggerWidgetId == triggerWidgetId &&
        other.triggerType == triggerType;
  }

  @override
  int get hashCode {
    return Object.hash(
      widgetHierarchy.toString(),
      currentPageId,
      currentComponentId,
      triggerWidgetId,
      triggerType,
    );
  }
}
