enum ErrorCode {
  // Authentication errors (1000-1099)
  AUTH_ERROR,
  ACCESS_DENIED,
  INVALID_TOKEN,
  TOKEN_EXPIRED,
  MISSING_AUTH,
  AUTHENTICATED,
  USER_NOT_FOUND,

  // User errors (1100-1199)
  USER_ERROR,
  INCORRECT_PASSWORD,
  USER_ALREADY_EXISTS,
  USER_NOT_ENABLED,

  // Resource errors (2000-2999)
  RESOURCE_ERROR,
  RESOURCE_NOT_FOUND,
  RESOURCE_ALREADY_EXISTS,
  RESOURCE_UPDATE_FAILED,

  // Validation errors (3000-3099)
  VALIDATION_ERROR,
  INVALID_PARAMS,
  INSUFFICIENT_INVENTORY,

  // Server errors (5000-5099)
  SERVER_ERROR,
  DATABASE_ERROR,
}

class APIException implements Exception {
  final ErrorCode code;
  final String message;

  APIException(this.code, this.message);

  @override
  String toString() => 'APIException: [$code] $message';
}

class AuthException extends APIException {
  AuthException(super.code, super.message);
}

class UserException extends APIException {
  UserException(super.code, super.message);
}

class ResourceException extends APIException {
  ResourceException(super.code, super.message);
}

class ValidationException extends APIException {
  ValidationException(super.code, super.message);
}

class ServerException extends APIException {
  ServerException(super.code, super.message);
}
