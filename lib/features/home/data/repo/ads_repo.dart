import '../src/ads_remote_datasource.dart';

import '../models/ad_model.dart';

class AdsRepo {
  final AdsRemoteDataSource adsRemoteDataSource;

  AdsRepo(this.adsRemoteDataSource);
  


  Future<AdsModel> getAllAds() async {
    return await adsRemoteDataSource.getAllAds();
  }
}
