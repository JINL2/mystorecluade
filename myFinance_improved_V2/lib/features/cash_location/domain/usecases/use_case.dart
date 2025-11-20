// Base Use Case Interface
// Simple abstraction for business logic operations

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}
