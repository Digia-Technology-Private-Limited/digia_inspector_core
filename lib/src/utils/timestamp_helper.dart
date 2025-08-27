/// Utilities for handling timestamps in log events.
class TimestampHelper {
  /// Creates a timestamp for the current moment.
  static DateTime now() => DateTime.now();

  /// Formats a timestamp as a human-readable string.
  ///
  /// Example: "2024-01-15 14:30:25.123"
  static String format(DateTime timestamp) {
    return timestamp.toString().substring(0, 23);
  }

  /// Formats a timestamp as a compact string suitable for display in logs.
  ///
  /// Example: "14:30:25.123"
  static String formatTime(DateTime timestamp) {
    final timeString = timestamp.toString().substring(11, 23);
    return timeString;
  }

  /// Formats a timestamp as an ISO 8601 string.
  ///
  /// Example: "2024-01-15T14:30:25.123Z"
  static String formatISO(DateTime timestamp) {
    return timestamp.toUtc().toIso8601String();
  }

  /// Returns the elapsed time between two timestamps as a human-readable string.
  ///
  /// Example: "1.234s", "123ms"
  static String formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final milliseconds = duration.inMilliseconds;

    if (milliseconds < 1000) {
      return '${milliseconds}ms';
    } else {
      final seconds = milliseconds / 1000.0;
      return '${seconds.toStringAsFixed(3)}s';
    }
  }

  /// Returns a relative time description from the given timestamp to now.
  ///
  /// Example: "2 minutes ago", "just now"
  static String formatRelative(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
  }
}
