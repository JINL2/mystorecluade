import 'package:equatable/equatable.dart';

/// Base failure class for all domain errors
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
