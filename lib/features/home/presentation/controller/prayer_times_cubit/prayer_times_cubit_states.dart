import '../../../data/models/prayer_times_model.dart';

abstract class PrayerTimesState {
  final DateTime chosenDateTime;

  PrayerTimesState({required this.chosenDateTime});
}

class PrayerTimesLoadingInProgress extends PrayerTimesState {
  PrayerTimesLoadingInProgress([DateTime? date])
      : super(chosenDateTime: date ?? DateTime.now());
}

class PrayerTimesLoadingSuccess extends PrayerTimesState {
  final List<PrayerTimesModel> prayerTimesList;
  PrayerTimesLoadingSuccess({
    required this.prayerTimesList,
    required super.chosenDateTime,
  });
}

class PrayerTimesLoadingFail extends PrayerTimesState {
  final String errorMessage;

  PrayerTimesLoadingFail({
    required this.errorMessage,
    required super.chosenDateTime,
  });
}
