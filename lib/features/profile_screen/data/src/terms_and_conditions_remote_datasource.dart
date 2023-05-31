import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/client/dio_client.dart';
import '../../../../core/client/endpoints.dart';
import '../../../auth/presentation/screens/login.dart';

class TermsAndConditionsRemoteDataSource {
  final DioClient _dioClient;
  TermsAndConditionsRemoteDataSource(this._dioClient);

  Future<String> getTermsAndConditions() async {
    final response = await _dioClient.get(path: Endpoints.termsAndConditionsEP);

    if (response.statusCode == 200) {
      return response.data['data']['terms_and_conditions'];
    }
    throw Exception('Failed to load terms and conditions');
  }

  Future<void> deleteAccount(BuildContext context) async {
    final response = await _dioClient.delete(path: Endpoints.deleteAccountEP);

    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
    }
    throw Exception('Failed to delete account');
  }

  Future<int> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await _dioClient.post(
          path: Endpoints.passwordReset, data: {
        'current_password': oldPassword,
        'new_password': newPassword,
      });

      if (response.statusCode == 200) {
        Get.showSnackbar(GetSnackBar(
          message: response.data['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ));
        return response.statusCode ?? 200;
      }
      Get.showSnackbar(GetSnackBar(
        message: response.data['message'] ?? 'Failed to change password',
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
      return response.statusCode ?? 400;
    }catch(e){
      Get.showSnackbar(GetSnackBar(
        message: 'Failed to change password',
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
      return 400;
    }
    throw Exception('Failed to change password');
  }
}
