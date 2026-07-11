abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other.runtimeType == runtimeType &&
          other is Failure &&
          other.message == message;

  @override
  int get hashCode => Object.hash(runtimeType, message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network Error']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
