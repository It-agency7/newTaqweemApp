import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/service/service_locator.dart';
import '../../../data/repo/auth_repo.dart';
import '../../../../../core/helpers/cache_helper.dart';

import 'states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final AuthRepository authRepository;
  LoginCubit({
    required this.authRepository,
  }) : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  var loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  IconData suffix = FontAwesomeIcons.eye;
  bool isPassword = true;

  changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility : Icons.visibility_off;

    emit(ChangeLoginPasswordVisibilityState());
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingInProgressState());
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    final failureOrRegister = await authRepository.login(
      email: email,
      password: password,
      fcmToken: fcmToken!,
    );

    failureOrRegister.fold(
      (failure) {
        emit(LoginLoadingFailState(error: failure.message));
      },
      (login) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userName', login.name);
        prefs.setString('email', login.email);
        emit(LoginLoadingSuccessState(loginModel: login));

        _saveToken(login.userToken);
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
