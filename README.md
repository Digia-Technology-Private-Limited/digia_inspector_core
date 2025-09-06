# Digia Inspector Core

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/license-BSL%201.1-green.svg)](LICENSE)
[![Documentation](https://img.shields.io/badge/docs-digia.tech-blue.svg)](https://docs.digia.tech)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

**Digia Inspector Core** provides the foundational debugging interfaces and contracts for Digia applications. This core package enables comprehensive logging, network monitoring, and action tracking capabilities without introducing UI dependencies, making it perfect for sharing debugging infrastructure across different Digia packages.

## 🚀 Overview

### What is Digia Inspector Core?

Digia Inspector Core is the backbone of the Digia debugging ecosystem. It provides:

- **🔍 Abstract Logging Interfaces** - Flexible contracts that allow different logging implementations
- **🌐 Network Monitoring Contracts** - Built-in HTTP interceptor interfaces for comprehensive request/response tracking
- **⚡ Action Observation** - Observer patterns for monitoring action execution and performance
- **📊 Structured Event System** - Type-safe log events with categorization, tagging, and search capabilities
- **🔄 JSON Serialization** - Complete serialization support for log persistence and transmission
- **⏰ Timestamp Utilities** - Consistent time handling across all logging operations

### Key Features

- 🎯 **Zero UI Dependencies** - Core contracts only, perfect for sharing across packages
- 🔗 **Flexible Architecture** - Abstract interfaces allow custom implementations
- 📱 **Cross-Platform** - Works seamlessly across Android, iOS, Web, and Desktop
- 🚀 **High Performance** - Lightweight contracts with minimal overhead
- 🧪 **Testing Ready** - No-op implementations for testing scenarios
- 📚 **Well Documented** - Comprehensive documentation and examples
- 🔍 **Type Safe** - Strongly typed interfaces throughout

## 📦 Installation

Add Digia Inspector Core to your `pubspec.yaml`:

```yaml
dependencies:
  digia_inspector_core: ^0.0.1
```

Or use the Flutter CLI:

```bash
flutter pub add digia_inspector_core
```

Run:

```bash
flutter pub get
```

## 🏁 Getting Started

### Basic Inspector Implementation

Create your own inspector by implementing the `DigiaInspector` interface:

```dart
import 'package:digia_inspector_core/digia_inspector_core.dart';

class MyCustomInspector implements DigiaInspector {
  final List<DigiaLogEvent> _logs = [];

  @override
  void log(DigiaLogEvent event) {
    _logs.add(event);
    print('📝 ${event.eventType}: ${event.title}');
  }

  @override
  DigiaDioInterceptor? get dioInterceptor => MyDioInterceptor();

  @override
  ActionObserver? get actionObserver => MyActionObserver();

  List<DigiaLogEvent> get logs => List.unmodifiable(_logs);
}
```

### Network Monitoring

Implement the `DigiaDioInterceptor` for HTTP monitoring:

```dart
class MyDioInterceptor implements DigiaDioInterceptor {
  final DigiaInspector inspector;

  MyDioInterceptor(this.inspector);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final log = NetworkRequestLog(
      url: options.uri.toString(),
      method: options.method,
      headers: options.headers,
      body: options.data,
    );
    inspector.log(log);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final log = NetworkResponseLog(
      statusCode: response.statusCode ?? 0,
      headers: response.headers.map,
      body: response.data,
      requestUrl: response.requestOptions.uri.toString(),
    );
    inspector.log(log);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final log = NetworkErrorLog(
      error: err.message ?? 'Unknown error',
      requestUrl: err.requestOptions.uri.toString(),
      statusCode: err.response?.statusCode,
    );
    inspector.log(log);
    handler.next(err);
  }
}
```

### Action Monitoring

Implement the `ActionObserver` for tracking action execution:

```dart
class MyActionObserver implements ActionObserver {
  final DigiaInspector inspector;

  MyActionObserver(this.inspector);

  @override
  void onActionStarted(ActionLog actionLog) {
    inspector.log(actionLog);
  }

  @override
  void onActionCompleted(ActionLog actionLog) {
    inspector.log(actionLog);
  }

  @override
  void onActionFailed(ActionLog actionLog) {
    inspector.log(actionLog);
  }
}
```

## 🛠️ Usage Examples

### Creating Custom Log Events

Extend `DigiaLogEvent` to create custom log types:

```dart
class CustomUserActionEvent extends DigiaLogEvent {
  final String userId;
  final String action;
  final Map<String, dynamic> actionData;

  CustomUserActionEvent({
    required this.userId,
    required this.action,
    required this.actionData,
    String? category,
    Set<String>? tags,
  }) : super(
         category: category ?? 'user_actions',
         tags: tags ?? {'user', 'interaction'},
       );

  @override
  String get eventType => 'user_action';

  @override
  String get title => 'User $action';

  @override
  String get description => 'User $userId performed $action';

  @override
  Map<String, dynamic> get metadata => {
        'userId': userId,
        'action': action,
        'actionData': actionData,
      };
}
```

### Using the No-Op Inspector

For testing or when you want to disable logging:

```dart
final inspector = NoOpInspector();
inspector.log(someEvent); // Does nothing
```

### Searching and Filtering Events

All log events support searching:

```dart
final events = inspector.logs;
final filteredEvents = events.where((event) =>
  event.matches('network') || event.category == 'api'
).toList();
```

### JSON Serialization

All log events can be serialized to/from JSON:

```dart
// Serialize
final json = event.toJson();

// Deserialize
final restoredEvent = DigiaLogEvent.fromJson(json);

// For custom events, implement fromJson
static CustomUserActionEvent fromJson(Map<String, dynamic> json) {
  return CustomUserActionEvent(
    userId: json['metadata']['userId'],
    action: json['metadata']['action'],
    actionData: json['metadata']['actionData'],
    category: json['category'],
    tags: Set<String>.from(json['tags'] ?? []),
  );
}
```

## 🏗️ Architecture

### Core Contracts

- **`DigiaInspector`** - Main interface for receiving and handling log events
- **`DigiaDioInterceptor`** - Contract for HTTP request/response monitoring
- **`ActionObserver`** - Interface for monitoring action execution

### Event Models

- **`DigiaLogEvent`** - Base class for all loggable events
- **`NetworkRequestLog`** - HTTP request logging
- **`NetworkResponseLog`** - HTTP response logging
- **`NetworkErrorLog`** - HTTP error logging
- **`ActionLog`** - Action execution logging with performance metrics

### Utilities

- **`TimestampHelper`** - Consistent timestamp formatting and management
- **`ObservabilityContext`** - Context information for tracing and debugging

## 📊 Event Types

| Event Type           | Description               | Use Case                                  |
| -------------------- | ------------------------- | ----------------------------------------- |
| `NetworkRequestLog`  | HTTP request details      | API monitoring, debugging requests        |
| `NetworkResponseLog` | HTTP response details     | API monitoring, response analysis         |
| `NetworkErrorLog`    | HTTP error information    | Error tracking, debugging failures        |
| `ActionLog`          | Action execution tracking | Performance monitoring, user interactions |
| Custom Events        | Your custom event types   | Application-specific logging needs        |

## 🧪 Testing

Use the provided no-op implementations for testing:

```dart
void main() {
  group('Inspector Tests', () {
    late DigiaInspector inspector;

    setUp(() {
      inspector = NoOpInspector(); // Won't actually log anything
    });

    test('should handle log events gracefully', () {
      final event = NetworkRequestLog(
        url: 'https://api.example.com',
        method: 'GET',
      );

      expect(() => inspector.log(event), returnsNormally);
    });
  });
}
```

## 📄 License

This project is licensed under the Business Source License 1.1 (BSL 1.1) - see the [LICENSE](LICENSE) file for details. The BSL 1.1 allows personal and commercial use with certain restrictions around competing platforms. On September 7, 2029, the license will automatically convert to Apache License 2.0.

For commercial licensing inquiries or exceptions, please contact admin@digia.tech.

## 🆘 Support

- 📚 [Documentation](https://docs.digia.tech)
- 💬 [Community](https://discord.gg/szgbr63a)
- 🐛 [Issue Tracker](https://github.com/Digia-Technology-Private-Limited/digia_inspector_core/issues)
- 📧 [Contact Support](mailto:admin@digia.tech)

---

Built with ❤️ by the Digia team
