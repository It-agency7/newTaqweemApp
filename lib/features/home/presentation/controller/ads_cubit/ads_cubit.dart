import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repo/ads_repo.dart';

import '../../../data/models/ad_model.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsStates> {
  final AdsRepo adsRepo;
  AdsCubit(this.adsRepo) : super(AdsLoadingInProgressState()) {
    _loadAds();
  }

  void _loadAds() async {
    final ads = await adsRepo.getAllAds();
    ads.data.add(ads.data.first);
    emit(AdsLoadingSuccessState(adsList: ads));
  }
}
