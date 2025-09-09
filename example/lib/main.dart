import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';

/// Simple example demonstrating Digia Inspector Core usage
void main() {
  runApp(const MyApp());
}

/// Simple example demonstrating Digia Inspector Core usage
class MyApp extends StatelessWidget {
  /// Simple example demonstrating Digia Inspector Core usage
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digia Inspector Core Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExamplePage(),
    );
  }
}

/// Simple example demonstrating Digia Inspector Core usage
class ExamplePage extends StatelessWidget {
  /// Simple example demonstrating Digia Inspector Core usage
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digia Inspector Core Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digia Inspector Core Features:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              '🔍 DigiaInspector',
              'Abstract interface for log handling',
              () => _demonstrateLogging(context),
            ),
            _buildFeatureCard(
              '🌐 Network Monitoring',
              'DigiaDioInterceptor for HTTP tracking',
              () => _demonstrateNetworkLogging(context),
            ),
            _buildFeatureCard(
              '⚡ Action Observer',
              'ActionObserver for execution tracking',
              () => _demonstrateActionObserver(context),
            ),
            _buildFeatureCard(
              '📊 Log Events',
              'DigiaLogEvent with search & JSON support',
              () => _demonstrateLogEvents(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Simple example demonstrating Digia Inspector Core usage
  Widget _buildFeatureCard(
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  /// Simple example demonstrating Digia Inspector Core usage
  void _demonstrateLogging(BuildContext context) {
    // Use the built-in NoOpInspector
    const inspector = NoOpInspector();

    // Create a simple custom log event
    final event = CustomLogEvent(
      message: 'User tapped logging demo',
      level: 'info',
    );

    inspector.log(event);

    _showSnackBar(context, 'Logged: ${event.title}');
  }

  /// Simple example demonstrating Digia Inspector Core usage
  void _demonstrateNetworkLogging(BuildContext context) {
    // Create a network request log
    final requestLog = NetworkRequestLog(
      method: 'GET',
      url: Uri.parse('https://api.example.com/users'),
      requestId: 'req_123',
      headers: {'Authorization': 'Bearer token'},
    );

    _showSnackBar(context, 'Network log created: ${requestLog.title}');
  }

  /// Simple example demonstrating Digia Inspector Core usage
  void _demonstrateActionObserver(BuildContext context) {
    // Create an action log
    final actionLog = ActionLog(
      id: 'action_123',
      timestamp: DateTime.now(),
      category: 'action',
      tags: {'action'},
      eventId: 'action_123',
      actionId: 'button_tap',
      actionType: 'UserInteraction',
      status: ActionStatus.completed,
      sourceChain: ['ExamplePage', 'DemoButton'],
      triggerName: 'onTap',
      actionDefinition: {'type': 'demo'},
      resolvedParameters: {'buttonId': 'action_demo'},
    );

    _showSnackBar(context, 'Action logged: ${actionLog.actionType}');
  }

  /// Simple example demonstrating Digia Inspector Core usage
  void _demonstrateLogEvents(BuildContext context) {
    final event = CustomLogEvent(
      message: 'Demonstrating log event features',
      level: 'debug',
      category: 'demo',
      tags: {'example', 'showcase'},
    );

    // Demonstrate JSON serialization
    final json = event.toJson();

    // Demonstrate search
    final matches = event.matches('demo');

    _showSnackBar(
      context,
      'Event created with ${json.length} fields. Matches: $matches',
    );
  }

  /// Simple example demonstrating Digia Inspector Core usage
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Simple custom log event for demonstration
class CustomLogEvent extends DigiaLogEvent {
  /// Simple example demonstrating Digia Inspector Core usage
  CustomLogEvent({
    required this.message,
    required this.level,
    super.category,
    super.tags,
  });

  /// Simple example demonstrating Digia Inspector Core usage
  final String message;

  /// Simple example demonstrating Digia Inspector Core usage
  final String level;

  @override
  String get eventType => 'custom';

  @override
  String get title => 'Custom Log: $level';

  @override
  String get description => message;

  @override
  Map<String, dynamic> get metadata => {
    'message': message,
    'level': level,
  };
}
