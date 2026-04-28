import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Application Logger for debugging and monitoring
class AppLogger {
  static final Logger _logger = Logger('Eatery');

  /// Initialize logger
  static void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final time = DateTime.now().toString().split('.')[0];
      debugPrint(
        '[${record.level.name}] $time - ${record.loggerName}: ${record.message}',
      );
      if (record.error != null) {
        debugPrint('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        debugPrint('StackTrace: ${record.stackTrace}');
      }
    });
  }

  /// Log info message
  static void info(String message) {
    _logger.info(message);
  }

  /// Log warning message
  static void warning(String message) {
    _logger.warning(message);
  }

  /// Log error message with optional error and stack trace
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Log debug message
  static void debug(String message) {
    _logger.fine(message);
  }

  /// Log fine-level debug message
  static void fine(String message) {
    _logger.finer(message);
  }

  /// Log very fine-level debug message
  static void veryFine(String message) {
    _logger.finest(message);
  }
}
