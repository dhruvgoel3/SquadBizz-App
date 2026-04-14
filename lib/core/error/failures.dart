import 'package:equatable/equatable.dart';

/// Base failure class for the domain layer.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure from the server/backend (Supabase).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure due to network issues.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Please check your internet connection.']);
}

/// Failure due to authentication issues.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure due to cache/local storage issues.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error.']);
}

/// Failure for unknown/unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong. Please try again.']);
}
