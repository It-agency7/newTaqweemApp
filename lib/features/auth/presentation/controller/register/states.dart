import 'package:equatable/equatable.dart';

import '../../../data/models/register_model.dart';

abstract class RegisterStates extends Equatable {
  const RegisterStates();
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterStates {}

class RegisterLoadingInProgressState extends RegisterStates {}

class RegisterLoadingSuccessState extends RegisterStates {
  final RegisterModel registerModel;

  const RegisterLoadingSuccessState({
    required this.registerModel,
  });

  @override
  List<Object?> get props => [registerModel];
}

class RegisterLoadingFailState extends RegisterStates {
  final String error;
  const RegisterLoadingFailState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class ChangeLoginPasswordVisibilityState extends RegisterStates {}
