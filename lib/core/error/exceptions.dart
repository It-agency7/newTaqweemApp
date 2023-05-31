
import 'auth_error_models.dart';

class OfflineException implements Exception {}
class ServerException implements Exception {}

class RegisterException implements Exception {
  final RegisterErrorModel registerErrorModel;
  RegisterException({
    required this.registerErrorModel,
  });
}

class LoginException implements Exception {
  final LoginErrorModel loginErrorModel;

  LoginException({
    required this.loginErrorModel,
  });
}
