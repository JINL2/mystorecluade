// lib/core/types/result.dart

/// Result type for representing success or failure operations
///
/// This provides compile-time safety for error handling by making
/// success and failure states explicit in the type system.
///
/// ✅ Benefits:
/// - Type-safe error handling
/// - Forces explicit error handling (no forgotten try-catch)
/// - IDE support with pattern matching
/// - Clear distinction between success and failure
///
/// Usage:
/// ```dart
/// Future<Result<User, AuthFailure>> login(String email, String password) async {
///   try {
///     final user = await authService.login(email, password);
///     return Success(user);
///   } catch (e) {
///     return ResultFailure(AuthFailure.network());
///   }
/// }
///
/// // Using the result
/// final result = await login('user@example.com', 'password');
/// switch (result) {
///   case Success(value: final user):
///     print('Welcome ${user.name}');
///   case ResultFailure(error: final error):
///     print('Login failed: ${error.message}');
/// }
/// ```
sealed class Result<S, F> {
  const Result();

  /// Returns true if this is a Success
  bool get isSuccess => this is Success<S, F>;

  /// Returns true if this is a ResultFailure
  bool get isFailure => this is ResultFailure<S, F>;

  /// Execute different functions based on success or failure
  T when<T>({
    required T Function(S value) success,
    required T Function(F error) failure,
  }) {
    return switch (this) {
      Success(value: final value) => success(value),
      ResultFailure(error: final error) => failure(error),
    };
  }

  /// Execute different functions based on success or failure (async version)
  Future<T> whenAsync<T>({
    required Future<T> Function(S value) success,
    required Future<T> Function(F error) failure,
  }) async {
    return switch (this) {
      Success(value: final value) => await success(value),
      ResultFailure(error: final error) => await failure(error),
    };
  }

  /// Get the success value or null
  S? get successOrNull => switch (this) {
        Success(value: final value) => value,
        _ => null,
      };

  /// Get the failure error or null
  F? get failureOrNull => switch (this) {
        ResultFailure(error: final error) => error,
        _ => null,
      };
}

/// Represents a successful operation
final class Success<S, F> extends Result<S, F> {
  final S value;

  const Success(this.value);

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<S, F> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed operation
final class ResultFailure<S, F> extends Result<S, F> {
  final F error;

  const ResultFailure(this.error);

  @override
  String toString() => 'ResultFailure($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<S, F> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
