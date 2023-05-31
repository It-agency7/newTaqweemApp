import 'dart:developer';

import 'package:taqwim/core/client/dio_client.dart';
import 'package:taqwim/core/models/app_data.dart';

class AppDataRemoteDataSource{
  final DioClient _dioClient;
  AppDataRemoteDataSource(this._dioClient);

  Future<ApplicationDataModel> getAppData() async {
    final response = await _dioClient.get(path: 'app');
    if(response.statusCode == 200){
      final result = ApplicationDataModel.fromJson(response.data['data']);
      log('Data MODEL: $result.\nstatusCode = ${response.statusCode}.statusCode.');
      return result;
    }else{
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}