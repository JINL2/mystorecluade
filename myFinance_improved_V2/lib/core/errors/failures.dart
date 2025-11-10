import 'package:equatable/equatable.dart';

/// Base failure class for all domain errors
///
/// Used with Result<S, Failure> for type-safe error handling.
///
/// ✅ Benefits:
/// - Sealed class pattern for exhaustive error handling
/// - User-friendly error messages
/// - Machine-readable error codes
/// - Equatable for easy comparison
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.code,
  });

  /// User-friendly error message
  final String message;

  /// Machine-readable error code
  final String code;

  @override
  List<Object?> get props => [message, code];
}

/// Server/Database failure (Supabase errors)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required super.code,
  });

  /// Factory for common server errors
  factory ServerFailure.database([String? details]) {
    return ServerFailure(
      message: details ?? '데이터베이스 오류가 발생했습니다',
      code: 'SERVER_ERROR',
    );
  }

  @override
  String toString() => 'ServerFailure(message: $message, code: $code)';
}

/// Validation failure (input validation errors)
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    required super.code,
  });

  @override
  String toString() => 'ValidationFailure(message: $message, code: $code)';
}

/// Authentication failure (user not logged in)
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    required super.code,
  });

  @override
  String toString() => 'AuthFailure(message: $message, code: $code)';
}

/// Permission failure (insufficient permissions)
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    required super.code,
  });

  @override
  String toString() => 'PermissionFailure(message: $message, code: $code)';
}

/// Not found failure (resource not found)
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    required super.code,
  });

  @override
  String toString() => 'NotFoundFailure(message: $message, code: $code)';
}

/// Network failure (connectivity issues)
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    required super.code,
  });

  /// Factory for common network errors
  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: '인터넷 연결을 확인해주세요',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: '요청 시간이 초과되었습니다',
      code: 'TIMEOUT',
    );
  }

  @override
  String toString() => 'NetworkFailure(message: $message, code: $code)';
}

/// Unknown failure (unexpected errors)
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    required super.code,
  });

  @override
  String toString() => 'UnknownFailure(message: $message, code: $code)';
}
