import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../../core/client/dio_client.dart';
import '../../../../core/client/endpoints.dart';
import '../models/login_model.dart';
import '../../../../core/error/auth_error_models.dart';
import '../../../../core/error/exceptions.dart';
import '../models/register_model.dart';

class AuthWebServices {
  final DioClient _dioClient;
  AuthWebServices(this._dioClient);

  Future<RegisterModel> register({
    required String userName,
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": userName,
        "email": email,
        "password": password,
        "fcm": fcmToken,
      };
      final response = await _dioClient.post(
        path: Endpoints.registerEP,
        data: data,
      );

      if (response.statusCode == 200) {
        final model = RegisterModel.fromJson(response.data);
        log('$model');
        return model;
      } else {
        throw RegisterException(
          registerErrorModel: RegisterErrorModel.fromJson(response.data),
        );
      }
    } on DioError catch (error) {
      // print(error.message);
      final response = error.response;
      if (response != null) {
        log(response.data);
        throw RegisterException(
          registerErrorModel: RegisterErrorModel.fromJson(response.data),
        );
      } else {
        throw ServerException();
      }
    }
  }

  Future<LoginModel> login({
    required String email,
    required String password,
    required String fcmToken,
  }) async {
    try {
      Map<String, dynamic> data = {
        "username": email,
        "password": password,
        "fcm": fcmToken,
      };
      final response = await _dioClient.post(
        path: Endpoints.loginEP,
        data: data,
      );
      if (response.statusCode == 200) {
        final model = LoginModel.fromJson(response.data);
        return model;
      } else {
        throw LoginException(
          loginErrorModel: LoginErrorModel.fromJson(response.data),
        );
      }
    } on DioError catch (error) {
      // print(error.message);
      final response = error.response;
      if (response != null) {
        log(response.data);
        throw LoginException(
          loginErrorModel: LoginErrorModel.fromJson(response.data),
        );
      } else {
        throw ServerException();
      }
    }
  }
}
