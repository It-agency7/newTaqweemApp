import 'package:equatable/equatable.dart';

class RegisterErrorModel extends Equatable {
  final String errorMessage;

  const RegisterErrorModel({
    required this.errorMessage,
  });

  factory RegisterErrorModel.fromJson(Map<String, dynamic> json) {
    return RegisterErrorModel(
      errorMessage: json['data']['email'][0],
    );
  }
  @override
  List<Object?> get props => [errorMessage];
}

class LoginErrorModel extends Equatable {
  final String errorMessage;

  const LoginErrorModel({
    required this.errorMessage,
  });

  factory LoginErrorModel.fromJson(Map<String, dynamic> json) =>
      LoginErrorModel(
        errorMessage: json['message'],
      );
  @override
  List<Object?> get props => [errorMessage];
}
