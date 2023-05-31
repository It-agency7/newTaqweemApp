part of 'ads_cubit.dart';

abstract class AdsStates extends Equatable {
  const AdsStates();

  @override
  List<Object> get props => [];
}

class AdsLoadingInProgressState extends AdsStates {}

class AdsLoadingSuccessState extends AdsStates {
  final AdsModel adsList;
  const AdsLoadingSuccessState({required this.adsList});
}

class AdsLoadingFailedState extends AdsStates {}
