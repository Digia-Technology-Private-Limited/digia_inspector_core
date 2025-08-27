import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test logger', () {
    final logger = NoOpLogger();
    logger.log(
      LogEvent.fromJson({
        'id': '123',
        'level': 'info',
        'timestamp': DateTime.now().toIso8601String(),
        'message': 'Test log message',
        'category': 'test',
        'tags': ['test'],
        'metadata': {'test': 'test'},
      }),
    );
  });
}
