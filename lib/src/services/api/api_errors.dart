enum ErrorCode {
  // Authentication errors (1000-1099)
  AUTH_ERROR(1000),
  ACCESS_DENIED(1001),
  INVALID_TOKEN(1002),
  TOKEN_EXPIRED(1003),
  MISSING_AUTH(1004),
  AUTHENTICATED(1005),
  USER_NOT_FOUND(1006),

  // User errors (1100-1199)
  USER_ERROR(1100),
  INCORRECT_PASSWORD(1102),
  USER_ALREADY_EXISTS(1103),
  USER_NOT_ENABLED(1104),

  // Resource errors (2000-2999)
  RESOURCE_ERROR(2000),
  RESOURCE_NOT_FOUND(2001),
  RESOURCE_ALREADY_EXISTS(2002),
  RESOURCE_UPDATE_FAILED(2003),
  INVALID_STATUS_TRANSITION(2004),

  // Validation errors (3000-3099)
  VALIDATION_ERROR(3000),
  INVALID_PARAMS(3001),
  INSUFFICIENT_INVENTORY(3002),

  // Server errors (5000-5099)
  SERVER_ERROR(5000),
  DATABASE_ERROR(5001);

  const ErrorCode(this.value);
  final int value;
}

class APIException implements Exception {
  final ErrorCode code;
  final String message;
  final int errorCode;

  APIException(this.code, this.message, this.errorCode);

  @override
  String toString() => 'APIException: [$code] $message';
}

class AuthException extends APIException {
  AuthException(super.code, super.message, super.errorCode);
}

class UserException extends APIException {
  UserException(super.code, super.message, super.errorCode);
}

class ResourceException extends APIException {
  ResourceException(super.code, super.message, super.errorCode);
}

class ValidationException extends APIException {
  ValidationException(super.code, super.message, super.errorCode);
}

class ServerException extends APIException {
  ServerException(super.code, super.message, super.errorCode);
}
