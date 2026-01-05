/// Retry Helper - Exponential Backoff Utility
///
/// Provides retry logic with exponential backoff for RPC calls.
/// Prevents excessive API calls when errors occur.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Retry configuration
class RetryConfig {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;

  const RetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 10),
  });

  /// Default configuration for RPC calls
  static const rpc = RetryConfig(
    maxRetries: 3,
    initialDelay: Duration(seconds: 1),
    backoffMultiplier: 2.0,
    maxDelay: Duration(seconds: 8),
  );

  /// Light configuration for non-critical calls
  static const light = RetryConfig(
    maxRetries: 2,
    initialDelay: Duration(milliseconds: 500),
    backoffMultiplier: 2.0,
    maxDelay: Duration(seconds: 4),
  );
}

/// Retry helper with exponential backoff
///
/// Example usage:
/// ```dart
/// final result = await RetryHelper.withRetry(
///   () => myRpcCall(),
///   config: RetryConfig.rpc,
///   onRetry: (attempt, error) => debugPrint('Retry $attempt: $error'),
/// );
/// ```
class RetryHelper {
  /// Execute a function with retry logic
  ///
  /// [action] - The async function to execute
  /// [config] - Retry configuration (default: RetryConfig.rpc)
  /// [onRetry] - Optional callback called before each retry
  /// [shouldRetry] - Optional function to determine if error is retryable
  static Future<T> withRetry<T>(
    Future<T> Function() action, {
    RetryConfig config = RetryConfig.rpc,
    void Function(int attempt, Object error)? onRetry,
    bool Function(Object error)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = config.initialDelay;

    while (true) {
      try {
        attempt++;
        return await action();
      } catch (e) {
        // Check if we should retry this error
        final canRetry = shouldRetry?.call(e) ?? _isRetryableError(e);

        if (!canRetry || attempt >= config.maxRetries) {
          debugPrint('❌ [RetryHelper] Failed after $attempt attempts: $e');
          rethrow;
        }

        // Call retry callback if provided
        onRetry?.call(attempt, e);

        debugPrint('🔄 [RetryHelper] Attempt $attempt failed, retrying in ${delay.inMilliseconds}ms...');

        // Wait before retrying
        await Future.delayed(delay);

        // Calculate next delay with exponential backoff
        delay = Duration(
          milliseconds: (delay.inMilliseconds * config.backoffMultiplier).toInt(),
        );

        // Cap delay at max
        if (delay > config.maxDelay) {
          delay = config.maxDelay;
        }
      }
    }
  }

  /// Check if an error is retryable
  ///
  /// Returns true for network errors, timeouts, and server errors (5xx)
  static bool _isRetryableError(Object error) {
    final errorString = error.toString().toLowerCase();

    // Network/connection errors
    if (errorString.contains('socket') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('network')) {
      return true;
    }

    // Server errors (5xx)
    if (errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504')) {
      return true;
    }

    // Rate limiting
    if (errorString.contains('429') ||
        errorString.contains('rate limit') ||
        errorString.contains('too many requests')) {
      return true;
    }

    // Default: don't retry (client errors like 400, 401, 404)
    return false;
  }
}
