/// Context information for action observability
///
/// Captures the widget hierarchy and trigger information needed to
/// understand where an action was initiated from. This provides the
/// source chain for debugging and monitoring action execution.
class ObservabilityContext {
  /// Constructor for ObservabilityContext
  ///
  /// [widgetHierarchy] - Widget hierarchy from root to current widget
  /// [currentEntityId] - ID of the current entity (page or component)
  /// [triggerType] - Type of trigger (onClick, onPageLoad, etc.)
  const ObservabilityContext({
    required this.widgetHierarchy,
    this.triggerType,
    this.currentEntityId,
  });

  /// Widget hierarchy from root to current widget
  final List<String> widgetHierarchy;

  /// ID of the current entity (page or component)
  final String? currentEntityId;

  /// Type of trigger (onClick, onPageLoad, etc.)
  final String? triggerType;

  /// Get the complete source chain for display
  ///
  /// Returns only hierarchy (page/component + widgets) without appending trigger
  List<String> get sourceChain {
    final chain = <String>[];

    // Add entity context (page or component) if available
    if (currentEntityId != null) {
      chain.add(currentEntityId!);
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
    String? currentEntityId,
    String? triggerType,
  }) {
    return ObservabilityContext(
      widgetHierarchy: widgetHierarchy ?? this.widgetHierarchy,
      currentEntityId: currentEntityId ?? this.currentEntityId,
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
  /// This preserves the entity context and adds the component to the hierarchy
  ObservabilityContext forComponent({required String componentId}) {
    return copyWith(
      widgetHierarchy: [...widgetHierarchy, componentId],
      triggerType: 'onComponentLoad',
    );
  }

  /// Create a context for triggering an action
  /// This sets the trigger information while preserving the hierarchy
  ObservabilityContext forTrigger({required String triggerType}) {
    return copyWith(
      triggerType: triggerType,
    );
  }

  @override
  String toString() {
    return 'ObservabilityContext(sourceChain: $formattedSourceChain)';
  }
}
