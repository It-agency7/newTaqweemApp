import 'package:equatable/equatable.dart';

class RegisterModel extends Equatable {
  final String userToken;
  final String name;
  final String email;
  final String message;
  final bool status;

  const RegisterModel({
    required this.userToken,
    required this.name,
    required this.email,
    required this.message,
    required this.status,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    // print(json);
    return RegisterModel(
      userToken: json['data']['token'],
      name: json['data']['user']['name'],
      email: json['data']['user']['email'],
      message: json['message'],
      status: json['status'],
    );
  }

  @override
  List<Object?> get props => [
        userToken,
        name,
        email,
        message,
        status,
      ];
}
