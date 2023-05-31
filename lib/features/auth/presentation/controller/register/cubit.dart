import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/helpers/cache_helper.dart';
import '../../../../../core/service/service_locator.dart';
import '../../../data/repo/auth_repo.dart';
import 'states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final AuthRepository authRepository;
  RegisterCubit({
    required this.authRepository,
  }) : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);
  var registerFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  IconData suffix = FontAwesomeIcons.eye;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash;

    emit(ChangeLoginPasswordVisibilityState());
  }

  Future<void> register({
    required String userName,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingInProgressState());
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    log('--FCM Token: $fcmToken');
    final failureOrRegister = await authRepository.register(
      userName: userName,
      email: email,
      password: password,
      fcmToken: fcmToken!,
    );

    failureOrRegister.fold(
      (failure) {
        emit(RegisterLoadingFailState(error: failure.message));
      },
      (register) async {
        emit(RegisterLoadingSuccessState(registerModel: register));
        _saveToken(register.userToken);
      },
    );
  }

  void _saveToken(String token) async {
    try {
      await sl<TaqwimPref>().saveToken(token);
      log('token from register function :)$token');
    } on Exception catch (e) {
      log('Error when save token in shared preferences$e');
    }
  }
}
