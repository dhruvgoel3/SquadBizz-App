import 'package:logger/logger.dart';

/// Global logger instance for SquadBizz.
///
/// Usage:
/// ```dart
/// import 'package:squadbizz/core/utils/app_logger.dart';
///
/// AppLogger.d('Debug message');
/// AppLogger.i('Info message');
/// AppLogger.w('Warning message');
/// AppLogger.e('Error message', error: exception, stackTrace: stack);
/// ```
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: Level.debug,
  );

  /// Debug — verbose development info.
  static void d(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Info — noteworthy events (API calls, navigation).
  static void i(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning — potential issues.
  static void w(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error — failures, exceptions.
  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Fatal — app-crashing errors.
  static void f(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log an API call with endpoint and method.
  static void api(String method, String endpoint, {int? statusCode}) {
    _logger.i(
      '🌐 API [$method] $endpoint${statusCode != null ? ' → $statusCode' : ''}',
    );
  }

  /// Log a BLoC event.
  static void bloc(String blocName, String event) {
    _logger.d('🧊 $blocName → $event');
  }
}
