/// Core debugging interfaces and contracts for Digia applications.
///
/// This library provides the foundation for debugging and logging capabilities
/// that can be shared across different Digia packages without introducing
/// UI dependencies.
library digia_inspector_core;

// Core contracts and interfaces
export 'src/contracts/digia_dio_interceptor.dart';
export 'src/contracts/digia_logger.dart';
export 'src/contracts/action_observer.dart';

// Base models
export 'src/models/log_event.dart';
export 'src/models/action_log.dart';
export 'src/models/observability_context.dart';

// Network logging models (new, improved organization)
export 'src/models/network_request_log.dart';
export 'src/models/network_response_log.dart';
export 'src/models/network_error_log.dart';

// Utilities
export 'src/utils/log_level.dart';
export 'src/utils/timestamp_helper.dart';
