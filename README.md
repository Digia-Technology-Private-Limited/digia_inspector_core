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
- **🏛️ State Monitoring** - Observer patterns for tracking state changes across the Digia framework

## 📦 Installation

Add Digia Inspector Core to your `pubspec.yaml`:

```yaml
dependencies:
  digia_inspector_core: ^1.0.0
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
  NetworkObserver? get dioInterceptor => MyNetworkObserver();

  @override
  ActionObserver? get actionObserver => MyActionObserver();

  @override
  StateObserver? get stateObserver => MyStateObserver();

  List<DigiaLogEvent> get logs => List.unmodifiable(_logs);
}
```

### Network Monitoring

Implement the `NetworkObserver` for HTTP monitoring:

```dart
class MyNetworkObserver implements NetworkObserver {
  final DigiaInspector inspector;
  late final Interceptor _interceptor;

  MyNetworkObserver(this.inspector) {
    _interceptor = InterceptorsWrapper(
      onRequest: onRequest,
      onResponse: onResponse,
      onError: onError,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final log = NetworkRequestLog(
      url: options.uri,
      method: options.method,
      headers: options.headers,
      body: options.data,
      requestId: options.extra['requestId'] ?? 'unknown',
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
      requestId: response.requestOptions.extra['requestId'] ?? 'unknown',
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
      requestId: err.requestOptions.extra['requestId'] ?? 'unknown',
    );
    inspector.log(log);
    handler.next(err);
  }

  @override
  Interceptor get interceptor => _interceptor;
}
```

### Action Monitoring

Implement the `ActionObserver` for tracking action execution:

```dart
class MyActionObserver implements ActionObserver {
  final DigiaInspector inspector;

  MyActionObserver(this.inspector);

  @override
  void onActionPending(ActionLog event) {
    inspector.log(event);
  }

  @override
  void onActionStart(ActionLog event) {
    inspector.log(event);
  }

  @override
  void onActionProgress(ActionLog event) {
    inspector.log(event);
  }

  @override
  void onActionComplete(ActionLog event) {
    inspector.log(event);
  }

  @override
  void onActionDisabled(ActionLog event) {
    inspector.log(event);
  }
}
```

### State Monitoring

Implement the `StateObserver` for tracking state changes:

```dart
class MyStateObserver implements StateObserver {
  final DigiaInspector inspector;

  MyStateObserver(this.inspector);

  @override
  void onCreate(
    String stateId,
    StateType stateType, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? initialState,
    Map<String, Object?>? metadata,
  }) {
    // Log state creation
    print('State created: $stateId ($stateType)');
  }

  @override
  void onChange(
    String stateId,
    StateType stateType, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? changes,
    Map<String, Object?>? previousState,
    Map<String, Object?>? currentState,
    Map<String, Object?>? metadata,
  }) {
    // Log state changes
    print('State changed: $stateId - $changes');
  }

  @override
  void onDispose(
    String stateId,
    StateType stateType, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? finalState,
    Map<String, Object?>? metadata,
  }) {
    // Log state disposal
    print('State disposed: $stateId ($stateType)');
  }

  @override
  void onError(
    String stateId,
    StateType stateType,
    Object error,
    StackTrace stackTrace, {
    String? namespace,
    Map<String, Object?>? args,
    Map<String, Object?>? metadata,
  }) {
    // Log state errors
    print('State error in $stateId: $error');
  }
}
```

### Using the No-Op Inspector

For testing or when you want to disable logging:

```dart
final inspector = NoOpInspector();
inspector.log(someEvent); // Does nothing
```

## 📄 License

This project is licensed under the Business Source License 1.1 (BSL 1.1) - see the [LICENSE](LICENSE) file for details. The BSL 1.1 allows personal and commercial use with certain restrictions around competing platforms. On September 17, 2029, the license will automatically convert to Apache License 2.0.

For commercial licensing inquiries or exceptions, please contact admin@digia.tech.

## 🆘 Support

- 📚 [Documentation](https://docs.digia.tech)
- 💬 [Community](https://discord.gg/szgbr63a)
- 🐛 [Issue Tracker](https://github.com/Digia-Technology-Private-Limited/digia_inspector_core/issues)
- 📧 [Contact Support](mailto:admin@digia.tech)

---

Built with ❤️ by the Digia team
