/// Base UseCase Interface
///
/// Defines the contract for all use cases in the time table management domain.
/// UseCases encapsulate single business operations and orchestrate domain logic.
///
/// Type Parameters:
/// - [Type]: The return type of the use case
/// - [Params]: The parameters required to execute the use case
abstract class UseCase<Type, Params> {
  /// Execute the use case with the given parameters
  ///
  /// Returns [Future<Type>] with the result of the operation
  Future<Type> call(Params params);
}

/// No Parameters Class
///
/// Used when a use case doesn't require any parameters
class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => 0;
}
