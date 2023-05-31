import 'package:equatable/equatable.dart';
import '../../../data/models/login_model.dart';

abstract class LoginStates extends Equatable {
  const LoginStates();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginStates {}

class ChangeLoginPasswordVisibilityState extends LoginStates {}

class LoginLoadingInProgressState extends LoginStates {}

class LoginLoadingSuccessState extends LoginStates {
  final LoginModel loginModel;

  const LoginLoadingSuccessState({
    required this.loginModel,
  });

  @override
  List<Object?> get props => [loginModel];
}

class LoginLoadingFailState extends LoginStates {
  final String error;
  const LoginLoadingFailState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}