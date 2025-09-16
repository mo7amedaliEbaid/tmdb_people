class ApiException implements Exception {
  final String message;

  ApiException([this.message = 'ApiException']);

  @override
  String toString() => 'ApiException: $message';
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'UnauthorizedException']);
}

class NotFoundException extends ApiException {
  NotFoundException([super.message = 'NotFoundException']);
}

class ServerException extends ApiException {
  ServerException([super.message = 'ServerException']);
}

class NetworkException extends ApiException {
  NetworkException([super.message = 'NetworkException']);
}
