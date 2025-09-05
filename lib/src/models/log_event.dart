import '../utils/log_level.dart';
import '../utils/timestamp_helper.dart';

/// Base class for all loggable events in the Digia ecosystem.
///
/// This abstract class provides the foundation for different types of log events
/// such as network requests, widget tree changes, errors, and custom application logs.
abstract class DigiaLogEvent {
  /// Unique identifier for this log event.
  final String id;

  /// The severity level of this log event.
  final LogLevel level;

  /// When this log event occurred.
  final DateTime timestamp;

  /// Optional category for grouping related log events.
  final String? category;

  /// Optional tags for additional classification.
  final Set<String> tags;

  /// Creates a new log event.
  ///
  /// [id] should be unique across all log events. If not provided, a UUID will be generated.
  /// [level] determines the severity of this event.
  /// [timestamp] defaults to the current time if not provided.
  /// [category] can be used to group related events (e.g., "network", "ui", "auth").
  /// [tags] provide additional classification (e.g., {"error", "critical", "auth"}).
  DigiaLogEvent({
    String? id,
    required this.level,
    DateTime? timestamp,
    this.category,
    Set<String>? tags,
  }) : id = id ?? _generateId(),
       timestamp = timestamp ?? TimestampHelper.now(),
       tags = tags ?? <String>{};

  /// The type of this log event (e.g., "network", "error", "custom").
  ///
  /// This is used for filtering and display purposes in the inspector UI.
  String get eventType;

  /// A human-readable title for this log event.
  String get title;

  /// A detailed description of what happened in this log event.
  String get description;

  /// Additional metadata associated with this log event.
  ///
  /// This can include request/response data, stack traces, or any other
  /// relevant information that helps with debugging.
  Map<String, dynamic> get metadata => {};

  /// Returns true if this log event matches the given search query.
  ///
  /// The default implementation searches in the title, description, category,
  /// and tags. Subclasses can override this to provide more sophisticated
  /// search capabilities.
  bool matches(String query) {
    final lowercaseQuery = query.toLowerCase();

    return title.toLowerCase().contains(lowercaseQuery) ||
        description.toLowerCase().contains(lowercaseQuery) ||
        (category?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
        eventType.toLowerCase().contains(lowercaseQuery);
  }

  /// Returns a JSON representation of this log event.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventType': eventType,
      'level': level.name,
      'timestamp': TimestampHelper.formatISO(timestamp),
      'title': title,
      'description': description,
      'category': category,
      'tags': tags.toList(),
      'metadata': metadata,
    };
  }

  /// Creates a LogEvent from a JSON representation.
  ///
  /// Note: This returns a generic LogEvent. Specific subclasses should
  /// override this method to return their specific type.
  static DigiaLogEvent fromJson(Map<String, dynamic> json) {
    return _GenericLogEvent(
      id: json['id'] as String,
      level: LogLevel.fromString(json['level'] as String) ?? LogLevel.info,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String) ??
          TimestampHelper.now(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toSet() ??
          <String>{},
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  @override
  String toString() {
    return 'LogEvent{id: $id, type: $eventType, level: ${level.name}, '
        'timestamp: ${TimestampHelper.format(timestamp)}, title: $title}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DigiaLogEvent && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// Generates a unique ID for a log event.
  static String _generateId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final random = timestamp.hashCode;
    return 'log_${timestamp}_$random';
  }
}

/// A generic implementation of LogEvent for cases where we need to create
/// log events from JSON without knowing the specific subclass.
class _GenericLogEvent extends DigiaLogEvent {
  final String _eventType;
  final String _title;
  final String _description;
  final Map<String, dynamic> _metadata;

  _GenericLogEvent({
    required String id,
    required LogLevel level,
    required DateTime timestamp,
    required String title,
    required String description,
    required String? category,
    required Set<String> tags,
    required Map<String, dynamic> metadata,
  }) : _eventType = 'generic',
       _title = title,
       _description = description,
       _metadata = metadata,
       super(
         id: id,
         level: level,
         timestamp: timestamp,
         category: category,
         tags: tags,
       );

  @override
  String get eventType => _eventType;

  @override
  String get title => _title;

  @override
  String get description => _description;

  @override
  Map<String, dynamic> get metadata => _metadata;
}
