/// Base UseCase Interface
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// No Parameters
class NoParams {
  const NoParams();
}
