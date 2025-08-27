/// Core debugging interfaces and contracts for Digia applications.
///
/// This library provides the foundation for debugging and logging capabilities
/// that can be shared across different Digia packages without introducing
/// UI dependencies.
library digia_inspector_core;

export 'src/contracts/digia_logger.dart';
export 'src/contracts/logger_extensions.dart';
export 'src/models/log_event.dart';
export 'src/models/network_log.dart';
export 'src/models/error_log.dart';
export 'src/utils/log_level.dart';
export 'src/utils/timestamp_helper.dart';
export 'src/utils/environment.dart';
