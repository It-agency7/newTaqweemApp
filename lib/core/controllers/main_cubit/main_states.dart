import '../../models/app_data.dart';

abstract class MainStates {}

class HomeInitial extends MainStates {}

class HomeLoadingInProgress extends MainStates {}

class HomeLoadingSuccess extends MainStates {
  final ApplicationDataModel applicationDataModel;
  final bool notificationStatus;
  final double volume;
  final String selectedCity;
  final String lang;
  final String tone;
  final String startDay;
  HomeLoadingSuccess(this.applicationDataModel, this.notificationStatus, this.volume, this.selectedCity, this.lang, this.tone, this.startDay);
}

class HomeLoadingFailure extends MainStates {
  final String error;

  HomeLoadingFailure(this.error);
}

class HomeGetNotificationStatusSuccess extends MainStates {
  final bool status;

  HomeGetNotificationStatusSuccess(this.status);
}