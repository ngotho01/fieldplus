class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode});
}

class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode});
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

class OfflineException extends AppException {
  const OfflineException() : super('No internet connection.');
}

class ConflictException extends AppException {
  final int serverVersion;
  final String serverStatus;

  const ConflictException({
    required this.serverVersion,
    required this.serverStatus,
  }) : super('Conflict detected with server version.');
}

class ValidationException extends AppException {
  final List<String> errors;
  ValidationException(this.errors) : super(errors.join(', '));
}