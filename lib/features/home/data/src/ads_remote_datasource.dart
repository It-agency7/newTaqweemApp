import 'dart:developer' as developer; 
import '../../../../core/client/dio_client.dart';
import '../../../../core/client/endpoints.dart';
import '../models/ad_model.dart';

class AdsRemoteDataSource {
  final DioClient _dioClient;
  AdsRemoteDataSource(this._dioClient);

  Future<AdsModel> getAllAds() async {
    final response = await _dioClient.get(path: Endpoints.adsEP);
    if (response.statusCode == 200) {
      final model = AdsModel.fromJson(response.data);
      developer.log('ADS MODEL: $model.statusCode = ${response.statusCode}.statusCode');
      return model;
    } else {
      throw Exception('Failed to load ads: ${response.statusCode}');
    }
  }
}
